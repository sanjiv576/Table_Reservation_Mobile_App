import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/favorite_entity.dart';
import '../../../food_menu/domain/entity/food_menu_entity.dart';
import '../../../food_order/domain/entity/food_order_entity.dart';
import '../../../reservation/domain/entity/reservation_entity.dart';
import '../../../auth/domain/entity/review_entity.dart';

@JsonSerializable()
class RestaurantApiModel {
  @JsonKey(name: '_id')
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

  RestaurantApiModel({
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

  RestaurantApiModel.empty()
      : this(
          restaurantId: '',
          name: '',
          location: '',
          contact: '',
          ownerId: '',
          picture: '',
          ownerName: '',
          reviews: [],
          reservations: [],
          foodMenu: [],
          foodOrders: [],
          favorite: [],
        );
}
