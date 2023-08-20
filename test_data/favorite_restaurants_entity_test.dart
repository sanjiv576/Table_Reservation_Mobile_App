import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:table_reservation_mobile_app/features/restaurant/domain/entity/favorite_entity.dart';

Future<List<FavoriteEntity>> getAllFavoriteRestaurantsTest() async {
  // read the json file
  final response = await rootBundle
      .loadString('test_data/favorite_restaurants_test_data.json');

  // decode the json
  final jsonList = await json.decode(response);

  // convert each decoded JSON of Favorite restaurant object and add in the list
  final List<FavoriteEntity> favoriteList = jsonList
      .map<FavoriteEntity>((json) => FavoriteEntity.fromJson(json))
      .toList();
  return Future.value(favoriteList);
}
