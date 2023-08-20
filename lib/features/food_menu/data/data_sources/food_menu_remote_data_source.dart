import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_reservation_mobile_app/features/food_menu/presentation/state/food_menu_state.dart';

import '../../../../config/constants/api_endpoints.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/network/remote/http_services.dart';
import '../../../../core/shared_prefs/user_shared_prefs.dart';
import '../../../restaurant/presentation/state/restaurant_state.dart';
import '../../domain/entity/food_menu_entity.dart';
import '../model/food_menu_api_model.dart';

final foodMenuRemoteDataSourceProvider = Provider.autoDispose(
  (ref) => FoodMenuRemoteDataSource(
    dio: ref.read(httpServicesProvider),
    foodMenuApiModel: ref.read(foodMenuApiModelProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
  ),
);

class FoodMenuRemoteDataSource {
  final Dio dio;
  final FoodMenuApiModel foodMenuApiModel;
  final UserSharedPrefs userSharedPrefs;
  FoodMenuRemoteDataSource(
      {required this.dio,
      required this.foodMenuApiModel,
      required this.userSharedPrefs});

  // get all food items i.e food menu
  Future<Either<Failure, List<FoodMenuEntity>>> getFoodMenu(
      String restaurantId) async {
    try {
      // get the user token from the shared preferences
      String? token;
      var data = await userSharedPrefs.getUserToken();

      data.fold((l) => token = null, (r) => token = r!);
      Response response = await dio.get(
        '${ApiEndpoints.getFoodMenu}/$restaurantId/menu',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        // convert JSON object into EntityList and return

        List<FoodMenuEntity> foodMenuList = (response.data as List<dynamic>)
            .map<FoodMenuEntity>((json) => FoodMenuEntity.fromJson(json))
            .toList();

        return Right(foodMenuList);
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
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  // add a food item
  Future<Either<Failure, bool>> addFoodItem(FoodMenuEntity foodItem) async {
    try {
      // get token from user prefs
      String? token;
      var data = await userSharedPrefs.getUserToken();
      data.fold((l) => token = null, (r) => token = r!);

      // call endpoint and create food item
      Response response = await dio.post(
        '${ApiEndpoints.createAFoodItem}/${RestaurantState.restaurantId}/menu',
        data: {
          "foodName": foodItem.foodName,
          "price": foodItem.foodPrice,
          "foodType": foodItem.foodType,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 201) {
        // convert JSON object into a Entity and return
        FoodMenuEntity addedFoodItem = FoodMenuEntity(
          foodMenuId: response.data['id'],
          foodName: response.data['foodName'],
          foodPrice: response.data['price'].toDouble(),
          foodType: response.data['foodType'],
        );

        FoodMenuState.singleFoodItem = addedFoodItem;
        // return true
        return const Right(true);
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
      return Left(
        Failure(
            error: e.error.toString(),
            statusCode: e.response?.statusCode.toString() ?? '0'),
      );
    }
  }

  // update a food item
  Future<Either<Failure, bool>> updateAFoodItem(
      String foodItemId, FoodMenuEntity foodItem) async {
    try {
      // get user token
      String? token;

      var data = await userSharedPrefs.getUserToken();

      data.fold((l) => token = null, (r) => token = r!);
// call endpoint and update food item
      Response response = await dio.put(
        '${ApiEndpoints.updateAFoodItem}/${RestaurantState.restaurantId}/menu/$foodItemId',
        data: {
          "foodName": foodItem.foodName,
          "price": foodItem.foodPrice,
          "foodType": foodItem.foodType,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        // convert JSON object into a Entity and return
        FoodMenuEntity updatedFoodItem = FoodMenuEntity(
          foodMenuId: response.data['id'],
          foodName: response.data['foodName'],
          foodPrice: response.data['price'].toDouble(),
          foodType: response.data['foodType'],
        );

        FoodMenuState.singleFoodItem = updatedFoodItem;

        // return true
        return const Right(true);
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
      return Left(
        Failure(
            error: e.error.toString(),
            statusCode: e.response?.statusCode.toString() ?? '0'),
      );
    }
  }

  // delete a food item
  Future<Either<Failure, bool>> deleteAFoodItem(String foodItemId) async {
    try {
      // get user token from user prefs
      String? token;

      var data = await userSharedPrefs.getUserToken();

      data.fold((l) => token = null, (r) => token = r!);

      Response response = await dio.delete(
        '${ApiEndpoints.deleteAFoodItem}/${RestaurantState.restaurantId}/menu/$foodItemId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 204) {
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
      return Left(
        Failure(
            error: e.error.toString(),
            statusCode: e.response?.statusCode.toString() ?? '0'),
      );
    }
  }
}
