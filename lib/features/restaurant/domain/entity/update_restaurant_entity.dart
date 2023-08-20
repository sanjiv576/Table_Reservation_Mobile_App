import 'package:equatable/equatable.dart';

class UpdateRestaurantEntity extends Equatable {
  final String name;
  final String location;
  final String fullName;
  final String contact;
  final String email;
  final String username;
  final String password;

  const UpdateRestaurantEntity({
    required this.name,
    required this.location,
    required this.fullName,
    required this.contact,
    required this.email,
    required this.username,
    required this.password,
  });

  // convert to JSON object
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'fullName': fullName,
      'contact': contact,
      'email': email,
      'username': username,
      'password': password,
    };
  }

  // convert from JSON object to entity
  factory UpdateRestaurantEntity.fromJson(Map<String, dynamic> json) {
    return UpdateRestaurantEntity(
      name: json['name'],
      location: json['location'],
      fullName: json['fullName'],
      contact: json['contact'],
      email: json['email'],
      username: json['username'],
      password: json['password'],
    );
  }

  @override
  List<Object?> get props =>
      [name, location, fullName, contact, email, username, password];

  @override
  String toString() {
    return 'Restaurant name : $name, location : $location, fullName : $fullName, contact : $contact, email : $email, username : $username, password : $password';
  }
}
