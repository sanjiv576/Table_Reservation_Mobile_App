import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../../data/data_sources/food_order_remote_data_source.dart';
import '../../data/repository/food_order_remote_impl_repo.dart';
import '../entity/food_order_entity.dart';

final foodOrderRepositoryProvider = Provider.autoDispose(
  (ref) => FoodOrderRemoteRepoImpl(ref.read(foodOrderRemoteDataSourceProvider)),
);

abstract class IFoodOrderRepository {
  Future<Either<Failure, List<FoodOrderEntity>>> getAllFoodOrders(
      String restaurantId);

  Future<Either<Failure, bool>> createFoodOrder(
      String restaurantId, FoodOrderEntity foodOrderEntity);
}
