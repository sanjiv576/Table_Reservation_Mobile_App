import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:table_reservation_mobile_app/features/food_menu/domain/entity/food_menu_entity.dart';

Future<List<FoodMenuEntity>> getFoodMenuTest() async {
  // read data ie Food menu from the file
  final response =
      await rootBundle.loadString('test_data/food_menu_test_data.json');

  // decode the JSON
  final jsonList = await json.decode(response);

  // convert each decoded JSON of Food menu object and add in the list
  final List<FoodMenuEntity> foodMenuList = jsonList
      .map<FoodMenuEntity>((json) => FoodMenuEntity.fromJson(json))
      .toList();

  return Future.value(foodMenuList);
}
