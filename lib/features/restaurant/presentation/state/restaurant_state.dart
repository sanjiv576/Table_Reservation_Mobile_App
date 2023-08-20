import 'package:table_reservation_mobile_app/features/restaurant/domain/entity/restaurant_entity.dart';

class RestaurantState {
  // initialize the value when the Restaurant onwer dashboard is opened/displayed
  // static const restaurantId = '649c13b643544d9eecd419b6';
  static String? restaurantId;

  final bool isLoading;
  final String? error;
  final List<RestaurantEntity>? allRestaurants;
  final RestaurantEntity? singleRestaurant;

  static RestaurantEntity? restaurantEntity;

  RestaurantState({
    required this.isLoading,
    this.error,
    this.allRestaurants,
    this.singleRestaurant,
  });

  // initial values
  factory RestaurantState.initial() {
    return RestaurantState(
      isLoading: false,
      error: null,
      allRestaurants: [],
      singleRestaurant: RestaurantEntity(
        name: '',
        location: '',
        contact: '',
        ownerName: '',
        reviews: [],
        reservations: [],
        foodMenu: [],
        foodOrders: [],
        favorite: [],
        ownerId: '',
      ),
    );
  }

  RestaurantState copyWith({
    bool? isLoading,
    String? error,
    List<RestaurantEntity>? allRestaurants,
    RestaurantEntity? singleRestaurant,
  }) {
    return RestaurantState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      allRestaurants: allRestaurants ?? this.allRestaurants,
      singleRestaurant: singleRestaurant ?? this.singleRestaurant,
    );
  }
}
