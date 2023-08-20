import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../entity/favorite_entity.dart';
import '../entity/restaurant_entity.dart';
import '../entity/update_restaurant_entity.dart';
import '../repository/restaurant_repository.dart';

final restaurantUseCaseProvider = Provider(
  (ref) => RestaurantUseCase(
    restaurantRepository: ref.read(restaurantRepositoryProvider),
  ),
);

class RestaurantUseCase {
  final IRestaurantRepository restaurantRepository;
  RestaurantUseCase({required this.restaurantRepository});

  // get a restaurant
  Future<Either<Failure, RestaurantEntity>> getARestaurant(
      String restaurantId) {
    return restaurantRepository.getARestaurant(restaurantId);
  }

  // get all restaurants
  Future<Either<Failure, List<RestaurantEntity>>> getAllRestaurants() {
    return restaurantRepository.getAllRestaurants();
  }

  // creat a restaurant
  Future<Either<Failure, bool>> createARestaurant(
      RestaurantEntity restaurantEntity) {
    return restaurantRepository.createARestaurant(restaurantEntity);
  }

  // update a restaurant

  // add favorite
  Future<Either<Failure, FavoriteEntity>> addFavoriteRestaurant(
      String restaurantId) {
    return restaurantRepository.addFavoriteRestaurant(restaurantId);
  }

  // delete favorite
  Future<Either<Failure, bool>> deleteFavoriteRestaurant(
      String restaurantId, String favoriteId) {
    return restaurantRepository.deleteFavoriteRestaurant(
        restaurantId, favoriteId);
  }

  // get all favorite restaurant
  Future<Either<Failure, bool>> getAllFavoriteRestaurants() {
    return restaurantRepository.getAllFavoriteRestaurants();
  }

  // update restaurant and user details
  Future<Either<Failure, bool>> updateUserAndRestaurant(
      UpdateRestaurantEntity restaurantEntity) {
    return restaurantRepository.updateUserAndRestaurant(restaurantEntity);
  }
}
