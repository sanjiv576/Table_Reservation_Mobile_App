import 'package:equatable/equatable.dart';

import 'favorite_entity.dart';
import '../../../food_menu/domain/entity/food_menu_entity.dart';
import '../../../food_order/domain/entity/food_order_entity.dart';
import '../../../reservation/domain/entity/reservation_entity.dart';
import '../../../auth/domain/entity/review_entity.dart';

class RestaurantEntity extends Equatable {
  final String? restaurantId;
  final String name;
  final String location;
  final String contact;
  final String ownerId;
  final String? picture;
  final String ownerName;
  final List<ReviewEntity>? reviews;
  final List<ReservationEntity>? reservations;
  final List<FoodMenuEntity>? foodMenu;
  final List<FoodOrderEntity>? foodOrders;
  final List<FavoriteEntity>? favorite;

  const RestaurantEntity({
    this.restaurantId,
    required this.name,
    required this.location,
    required this.contact,
    this.picture,
    required this.ownerName,
    this.reviews,
    this.reservations,
    this.foodMenu,
    this.foodOrders,
    this.favorite,
    required this.ownerId,
  });

  @override
  List<Object?> get props {
    return [
      restaurantId,
      name,
      location,
      contact,
      ownerId,
      picture,
      ownerName,
      reviews,
      reservations,
      foodMenu,
      foodOrders,
      favorite,
    ];
  }

  factory RestaurantEntity.fromJson(Map<String, dynamic> json) {
    final List<dynamic> jsonReviews = json['reviews'];
    final List<ReviewEntity> reviews = jsonReviews
        .map<ReviewEntity>((json) => ReviewEntity.fromJson(json))
        .toList();

    final List<dynamic> jsonReservations = json['reservations'];
    final List<ReservationEntity> reservations = jsonReservations
        .map<ReservationEntity>((json) => ReservationEntity.fromJson(json))
        .toList();

    final List<dynamic> jsonFoodMenu = json['foodMenu'];
    final List<FoodMenuEntity> foodMenu = jsonFoodMenu
        .map<FoodMenuEntity>((json) => FoodMenuEntity.fromJson(json))
        .toList();

    final List<dynamic> jsonFoodOrders = json['foodOrders'];
    final List<FoodOrderEntity> foodOrders = jsonFoodOrders
        .map<FoodOrderEntity>((json) => FoodOrderEntity.fromJson(json))
        .toList();

    final List<dynamic> jsonFavorites = json['favorites'];
    final List<FavoriteEntity> favorites = jsonFavorites
        .map<FavoriteEntity>((json) => FavoriteEntity.fromJson(json))
        .toList();

    return RestaurantEntity(
      restaurantId: json['id'],
      name: json['name'],
      location: json['location'],
      contact: json['contact'],
      picture: json['picture'],
      ownerName: json['ownerName'],
      reviews: reviews,
      reservations: reservations,
      foodMenu: foodMenu,
      foodOrders: foodOrders,
      favorite: favorites,
      ownerId: json['ownerId'],
    );
  }

  @override
  String toString() {
    return 'Restaurant name : $name, Restaurant id : $restaurantId, Location  : $location Picture: $picture';
  }
}
