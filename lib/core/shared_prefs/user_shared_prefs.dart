import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/domain/entity/user_entity.dart';
import '../failure/failure.dart';

final userSharedPrefsProvider =
    Provider<UserSharedPrefs>((ref) => UserSharedPrefs());

class UserSharedPrefs {
  late SharedPreferences _sharedPreferences;

  // set user token
  Future<Either<Failure, bool>> setUserToken({required String token}) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      // set the token
      await _sharedPreferences.setString('token', token);
      // set the role
      // await _sharedPreferences.setString('role', role);

      return right(true);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  // get user token
  Future<Either<Failure, String?>> getUserToken() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      // get the token from Shared Prefs
      final token = _sharedPreferences.getString('token');
      return right(token);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  // set restaurant id
  Future<Either<Failure, bool>> setRestaurantId(String restaurantId) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      // set the restaurant id
      await _sharedPreferences.setString('restaurantId', restaurantId);
      return const Right(true);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  // get the restaurant id
  Future<Either<Failure, String?>> getRestaurantId() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      // get the restaurant id from Shared Prefs
      final restaurantId = _sharedPreferences.getString('restaurantId');
      return Right(restaurantId);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  // get the user role
  // Future<String?> getUserRole() async {
  //   _sharedPreferences = await SharedPreferences.getInstance();
  //   return _sharedPreferences.getString('role');
  // }

  // set the user entity

  Future<Either<Failure, bool>> setUserEntity(UserEntity user) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      // Convert the user object to JSON
      final userJson = user.toJson();
      // Store the JSON string in SharedPreferences
      await _sharedPreferences.setString('user', jsonEncode(userJson));

      return right(true);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  // get the user
  Future<Either<Failure, UserEntity?>> getUserEntity() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      // Get the JSON string from SharedPreferences
      final userJson = _sharedPreferences.getString('user');
      if (userJson != null) {
        // Convert the JSON string to a Map
        final userMap = jsonDecode(userJson);
        // Create a UserEntity object from the Map
        final user = UserEntity.fromJson(userMap);
        return right(user);
      } else {
        return right(null);
      }
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }
}
