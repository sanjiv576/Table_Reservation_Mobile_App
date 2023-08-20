import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../../domain/entity/food_menu_entity.dart';
import '../../domain/repository/food_menu_repository.dart';
import '../data_sources/food_menu_remote_data_source.dart';

final foodMenuRemoteRepoProvider = Provider.autoDispose(
  (ref) => FoodMenuRemoteRepoImpl(
    foodMenuRemoteDataSource: ref.read(foodMenuRemoteDataSourceProvider),
  ),
);

class FoodMenuRemoteRepoImpl implements IFoodMenuRepository {
  final FoodMenuRemoteDataSource foodMenuRemoteDataSource;
  FoodMenuRemoteRepoImpl({required this.foodMenuRemoteDataSource});

  @override
  Future<Either<Failure, bool>> addAFoodItem(FoodMenuEntity foodItem) {
    return foodMenuRemoteDataSource.addFoodItem(foodItem);
  }

  @override
  Future<Either<Failure, List<FoodMenuEntity>>> getFoodMenu(
      String restaurantId) {
    return foodMenuRemoteDataSource.getFoodMenu(restaurantId);
  }

  @override
  Future<Either<Failure, bool>> updateAFoodItem(
      String foodItemId, FoodMenuEntity foodItem) {
    return foodMenuRemoteDataSource.updateAFoodItem(foodItemId, foodItem);
  }

  @override
  Future<Either<Failure, bool>> deleteAFoodItem(String foodItemId) {
    return foodMenuRemoteDataSource.deleteAFoodItem(foodItemId);
  }
}
