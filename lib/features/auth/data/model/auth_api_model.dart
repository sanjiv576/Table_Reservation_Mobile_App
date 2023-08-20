import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';

final authApiModelProvider =
    Provider.autoDispose((ref) => AuthApiModel.empty());

@JsonSerializable()
class AuthApiModel {
  @JsonKey(name: 'id')
  final String? id;
  final String fullName;
  final String contact;
  final String role;
  final String email;
  final String username;
  // final String password;
  final String? picture;

  AuthApiModel({
    this.id,
    required this.fullName,
    required this.contact,
    required this.role,
    required this.email,
    required this.username,
    // required this.password,
    this.picture,
  });

  // empty inital values

  AuthApiModel.empty()
      : this(
          id: '',
          fullName: '',
          contact: '',
          role: '',
          email: '',
          username: '',
          // password: '',
          picture: '',
        );

  // for conversion of JSON into user entity
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      id: json['id'],
      fullName: json['fullName'],
      contact: json['contact'],
      role: json['role'],
      email: json['email'],
      username: json['username'],
      // password: json['password'],
    );
  }

// convert user object into JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'contact': contact,
      'role': role,
      'email': email,
      'username': username,
      // 'password': password,
      'picture': picture,
    };
  }
}
