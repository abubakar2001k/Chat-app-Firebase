
import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/model/userModel.dart';

class HomeController extends ChangeNotifier {
  Map<String, String> requestStatus = {};
  List<UserModel> _users = [];
  Map<String, bool> requestaccepted = {};
  List<Requests> pendingRequests = [];

  List<Requests> acceptRequests = [];

  List<UserModel> get users => _users;

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  HomeController() {
    fetchAllUsers();
    fetchCurrentUser();
    // fetchCurrentUser();
  }

  Future<void> fetchAllUsers() async {
    try {
      final DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users");
      // Fetch all users data from Firebase
      final snapshot = await usersRef.get();

      if (snapshot.exists) {
        print("Fetched all users data: ${snapshot.value}");

        // Ensure snapshot.value is in the correct format (Map<String, dynamic>)
        Map<dynamic, dynamic> usersMap = snapshot.value as Map<dynamic, dynamic>;
        // Convert the data into a list of UserModel objects
        _users = usersMap.entries.map((entry) {
          // Safely handle the data, ensure it's correctly cast into a Map<String, dynamic>
          return UserModel.fromJson(Map<String, dynamic>.from(entry.value));
        }).toList();
        // Notify listeners that the data has been updated
        notifyListeners();

        // Fetch users who sent requests to the current user

        debugPrint("Total Users: ${_users.length}");
      } else {
        print("No user data found.");
      }
    } catch (e) {
      print("Error fetching all users data: $e");
    }
  }

  Future<Map<String, dynamic>?> fetchRecentMessage(String otherUserId) async {
    try {
      // Get the current user
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User is not logged in");
      }
      final String currentUserId = user.uid;

      // Determine the chat ID
      final String chatId =
          currentUserId.compareTo(otherUserId) < 0 ? "$currentUserId-$otherUserId" : "$otherUserId-$currentUserId";

      // Reference the specific chat in the database
      final DatabaseReference chatRef = FirebaseDatabase.instance.ref("chats/$chatId/messages");
      // final DatabaseReference chatRef = FirebaseDatabase.instance.ref("chats");
      // Fetch the messages and sort them by timestamp
      final DataSnapshot snapshot = await chatRef.orderByChild("timestamp").limitToLast(1).get();

      if (snapshot.exists) {
        // Get the most recent message
        final Map<String, dynamic> messagesMap = Map<String, dynamic>.from(snapshot.value as Map);
        final String key = messagesMap.keys.first; // Get the first (latest) key
        return Map<String, dynamic>.from(messagesMap[key] as Map);
      }
      notifyListeners();
      return null;
      // notifyListeners();
    } catch (e) {
      print("Error fetching recent message: $e");
      return null;
    }
  }

