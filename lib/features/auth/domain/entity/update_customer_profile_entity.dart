import 'package:equatable/equatable.dart';

class UpdateCustomerProfileEntity extends Equatable {
  final String fullName;
  final String contact;
  final String email;
  final String username;
  final String password;

  const UpdateCustomerProfileEntity({
    required this.fullName,
    required this.contact,
    required this.email,
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [
        fullName,
        contact,
        email,
        username,
        password,
      ];
}
