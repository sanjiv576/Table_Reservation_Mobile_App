import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_reservation_mobile_app/core/failure/failure.dart';
import 'package:table_reservation_mobile_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:table_reservation_mobile_app/features/auth/domain/entity/update_customer_profile_entity.dart';
import 'package:table_reservation_mobile_app/features/auth/domain/entity/user_entity.dart';
import 'package:table_reservation_mobile_app/features/auth/domain/repository/auth_repository.dart';

final authLocalRepositoryProvider = Provider<IAuthRepository>(
  (ref) => AuthLocalRepository(
    ref.read(authLocalDataSourceProvider),
  ),
);

class AuthLocalRepository implements IAuthRepository {
  final AuthLocalDataSource _authLocalDataSource;
  AuthLocalRepository(this._authLocalDataSource);

  // only allow to login in offline
  @override
  Future<Either<Failure, bool>> loginUser(String username, String password) {
    return _authLocalDataSource.loginUser(username, password);
  }

  // not allowed to register new user in offline
  @override
  Future<Either<Failure, bool>> registerUser(UserEntity user) {
    return _authLocalDataSource.registerUser(user);
  }

  // not allowed to update user profile in offline
  @override
  Future<Either<Failure, bool>> updateUserProfile(
      UpdateCustomerProfileEntity customerProfileEntity) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) {
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, bool>> deleteAccount() {
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, bool>> logout() {
    throw UnimplementedError();
  }
}
