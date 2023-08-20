import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:table_reservation_mobile_app/features/restaurant/domain/entity/restaurant_entity.dart';

Future<List<RestaurantEntity>> getAllRestaurantsTest() async {
  final response = await rootBundle
      .loadString('test_data/restaurants_entity_test_data.json');

  final jsonList = await json.decode(response);

  final List<RestaurantEntity> restaurantList = jsonList
      .map<RestaurantEntity>((json) => RestaurantEntity.fromJson(json))
      .toList();

  return Future.value(restaurantList);
}
