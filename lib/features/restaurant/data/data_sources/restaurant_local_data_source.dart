import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/network/local/hive_services.dart';
import '../../domain/entity/restaurant_entity.dart';
import '../model/restaurant_hive_model.dart';

final restaurantLocalDataSourceProvider = Provider<RestaurantLocalDataSource>(
  (ref) => RestaurantLocalDataSource(
    ref.read(hiveServiceProvider),
    ref.read(restaurantHiveModelProvider),
  ),
);

class RestaurantLocalDataSource {
  final HiveService _hiveService;
  final RestaurantHiveModel _restaurantHiveModel;

  RestaurantLocalDataSource(
    this._hiveService,
    this._restaurantHiveModel,
  );

  // Get All Restaurants
  Future<Either<Failure, List<RestaurantEntity>>> getAllRestaurants() async {
    try {
      // Get from Hive
      final hiveRestaurants = await _hiveService.getAllRestaurants();
      // Convert Hive Object to Entity
      final restaurants = _restaurantHiveModel.toEntityList(hiveRestaurants);
      print('Got restaurants from Hive : ${restaurants.length}');
      return Right(restaurants);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  // creat a restaurant
  Future<Either<Failure, bool>> createARestaurant(
      RestaurantEntity restaurant) async {
    try {
      // Convert Entity to Hive Object
      final hiveRestaurant = _restaurantHiveModel.toHiveModel(restaurant);
      // Add to Hive
      await _hiveService.createARestaurant(hiveRestaurant);
      return const Right(true);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }
}

// import 'package:dartz/dartz.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../../core/failure/failure.dart';
// import '../../../../core/network/local/hive_services.dart';
// import '../../domain/entity/restaurant_entity.dart';
// import '../model/restaurant_hive_model.dart';

// final restaurantLocalDataSourceProvider = Provider<RestaurantLocalDataSource>(
//   (ref) => RestaurantLocalDataSource(
//     ref.read(hiveServiceProvider),
//     ref.read(restaurantHiveModelProvider),
//   ),
// );

// class RestaurantLocalDataSource {
//   final HiveService _hiveService;
//   final RestaurantHiveModel _restaurantHiveModel;

//   RestaurantLocalDataSource(
//     this._hiveService,
//     this._restaurantHiveModel,
//   );

//   // Get All Restaurants
//   Future<Either<Failure, List<RestaurantEntity>>> getAllRestaurants() async {
//     try {
//       final hiveRestaurants = await _hiveService.getAllRestaurants();
//       final restaurants = hiveRestaurants
//           .map((hiveModel) => _restaurantHiveModel.toEntityList(hiveModel)).toList();
//       return Right(restaurants);
//     } catch (e) {
//       return Left(Failure(error: e.toString()));
//     }
//   }

//   // Create a restaurant
//   Future<Either<Failure, bool>> createARestaurant(
//       RestaurantEntity restaurant) async {
//     try {
//       final hiveRestaurant = _restaurantHiveModel.fromEntity(restaurant);
//       await _hiveService.createARestaurant(hiveRestaurant);
//       return const Right(true);
//     } catch (e) {
//       return Left(Failure(error: e.toString()));
//     }
//   }
// }
