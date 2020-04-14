import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String displayName;
  String email;
  String password;
  String image;
  Timestamp createdAt;
  Timestamp updatedAt;
  User();

  User.fromMap(Map<String, dynamic> data) {
    displayName = data['displayName'];
    email = data['email'];
    image = data['image'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'image': image,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }


}
