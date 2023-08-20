import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_reservation_mobile_app/features/restaurant/domain/entity/update_restaurant_entity.dart';

import '../../../../core/failure/failure.dart';
import '../../domain/entity/favorite_entity.dart';
import '../../domain/entity/restaurant_entity.dart';
import '../../domain/repository/restaurant_repository.dart';
import '../data_sources/restaurant_remote_data_source.dart';

final restaurantRemoteRepoProvider = Provider(
  (ref) => RestaurantRemoteRepoImpl(
    restaurantRemoteDatatSource: ref.read(restaurantRemoteDataSourceProvider),
  ),
);

class RestaurantRemoteRepoImpl implements IRestaurantRepository {
  final RestaurantRemoteDatatSource restaurantRemoteDatatSource;

  RestaurantRemoteRepoImpl({required this.restaurantRemoteDatatSource});
  @override
  Future<Either<Failure, RestaurantEntity>> getARestaurant(
      String restaurantId) {
    return restaurantRemoteDatatSource.getARestaurant(restaurantId);
  }

  @override
  Future<Either<Failure, List<RestaurantEntity>>> getAllRestaurants() {
    return restaurantRemoteDatatSource.getAllRestaurants();
  }

  @override
  Future<Either<Failure, bool>> createARestaurant(
      RestaurantEntity restaurantEntity) {
    return restaurantRemoteDatatSource.createARestaurant(restaurantEntity);
  }

  @override
  Future<Either<Failure, FavoriteEntity>> addFavoriteRestaurant(
      String restaurantId) {
    return restaurantRemoteDatatSource.addFavoriteRestaurant(restaurantId);
  }

  @override
  Future<Either<Failure, bool>> deleteFavoriteRestaurant(
      String restaurantId, String favoriteId) {
    return restaurantRemoteDatatSource.deleteFavoriteRestaurant(
        restaurantId, favoriteId);
  }

  @override
  Future<Either<Failure, bool>> getAllFavoriteRestaurants() {
    return restaurantRemoteDatatSource.getAllFavoriteRestaurants();
  }

  @override
  Future<Either<Failure, bool>> updateUserAndRestaurant(
      UpdateRestaurantEntity restaurantEntity) {
    return restaurantRemoteDatatSource
        .updateUserAndRestaurant(restaurantEntity);
  }
}
