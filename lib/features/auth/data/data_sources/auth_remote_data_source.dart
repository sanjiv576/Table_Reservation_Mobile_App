import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/constants/api_endpoints.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/network/remote/http_services.dart';
import '../../../../core/shared_prefs/user_shared_prefs.dart';
import '../../../restaurant/domain/entity/restaurant_entity.dart';
import '../../../restaurant/presentation/state/restaurant_state.dart';
import '../../domain/entity/update_customer_profile_entity.dart';
import '../../domain/entity/user_entity.dart';
import '../../presentation/state/auth_state.dart';

final authRemoteDataSourceProvider = Provider(
  (ref) => AuthRemoteDataSource(
      dio: ref.read(httpServicesProvider),
      userSharedPrefs: ref.read(userSharedPrefsProvider)),
);

class AuthRemoteDataSource {
  // for calling HTTP requests here
  final Dio dio;

  // create instance of userSharedPrefs because to set token
  final UserSharedPrefs userSharedPrefs;

  AuthRemoteDataSource({required this.dio, required this.userSharedPrefs});

  // user register

  Future<Either<Failure, bool>> registerUser(UserEntity user) async {
    try {
      Response res = await dio.post(
        ApiEndpoints.register,
        data: {
          "fullName": user.fullName,
          "contact": user.contact,
          "email": user.email,
          "role": user.role,
          "username": user.username,
          "password": user.password
        },
      );

      if (res.statusCode == 201) {
        AuthState.userEntity = user;
        // AuthState.userPassword = user.password;
        // return true
        return const Right(true);
      }
      // return the errror
      else {
        return Left(
          Failure(
            error: res.data['error'],
            statusCode: res.statusCode.toString(),
          ),
        );
      }
    }
    // if any error occurs
    on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

// user login
  Future<Either<Failure, bool>> loginUser(
      String username, String password) async {
    try {
      Response res = await dio.post(
        ApiEndpoints.login,
        data: {
          "username": username,
          "password": password,
        },
      );

      // check the status code
      if (res.statusCode == 200) {
        // receive the token
        String token = res.data['token'];

        UserEntity userEntity = UserEntity(
          fullName: res.data['user']['fullName'],
          contact: res.data['user']['contact'],
          role: res.data['user']['role'],
          email: res.data['user']['email'],
          username: res.data['user']['username'],
          id: res.data['user']['id'],
          picture: res.data['user']['picture'],
          restaurantId: res.data['user']['restaurantId'] ?? 'NA',
        );

        // store logged in user details statically
        AuthState.userEntity = userEntity;

        // store restaurantId if the user is Restaurant Owner
        if (res.data['user']['role'] == 'restaurant owner') {
        
          // also get the restaurant
          // String restaurantId = res.data['user']['restaurantId'] ?? 'NA';
          String restaurantId = res.data['user']['restaurantId'];

          // set the restaurantId if it is the restaurant owner
          userSharedPrefs.setRestaurantId(restaurantId);

          // also update in the restaurant id of restaurant state
          RestaurantState.restaurantId = restaurantId;
        }

        userSharedPrefs.setUserToken(token: token);

        // also store the user in the shared prefs
        userSharedPrefs.setUserEntity(userEntity);

        //  store in static to handle the dashboard of customer and owner
        // AuthState.userRole = role;

        return const Right(true);
      }
      // return the server errror
      else {
        return Left(
          Failure(
            error: res.data['error'],
            statusCode: res.statusCode.toString(),
          ),
        );
      }

      // if any error occurs
    } on DioException catch (e) {
      return Left(
        Failure(
            error: e.error.toString(),
            statusCode: e.response?.statusCode.toString() ?? '0'),
      );
    }
  }

  // update user details

  Future<Either<Failure, bool>> updateUserDetails(
      UpdateCustomerProfileEntity customerProfileEntity) async {
    try {
      // get user id
      String? userId = AuthState.userEntity!.id;

      // get user token
      String? token;
      var data = await userSharedPrefs.getUserToken();

      data.fold((l) => token = null, (r) => token = r!);

      // send update route with token, data  and user id
      Response res = await dio.put(
        ApiEndpoints.updateUserAccount + userId!,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          "fullName": customerProfileEntity.fullName,
          "contact": customerProfileEntity.contact,
          "email": customerProfileEntity.email,
          "username": customerProfileEntity.username,
          "password": customerProfileEntity.password,
        },
      );

      if (res.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: res.data['error'],
            statusCode: res.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
            error: e.error.toString(),
            statusCode: e.response?.statusCode.toString() ?? '0'),
      );
    }
  }

  // upload photo file as profile
  Future<Either<Failure, String>> uploadProfilePicture(
    File image,
  ) async {
    try {
      String fileName = image.path.split('/').last;
      FormData formData = FormData.fromMap(
        {
          // Note: photo is defined in API
          'photo': await MultipartFile.fromFile(
            image.path,
            filename: fileName,
          ),
        },
      );

      // get user token
      String? token;
      var data = await userSharedPrefs.getUserToken();
      data.fold((l) => token = null, (r) => token = r!);

      Response response = await dio.post(
        ApiEndpoints.uploadImage,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: formData,
      );
      if (response.statusCode == 200) {
        if (AuthState.userEntity!.role == 'restaurant owner') {
          RestaurantEntity oldRestaurantEntity =
              RestaurantState.restaurantEntity!;

          // update the restaurant entity
          RestaurantState.restaurantEntity = RestaurantEntity(
            restaurantId: oldRestaurantEntity.restaurantId,
            name: oldRestaurantEntity.name,
            location: oldRestaurantEntity.location,
            contact: oldRestaurantEntity.contact,
            ownerName: oldRestaurantEntity.ownerName,
            ownerId: oldRestaurantEntity.ownerId,
            picture: response.data['filename'],
            reservations: oldRestaurantEntity.reservations,
            reviews: oldRestaurantEntity.reviews,
            foodMenu: oldRestaurantEntity.foodMenu,
            favorite: oldRestaurantEntity.favorite,
            foodOrders: oldRestaurantEntity.foodOrders,
          );
        }

        return Right(response.data["filename"]);
      }

      // return the errror
      else {
        return Left(
          Failure(
            error: response.data['error'],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  Future<Either<Failure, bool>> logout() async {
    try {
      String? token;
      var data = await userSharedPrefs.getUserToken();
      data.fold((l) => token = null, (r) => token = r!);

      Response response = await dio.post(
        ApiEndpoints.logout,
        data: {},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        // clear out shared preferences
        // await userSharedPrefs.setUserEntity({} as UserEntity);
        await userSharedPrefs.setUserToken(token: '');
        await userSharedPrefs.setRestaurantId('');

        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data['error'],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  Future<Either<Failure, bool>> deleteAccount() async {
    try {
      String? token;
      var data = await userSharedPrefs.getUserToken();
      data.fold((l) => token = null, (r) => token = r!);

      Response response = await dio.delete(
        ApiEndpoints.deleteUserAccount + AuthState.userEntity!.id!,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 204) {
        // clear out shared preferences
        // await userSharedPrefs.setUserEntity({} as UserEntity);
        await userSharedPrefs.setUserToken(token: '');
        await userSharedPrefs.setRestaurantId('');
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data['error'],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }
}
