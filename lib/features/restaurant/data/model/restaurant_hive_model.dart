import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../../../config/constants/hive_table_constant.dart';
import '../../../auth/domain/entity/review_entity.dart';
import '../../domain/entity/restaurant_entity.dart';

part 'restaurant_hive_model.g.dart';

// dart run build_runner build --delete-conflicting-outputs
final restaurantHiveModelProvider = Provider(
  (ref) => RestaurantHiveModel.empty(),
);

@HiveType(typeId: HiveTableConstant.restaurantTableId)
class RestaurantHiveModel {
  @HiveField(0)
  final String restaurantId;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String location;
  @HiveField(3)
  final String contact;
  @HiveField(4)
  final String ownerId;
  @HiveField(5)
  final String? picture;
  @HiveField(6)
  final String ownerName;
  // @HiveField(7)
  // final List<ReviewEntity> reviews;

  RestaurantHiveModel({
    String? restaurantId,
    required this.name,
    required this.location,
    required this.contact,
    this.picture,
    required this.ownerName,
    String? ownerId,
    List<ReviewEntity>? reviews,
  })  : restaurantId = restaurantId ?? const Uuid().v4(),
        ownerId = ownerId ?? 'asdf';
  // reviews = reviews ?? [],

  RestaurantHiveModel.empty()
      : this(
          restaurantId: '',
          contact: '',
          picture: '',
          ownerName: '',
          ownerId: '',
          // reviews: [],
          name: '',
          location: '',
        );

  RestaurantEntity toEntity() => RestaurantEntity(
        name: name,
        location: location,
        contact: contact,
        ownerName: ownerName,
        reviews: [],
        reservations: [],
        foodMenu: [],
        foodOrders: [],
        favorite: [],
        ownerId: ownerId,
      );

// convert Entity to Hive object
  RestaurantHiveModel toHiveModel(RestaurantEntity entity) =>
      RestaurantHiveModel(
        name: entity.name,
        location: entity.location,
        contact: entity.contact,
        ownerName: entity.ownerName,
        picture: entity.picture ?? '',
      );

  // convert Entity list into Hive list
  List<RestaurantHiveModel> toHiveModelList(List<RestaurantEntity> entities) =>
      entities.map((entity) => toHiveModel(entity)).toList();

  // Convert Hive List to Entity List
  List<RestaurantEntity> toEntityList(List<RestaurantHiveModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  String toString() {
    return 'Restaurant id: $restaurantId, Restaurant name : $name,  Owner name: $ownerName';
  }
}
