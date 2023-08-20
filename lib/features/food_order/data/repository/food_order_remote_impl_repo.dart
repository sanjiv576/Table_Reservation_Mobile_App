import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_reservation_mobile_app/core/failure/failure.dart';
import 'package:table_reservation_mobile_app/features/food_order/domain/entity/food_order_entity.dart';

import '../../domain/repository/food_order_repository.dart';
import '../data_sources/food_order_remote_data_source.dart';

final foodOrderRemoteRepoProvider = Provider.autoDispose(
  (ref) => FoodOrderRemoteRepoImpl(
    ref.read(foodOrderRemoteDataSourceProvider),
  ),
);

class FoodOrderRemoteRepoImpl implements IFoodOrderRepository {
  final FoodOrderRemoteDataSource _foodOrderRemoteDataSource;

  FoodOrderRemoteRepoImpl(this._foodOrderRemoteDataSource);
  @override
  Future<Either<Failure, List<FoodOrderEntity>>> getAllFoodOrders(
      String restaurantId) {
    return _foodOrderRemoteDataSource.getAllFoodOrders(restaurantId);
  }

  @override
  Future<Either<Failure, bool>> createFoodOrder(
      String restaurantId, FoodOrderEntity foodOrderEntity) {
   return  _foodOrderRemoteDataSource.createFoodOrder(restaurantId, foodOrderEntity);
  }
}
