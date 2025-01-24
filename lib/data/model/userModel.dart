class UserModel {
  final String? name;
  final String? userId;
  final String? email;
  final String? password;
  final Map<String, Requests>? requests;  // Corrected to Map
  final Requests? status;
  final String? fcmToken;


  UserModel({
    this.userId,
    this.password,
    this.name,
    this.email,
    this.status,
    this.requests,
    this.fcmToken,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String?,
      // fcmToken: json['fcmToken'],
      userId: json['userId'] as String?,
      email: json['email'] as String?,
      fcmToken: json['fcmToken'],
      password: json['password'] as String?,
      requests: json['requests'] != null
          ? (json['requests'] as Map).map(
            (key, value) => MapEntry(
          key.toString(),
          Requests.fromJson(Map<String, dynamic>.from(value as Map)),
        ),
      )
          : null,
      status: json['status'] != null
          ? Requests.fromJson(Map<String, dynamic>.from(json['status'] as Map))
          : null,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'userId': userId,
      'password': password,
      'fcmToken' : fcmToken,
      'requests': requests?.map((key, value) => MapEntry(key, value.toJson())),
    };
  }
}

class Requests {
  final String? status;
  final String? requestedBy;
  final String? acceptedBy;
  final String? timestamp;

  Requests({this.status, this.requestedBy,this.acceptedBy, this.timestamp});

  factory Requests.fromJson(Map<String, dynamic> json) {
    return Requests(
      status: json['status'],
      requestedBy: json['requestedBy'],
      timestamp: json['timestamp'],
      acceptedBy: json['acceptedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'acceptedBy' : acceptedBy,
      'requestedBy': requestedBy,
      'timestamp': timestamp,
    };
  }
}


class Message {
  final String? serderId;
  final String? content;
  final String? timestampchat;

  Message({ this.content, this.timestampchat, this.serderId });
  factory Message.formJson(Map<String, dynamic> json) {
    return Message(
      serderId: json['serderId'],
      content: json['content'],
      timestampchat: json['timestampchat'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serderId' : serderId,
      'content' : content,
      'timestampchat' :  timestampchat,
    };
  }
}

