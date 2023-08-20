import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_reservation_mobile_app/core/failure/failure.dart';

import '../../domain/entity/update_customer_profile_entity.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';

final authRemoteRepositoryProvider = Provider<IAuthRepository>(
    (ref) => AuthRemoteRepository(ref.read(authRemoteDataSourceProvider)));

class AuthRemoteRepository implements IAuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRemoteRepository(this._authRemoteDataSource);

  @override
  Future<Either<Failure, bool>> loginUser(String username, String password) {
    return _authRemoteDataSource.loginUser(username, password);
  }

  @override
  Future<Either<Failure, bool>> registerUser(UserEntity user) {
    return _authRemoteDataSource.registerUser(user);
  }

  @override
  Future<Either<Failure, bool>> updateUserProfile(
      UpdateCustomerProfileEntity customerProfileEntity) {
    return _authRemoteDataSource.updateUserDetails(customerProfileEntity);
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) {
    return _authRemoteDataSource.uploadProfilePicture(file);
  }

  @override
  Future<Either<Failure, bool>> deleteAccount() {
    return _authRemoteDataSource.deleteAccount();
  }

  @override
  Future<Either<Failure, bool>> logout() {
    return _authRemoteDataSource.logout();
  }
}
