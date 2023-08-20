import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../entity/food_order_entity.dart';
import '../repository/food_order_repository.dart';

final foodOrderUseCaseProvider = Provider(
  (ref) => FoodOrderUseCase(
    ref.read(foodOrderRepositoryProvider),
  ),
);

class FoodOrderUseCase {
  final IFoodOrderRepository _foodOrderRepository;

  FoodOrderUseCase(this._foodOrderRepository);

  Future<Either<Failure, List<FoodOrderEntity>>> getAllFoodOrders(
      String restaurantId) {
    return _foodOrderRepository.getAllFoodOrders(restaurantId);
  }

// create food order
  Future<Either<Failure, bool>> createFoodOrder(
      String restaurantId, FoodOrderEntity foodOrderEntity) {
    return _foodOrderRepository.createFoodOrder(restaurantId, foodOrderEntity);
  }
}
