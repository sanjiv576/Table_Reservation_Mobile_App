import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String fullName;
  final String contact;
  final String role;
  final String email;
  final String username;
  final String? password;
  final String? picture;
  final String? restaurantId;

  const UserEntity({
    this.id,
    required this.fullName,
    required this.contact,
    required this.role,
    required this.email,
    required this.username,
    this.password,
    this.picture,
    this.restaurantId,
  });

// for conversion of JSON into entity
  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      fullName: json['fullName'],
      contact: json['contact'],
      role: json['role'],
      email: json['email'],
      picture: json['picture'],
      username: json['username'],
      password: json['password'],
      restaurantId: json['restaurantId'],
    );
  }

// convert user  object into JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'contact': contact,
      'role': role,
      'email': email,
      'username': username,
      'password': password,
      'picture': picture,
      'restaurantId': restaurantId
    };
  }

  @override
  List<Object?> get props =>
      [id, fullName, contact, role, email, username, password, picture, restaurantId];

  @override
  String toString() {
    return 'Full name : $fullName\nRole : $role\nUserId : $id\nUsername : $username\nEmail : $email';
  }
}
