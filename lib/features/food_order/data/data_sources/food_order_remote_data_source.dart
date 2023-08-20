import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/constants/api_endpoints.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/network/remote/http_services.dart';
import '../../../../core/shared_prefs/user_shared_prefs.dart';
import '../../domain/entity/food_order_entity.dart';

final foodOrderRemoteDataSourceProvider = Provider.autoDispose(
  (ref) => FoodOrderRemoteDataSource(
    ref.read(httpServicesProvider),
    ref.read(userSharedPrefsProvider),
  ),
);

class FoodOrderRemoteDataSource {
  final Dio _dio;
  final UserSharedPrefs _userSharedPrefs;

  FoodOrderRemoteDataSource(this._dio, this._userSharedPrefs);

  // get all food orders
  Future<Either<Failure, List<FoodOrderEntity>>> getAllFoodOrders(
      String restaurantId) async {
    try {
      // get the user token from the shared preferences
      String? token;
      var data = await _userSharedPrefs.getUserToken();

      data.fold((l) => token = null, (r) => token = r!);
      Response response = await _dio.get(
        '${ApiEndpoints.getAllFoodOrders}/$restaurantId/foodOrder',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        // convert JSON object into EntityList and return
        List<FoodOrderEntity> foodOrderList = (response.data as List<dynamic>)
            .map<FoodOrderEntity>((json) => FoodOrderEntity.fromJson(json))
            .toList();

        return Right(foodOrderList);
      }
      // return any error that come from server
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

  // give food order by customer
  Future<Either<Failure, bool>> createFoodOrder(
      String restaurantId, FoodOrderEntity foodOrder) async {
    try {
      String? token;

      var data = await _userSharedPrefs.getUserToken();
      data.fold((l) => token = null, (r) => token = r!);

      Response response = await _dio.post(
        '${ApiEndpoints.createAFoodOrder}$restaurantId/foodOrder',
        data: {
          'date': foodOrder.date,
          'time': foodOrder.time,
          'items': foodOrder.items
          // 'items': foodOrder.items.map((e) => e.toJson())
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
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
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }
}