// Fetch current user
  Future<void> fetchCurrentUser() async {
    debugPrint("@home_controller => fetchCurrentUser");
    if (pendingRequests.isNotEmpty) {
      pendingRequests.clear();
    }
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No user is currently authenticated.");
        return;
      }

      final String uid = user.uid;
      final DatabaseReference userRef = FirebaseDatabase.instance.ref("users/$uid");

      final snapshot = await userRef.get();

      if (snapshot.exists) {
        print("Fetched current user data: ${snapshot.value}");
        _currentUser = UserModel.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
        notifyListeners();

        // Fetch users who sent requests to the current user
        final requestsRef = FirebaseDatabase.instance.ref("users/$uid/requests");
        final requestsSnapshot = await requestsRef.get();

        if (requestsSnapshot.exists) {
          // Get the total number of requests
          int totalRequests = (requestsSnapshot.value as Map).length;

          // Fetch only pending requests
          pendingRequests = (requestsSnapshot.value as Map)
              .entries
              .where((entry) => entry.value["status"].toString().toLowerCase().contains("pending"))
              .map((entry) => Requests.fromJson(Map<String, dynamic>.from(entry.value)))
              .toList();
          // new I add the ato currect accept request  to currect users
          acceptRequests = (requestsSnapshot.value as Map)
              .entries
              .where((entry) => entry.value["status"].toString().toLowerCase().contains("accepted"))
              .map((entry) => Requests.fromJson(Map<String, dynamic>.from(entry.value)))
              .toList();
          notifyListeners();

          debugPrint("Total requests: $totalRequests");
          debugPrint("Accept Requests: $acceptRequests");
          debugPrint("Pending requests: $pendingRequests");
        } else {
          print("No requests found for the current user.");
        }
      } else {
        print("No data found for the current user.");
      }
    } catch (e) {
      print("Error fetching current user data: $e");
    }
  }

  Future<String> fetchRequesterName(String userId) async {
    try {
      final userRef = FirebaseDatabase.instance.ref("users/$userId");
      final snapshot = await userRef.get();
      if (snapshot.exists) {
        final userData = Map<String, dynamic>.from(snapshot.value as Map);
        // final userName = userData['name'] ?? '';
        // final userEmail = userData['email'] ?? '';
        final user = UserModel.fromJson(userData);
        return user.name ?? '';
        notifyListeners();
      }
      return 'Unknown';
    } catch (e) {
      print("Error fetching requester's name: $e");
      return 'Unknown';
    }
  }

  Future<void> userRequest(UserModel userlist) async {
    try {
      final User? user = _auth.currentUser;
      final String uid = user!.uid;
      // Step 1: Get the currently logged-in user
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print("Error: No user is logged in.");
        return; // Exit if no user is logged in
      }

      String currentUserId = currentUser.uid;

      // Step 2: Ensure the target user has a valid userId
      if (userlist.userId == null || userlist.userId!.isEmpty) {
        print("Error: Target user ID is null or empty for ${userlist.name}.");
        return; // Exit if target user ID is invalid
      }

      String targetUserId = userlist.userId!;
      Requests requests = Requests(
        status: 'pending',
        requestedBy: currentUserId,
        acceptedBy: "",
        timestamp: DateTime.now().toIso8601String(),
      );

      print("Debug: userlist: ${userlist.toString()}");
      print("Debug: Current User ID: $currentUserId");
      print("Debug: Target User ID: $targetUserId");

      // Step 3: Reference the target user's requests node in Firebase
      final userRef = FirebaseDatabase.instance.ref('users/$targetUserId/requests/$currentUserId');
      await userRef.set(requests.toJson());

      requestStatus[targetUserId] = "pending";
      notifyListeners();

      print('Request sent successfully to $targetUserId.');
    } catch (e) {
      print('Error in userRequest method: $e');
    }
  }
  Future<void> acceptRequest(UserModel user) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        print("Error: No user is logged in.");
        return;
      }

      String currentUserId = currentUser.uid;
      String targetUserId = user.userId!; // Ensure that userId is not null

      print("Debug: Current User currentUserId: $currentUserId");
      print("Debug: Target User targetUserId: $targetUserId");

      Requests requests = Requests(
        status: 'accepted',
        requestedBy: targetUserId, // This should come from the request being accepted
        acceptedBy: currentUserId,
        timestamp: DateTime.now().toIso8601String(),
      );

      // Reference the target user's requests node in Firebase
      // final userRef = FirebaseDatabase.instance.ref('users/$targetUserId/requests/$currentUserId');
      final userRef = FirebaseDatabase.instance.ref('users/$currentUserId/requests/$targetUserId');
      // await userRef.set(requests.toJson());
      // Send the request with "accepted" status
      await userRef.set(requests.toJson());

      // Update state
      // requestaccepted[currentUserId] = true;
      requestaccepted[targetUserId] = true;
      notifyListeners(); // Notify listeners after updating the map

      print('Request successfully accepted for $targetUserId.');
    } catch (e) {
      print('Error in acceptRequest method: $e');
      notifyListeners(); // Ensure listeners are notified of the failure
    }
  }

  Future<void> logout({required BuildContext context}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Check if there is a current user
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.uid.isNotEmpty) {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

    // if (prefs != null && FirebaseAuth.instance.currentUser!.uid.isNotEmpty) {
    //   // Sign out from Firebase
    //   await FirebaseAuth.instance.signOut();
    //
      // Clear preferences
      await prefs.clear();

      _currentUser = null;

      // Navigate to LoginPage
      Navigator.pushReplacementNamed(context, '/login_page');
    }
  }
}
