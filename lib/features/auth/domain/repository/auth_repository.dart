import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common/provider/internet_connectivity.dart';
import '../../../../core/failure/failure.dart';
import '../../data/repository/auth_local_repository.dart';
import '../../data/repository/auth_remote_repository.dart';
import '../entity/update_customer_profile_entity.dart';
import '../entity/user_entity.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  // return ref.read(authRemoteRepositoryProvider);
  // return ref.read(authLocalRepositoryProvider);

  final internetStatus = ref.watch(connectivityStatusProvider);
  if (internetStatus == ConnectivityStatus.isConnected) {
    return ref.read(authRemoteRepositoryProvider);
  } else {
    return ref.read(authLocalRepositoryProvider);
  }
});

abstract class IAuthRepository {
  // abstract method for register
  Future<Either<Failure, bool>> registerUser(UserEntity user);

  // abstract method for login
  Future<Either<Failure, bool>> loginUser(String username, String password);

  // update user details
  Future<Either<Failure, bool>> updateUserProfile(
      UpdateCustomerProfileEntity customerProfileEntity);

  Future<Either<Failure, String>> uploadProfilePicture(File file);

  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, bool>> deleteAccount();
}
