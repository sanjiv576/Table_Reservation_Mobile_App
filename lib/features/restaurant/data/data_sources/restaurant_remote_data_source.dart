import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/constants/api_endpoints.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/network/remote/http_services.dart';
import '../../../../core/shared_prefs/user_shared_prefs.dart';
import '../../../auth/domain/entity/user_entity.dart';
import '../../../auth/presentation/state/auth_state.dart';
import '../../domain/entity/favorite_entity.dart';
import '../../domain/entity/restaurant_entity.dart';
import '../../domain/entity/update_restaurant_entity.dart';
import '../../presentation/state/favorite_state.dart';
import '../../presentation/state/restaurant_state.dart';

final restaurantRemoteDataSourceProvider = Provider((ref) {
  return RestaurantRemoteDatatSource(
      dio: ref.read(httpServicesProvider),
      userSharedPrefs: ref.read(userSharedPrefsProvider));
});

class RestaurantRemoteDatatSource {
  final Dio dio;
  final UserSharedPrefs userSharedPrefs;

  RestaurantRemoteDatatSource({
    required this.dio,
    required this.userSharedPrefs,
  });
  // get a restaurant by its id
  Future<Either<Failure, RestaurantEntity>> getARestaurant(
      String restaurantId) async {
    try {
      String? token;

      var data = await userSharedPrefs.getUserToken();
      data.fold((l) => token = null, (r) => token = r!);

      // send request
      Response response = await dio.get(
        '${ApiEndpoints.getARestaurantById}/$restaurantId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        // convert JSON inot Restaurant Entity
        RestaurantEntity restaurantEntity =
            RestaurantEntity.fromJson(response.data);

        // insert in the restauant state
        RestaurantState.restaurantEntity = restaurantEntity;

        // return restaurant list
        return Right(restaurantEntity);
      }
      // return any error that come from server
      else {
        return Left(
          Failure(
            error: response.data['error'].toString(),
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(Failure(
        error: e.error.toString(),
        statusCode: e.response?.statusCode.toString() ?? '0',
      ));
    }
  }

  // get all restaurants
  Future<Either<Failure, List<RestaurantEntity>>> getAllRestaurants() async {
    try {
      String? token;
      var data = await userSharedPrefs.getUserToken();
      data.fold((l) => token = null, (r) => token = r!);

      Response response = await dio.get(
        ApiEndpoints.getAllRestaurants,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        // convert JSON object into EntityList and return

        List<RestaurantEntity> restaurantList = (response.data as List<dynamic>)
            .map<RestaurantEntity>((json) => RestaurantEntity.fromJson(json))
            .toList();

        return Right(restaurantList);
      } else {
        return Left(
          Failure(
            error: response.data['error'].toString(),
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(Failure(
        error: e.error.toString(),
        statusCode: e.response?.statusCode.toString() ?? '0',
      ));
    }
  }

  // create a restaurant
  Future<Either<Failure, bool>> createARestaurant(
      RestaurantEntity restaurant) async {
    try {
      String? token;
      var data = await userSharedPrefs.getUserToken();
      data.fold((l) => token = null, (r) => token = r!);

      Response response = await dio.post(
        ApiEndpoints.createARestaurant,
        data: {
          "name": restaurant.name,
          "location": restaurant.location,
          "contact": restaurant.contact,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 201) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data['error'].toString(),
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(Failure(
        error: e.error.toString(),
        statusCode: e.response?.statusCode.toString() ?? '0',
      ));
    }
  }

  // add favourite restaurant
  Future<Either<Failure, FavoriteEntity>> addFavoriteRestaurant(
      String restaurantId) async {
    try {
      String? token;
      var data = await userSharedPrefs.getUserToken();
      data.fold((l) => token = null, (r) => token = r!);

      Response response = await dio.post(
        '${ApiEndpoints.createFavorite}$restaurantId/favorite',
        data: {},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        FavoriteEntity favoriteEntity = FavoriteEntity.fromJson(response.data);
        return Right(favoriteEntity);
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

  // delete favourite restaurant
  Future<Either<Failure, bool>> deleteFavoriteRestaurant(
      String restaurantId, String favoriteId) async {
    try {
      String? token;
      var data = await userSharedPrefs.getUserToken();
      data.fold((l) => token = null, (r) => token = r!);

      Response response = await dio.delete(
        '${ApiEndpoints.deleteAFavorite}$restaurantId/favorite/$favoriteId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 204) {
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

  // get all favourite restaurants
  Future<Either<Failure, bool>> getAllFavoriteRestaurants() async {
    try {
      String? token;
      var data = await userSharedPrefs.getUserToken();
      data.fold((l) => token = null, (r) => token = r!);

      Response response = await dio.get(
        ApiEndpoints.getAllFavorites,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {

        // List<GetFavoriteEntity> favoriteEntityList = (response.data
        //         as List<dynamic>)
        //     .map<GetFavoriteEntity>((json) => GetFavoriteEntity.fromJson(json))
        //     .toList();

        FavoriteState.allFavoriteRestaurants = response.data;
       

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

  // update user and restaurant profile
  Future<Either<Failure, bool>> updateUserAndRestaurant(
      UpdateRestaurantEntity restaurantEntity) async {
    try {
      String? token;
      var data = await userSharedPrefs.getUserToken();
      data.fold((l) => token = null, (r) => token = r!);

      Response response = await dio.put(
        ApiEndpoints.updateRestaurantById + RestaurantState.restaurantId!,
        data: {
          'name': restaurantEntity.name,
          'location': restaurantEntity.location,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {

        // store old details
        RestaurantEntity oldRestaurantDetails =
            RestaurantState.restaurantEntity!;

        // also update restaurant state ==> name and location
        RestaurantState.restaurantEntity = RestaurantEntity(
            name: restaurantEntity.name,
            location: restaurantEntity.location,
            contact: oldRestaurantDetails.contact,
            ownerName: oldRestaurantDetails.ownerName,
            ownerId: oldRestaurantDetails.ownerId,
            restaurantId: oldRestaurantDetails.restaurantId,
            picture: response.data['filename'],
            reservations: oldRestaurantDetails.reservations,
            reviews: oldRestaurantDetails.reviews,
            foodMenu: oldRestaurantDetails.foodMenu,
            favorite: oldRestaurantDetails.favorite,
            foodOrders: oldRestaurantDetails.foodOrders);

        // againg update onwer details separately
        Response res = await dio.put(
          ApiEndpoints.updateUserAccount + AuthState.userEntity!.id!,
          data: {
            'fullName': restaurantEntity.fullName,
            'contact': restaurantEntity.contact,
            'email': restaurantEntity.email,
            'username': restaurantEntity.username,
            'password': restaurantEntity.password,
          },
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );
        if (res.statusCode == 200) {

          // store old details
          UserEntity oldUserDetails = AuthState.userEntity!;

          UserEntity newUserDetail = UserEntity(
            id: oldUserDetails.id,
            fullName: restaurantEntity.fullName,
            contact: restaurantEntity.contact,
            role: oldUserDetails.role,
            email: restaurantEntity.email,
            username: restaurantEntity.username,
            picture: oldUserDetails.picture,
            restaurantId: oldUserDetails.restaurantId,
            password: restaurantEntity.password,
          );

          // also update auth state ==> fullName, contact, email, username
          AuthState.userEntity = newUserDetail;

          return const Right(true);
        }
      }
      return Left(
        Failure(
          error: response.data['error'],
          statusCode: response.statusCode.toString(),
        ),
      );
    } on DioException catch (e) {
      return Left(Failure(
        error: e.error.toString(),
        statusCode: e.response?.statusCode.toString() ?? '0',
      ));
    }
  }
}
