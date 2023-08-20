import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_reservation_mobile_app/features/restaurant/domain/entity/update_restaurant_entity.dart';

import '../../../../core/failure/failure.dart';
import '../../domain/entity/favorite_entity.dart';
import '../../domain/entity/restaurant_entity.dart';
import '../../domain/repository/restaurant_repository.dart';
import '../data_sources/restaurant_local_data_source.dart';

final restaurantLocalRepoImplProvider = Provider<IRestaurantRepository>(
  (ref) => RestaurantLocalRepositoryImpl(
    ref.read(restaurantLocalDataSourceProvider),
  ),
);

class RestaurantLocalRepositoryImpl implements IRestaurantRepository {
  final RestaurantLocalDataSource _restaurantLocalDataSource;
  RestaurantLocalRepositoryImpl(this._restaurantLocalDataSource);

  @override
  Future<Either<Failure, RestaurantEntity>> getARestaurant(
      String restaurantId) {
    throw UnimplementedError();
  }

  // get all restaurants by customer
  @override
  Future<Either<Failure, List<RestaurantEntity>>> getAllRestaurants() {
    return _restaurantLocalDataSource.getAllRestaurants();
  }

  @override
  Future<Either<Failure, bool>> createARestaurant(
      RestaurantEntity restaurantEntity) {
    return _restaurantLocalDataSource.createARestaurant(restaurantEntity);
  }

  @override
  Future<Either<Failure, FavoriteEntity>> addFavoriteRestaurant(
      String restaurantId) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> deleteFavoriteRestaurant(
      String restaurantId, String favoriteId) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> getAllFavoriteRestaurants() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> updateUserAndRestaurant(UpdateRestaurantEntity restaurantEntity) {
    throw UnimplementedError();
  }
}
