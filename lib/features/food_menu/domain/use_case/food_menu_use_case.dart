import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../entity/food_menu_entity.dart';
import '../repository/food_menu_repository.dart';

final foodMenuUseCaseProvider = Provider(
  (ref) => FoodMenuUseCase(
    foodMenuRepository: ref.read(foodMenuRepositoryProvider),
  ),
);

class FoodMenuUseCase {
  final IFoodMenuRepository foodMenuRepository;
  FoodMenuUseCase({required this.foodMenuRepository});

  // get all food items i.e food menu
  Future<Either<Failure, List<FoodMenuEntity>>> getFoodMenu(
      String restaurantId) {
    return foodMenuRepository.getFoodMenu(restaurantId);
  }

  // add food item
  Future<Either<Failure, bool>> addFoodItem(FoodMenuEntity foodItem) {
    return foodMenuRepository.addAFoodItem(foodItem);
  }

  // update food item

  Future<Either<Failure, bool>> updateAFoodItem(
      String foodItemId, FoodMenuEntity foodItem) {
    return foodMenuRepository.updateAFoodItem(foodItemId, foodItem);
  }

  // delete food item
  Future<Either<Failure, bool>> deleteAFoodItem(FoodMenuEntity foodMenuEntity) {
    return foodMenuRepository.deleteAFoodItem(foodMenuEntity.foodMenuId!);
  }
}
