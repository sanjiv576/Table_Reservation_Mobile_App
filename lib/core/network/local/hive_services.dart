import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:table_reservation_mobile_app/core/shared_prefs/user_shared_prefs.dart';

import '../../../config/constants/api_endpoints.dart';
import '../../../config/constants/hive_table_constant.dart';
import '../../../features/auth/data/model/auth_hive_model.dart';
import '../../../features/auth/presentation/state/auth_state.dart';
import '../../../features/restaurant/data/model/restaurant_hive_model.dart';
import '../../../features/restaurant/domain/entity/restaurant_entity.dart';
import '../../failure/failure.dart';

final hiveServiceProvider =
    Provider<HiveService>((ref) => HiveService());

class HiveService {
  Future<void> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    // register adapters
    Hive.registerAdapter(AuthHiveModelAdapter());
    Hive.registerAdapter(RestaurantHiveModelAdapter());

    // clear hive
    await clearRestaurantsFromHive();
    // insert dummy restaurants
    await insertDummyRestaurants();

  }

  // for login
  Future<AuthHiveModel?> login(String username, String password) async {
    var userBox = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    AuthHiveModel? user;

    try {
      user = userBox.values.firstWhere((element) {
        return element.username == username && element.password == password;
      });
      // convert Hive Model into Auth Entity and save its state
      AuthState.userEntity = user.toEntity();
    } catch (e) {
      // Catch the StateError when no matching user is found
      print(e.toString());
    }
    // userBox.close();

    return user;
  }

  // add user

  Future<void> addUser(AuthHiveModel user) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    await box.put(user.id, user);
  }

  // get all restaurants offline
  Future<List<RestaurantHiveModel>> getAllRestaurants() async {
    var box = await Hive.openBox<RestaurantHiveModel>(
        HiveTableConstant.restaurantBox);
    var restaurants = box.values.toList();
    // box.close();
    return restaurants;
  }

  // create a restaurant
  Future<void> createARestaurant(RestaurantHiveModel restaurant) async {
    var box = await Hive.openBox<RestaurantHiveModel>(
        HiveTableConstant.restaurantBox);
    await box.put(restaurant.restaurantId, restaurant);
  }

  // Insert dummy restaurants
  Future<void> insertDummyRestaurants() async {
    var box = await Hive.openBox<RestaurantHiveModel>(
        HiveTableConstant.restaurantBox);

    final dummyRestaurants = [
      RestaurantHiveModel(
        restaurantId: '1',
        name: 'Johnny Burger House',
        location: 'Kuleshwor-3, Kathmandu',
        contact: '9812323232',
        ownerId: '1',
        ownerName: 'Johnny Kennedy',
      ),
      RestaurantHiveModel(
        restaurantId: '2',
        name: 'Santosh restaurant',
        location: 'Delibazzar, Kathmandu',
        contact: '1234567890',
        ownerId: '2',
        ownerName: 'Santosh Majhi',
      ),
      RestaurantHiveModel(
        restaurantId: '3',
        name: 'Rohit Cafe',
        location: 'ktm, Nepal',
        contact: '0146834343',
        ownerId: '3',
        ownerName: 'Rohit Shrestha',
      ),
      RestaurantHiveModel(
        name: 'Frenzh Restaurant',
        location: 'New Road, Kathmandu',
        contact: '014566434',
        ownerName: 'Mohan Sharma',
      ),
      RestaurantHiveModel(
        name: 'Java Coffee - R',
        location: 'Kathmandu',
        contact: '9876567676',
        ownerName: 'Rajesh Hamal',
      ),
    ];

    for (var restaurant in dummyRestaurants) {
      await box.put(restaurant.restaurantId, restaurant);
    }

    // box.close();
  }

  Future<void> clearRestaurantsFromHive() async {
    var box = await Hive.openBox<RestaurantHiveModel>(
        HiveTableConstant.restaurantBox);
    await box.clear();
    // box.close();
  }

  Future<void> insertRestaurantsIntoHive(
      List<RestaurantHiveModel> restaurants) async {
    var box = await Hive.openBox<RestaurantHiveModel>(
        HiveTableConstant.restaurantBox);
    for (var restaurant in restaurants) {
      await box.put(restaurant.restaurantId, restaurant);
    }
    // box.close(); 
  }
}
