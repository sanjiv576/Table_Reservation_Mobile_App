import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_reservation_mobile_app/features/auth/domain/entity/update_customer_profile_entity.dart';

import '../../../../core/failure/failure.dart';
import '../entity/user_entity.dart';
import '../repository/auth_repository.dart';

final authUseCaseProvider =
    Provider((ref) => AuthUseCase(ref.read(authRepositoryProvider)));

class AuthUseCase {
  final IAuthRepository _authRepository;

  AuthUseCase(this._authRepository);

  // for user register
  Future<Either<Failure, bool>> registerUser(UserEntity user) {
    return _authRepository.registerUser(user);
  }

  // for user login
  Future<Either<Failure, bool>> loginUser(String username, String password) {
    return _authRepository.loginUser(username, password);
  }

  // update user profile
  Future<Either<Failure, bool>> updateUserProfile(
      UpdateCustomerProfileEntity customerProfileEntity) {
    return _authRepository.updateUserProfile(customerProfileEntity);
  }

  // upload image
  Future<Either<Failure, String>> uploadProfilePicture(File image) {
    return _authRepository.uploadProfilePicture(image);
  }

   Future<Either<Failure, bool>> deleteAccount() {
    return _authRepository.deleteAccount();
  }

  Future<Either<Failure, bool>> logout() {
    return _authRepository.logout();
  }
}
