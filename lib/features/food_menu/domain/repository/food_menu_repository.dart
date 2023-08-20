import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../../data/data_sources/food_menu_remote_data_source.dart';
import '../../data/repository/food_menu_remote_repo_impl.dart';
import '../entity/food_menu_entity.dart';

final foodMenuRepositoryProvider = Provider.autoDispose((ref) {

// assume we have internet for now
  return FoodMenuRemoteRepoImpl(
    foodMenuRemoteDataSource: ref.read(foodMenuRemoteDataSourceProvider),
  );
});

abstract class IFoodMenuRepository {
  // get all food items i.e menu
  Future<Either<Failure, List<FoodMenuEntity>>> getFoodMenu(
      String restaurantId);

  // add a food item
  Future<Either<Failure, bool>> addAFoodItem(FoodMenuEntity foodItem);

  // update food item
  Future<Either<Failure, bool>> updateAFoodItem(
      String foodItemId, FoodMenuEntity foodItem);

  // delete food item
  Future<Either<Failure, bool>> deleteAFoodItem(String foodItemId);
}
