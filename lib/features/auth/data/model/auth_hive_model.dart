import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../../../config/constants/hive_table_constant.dart';
import '../../domain/entity/user_entity.dart';

part 'auth_hive_model.g.dart';
// dart run build_runner build --delete-conflicting-outputs
final authHiveModelProvider = Provider(
  (ref) => AuthHiveModel.empty(),
);

@HiveType(typeId: HiveTableConstant.userTableId)
class AuthHiveModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String fullName;
  @HiveField(2)
  final String contact;
  @HiveField(3)
  final String role;
  @HiveField(4)
  final String email;
  @HiveField(5)
  final String username;
  @HiveField(6)
  final String password;
  @HiveField(7)
  final String? picture;

  AuthHiveModel({
    String? id,
    required this.fullName,
    required this.contact,
    required this.role,
    required this.email,
    required this.username,
    required this.password,
    this.picture,
  }) : id = id ?? const Uuid().v4();

  // empty inital values

  AuthHiveModel.empty()
      : this(
          id: '',
          fullName: '',
          contact: '',
          role: '',
          email: '',
          username: '',
          picture: '',
          password: '',
        );

  // for conversion of JSON into user entity
//   factory AuthHiveModel.fromJson(Map<String, dynamic> json) {
//     return AuthHiveModel(
//       id: json['id'],
//       fullName: json['fullName'],
//       contact: json['contact'],
//       role: json['role'],
//       email: json['email'],
//       username: json['username'],
//     );
//   }

// // convert user object into JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'fullName': fullName,
//       'contact': contact,
//       'role': role,
//       'email': email,
//       'username': username,
//       'picture': picture,
//     };
//   }

  // Convert Hive Object to Entity
  UserEntity toEntity() => UserEntity(
        id: id,
        fullName: fullName,
        contact: contact,
        role: role,
        email: email,
        username: username,
        picture: picture,
        password: password,
      );

  // convert Entity to Hive object

  AuthHiveModel toHiveModel(UserEntity entity) => AuthHiveModel(
        id: const Uuid().v4(),
        // id: entity.id,
        fullName: entity.fullName,
        contact: entity.contact,
        role: entity.role,
        email: entity.email,
        username: entity.username,
        picture: entity.picture,
        password: entity.password ?? '',
      );

  // convert Entity list into Hive list
  List<AuthHiveModel> toHiveModelList(List<UserEntity> entities) =>
      entities.map((entity) => toHiveModel(entity)).toList();

  @override
  String toString() {
    return 'User id: $id, full name : $fullName,  username: $username';
  }
}
