import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/food_menu_entity.dart';

part 'food_menu_api_model.g.dart';

// command:
final foodMenuApiModelProvider =
    Provider.autoDispose((ref) => FoodMenuApiModel.empty());

@JsonSerializable()
class FoodMenuApiModel {
  // mapping id (from API) with foodMenuId
  @JsonKey(name: 'id')
  final String? foodMenuId;
  final String foodName;
  final double foodPrice;
  final String foodType;

  FoodMenuApiModel({
    this.foodMenuId,
    required this.foodName,
    required this.foodPrice,
    required this.foodType,
  });

  // empty initial values of class members
  FoodMenuApiModel.empty()
      : this(
          foodMenuId: '',
          foodName: '',
          foodPrice: 0.0,
          foodType: '',
        );

  // fromJson ==> data come from API
  factory FoodMenuApiModel.fromJson(Map<String, dynamic> json) =>
      _$FoodMenuApiModelFromJson(json);

  // toJson ==> send foodItem data into API
  Map<String, dynamic> toJson() => _$FoodMenuApiModelToJson(this);

  // convert Hive Object into Entity
  FoodMenuEntity toEntity() => FoodMenuEntity(
        foodMenuId: foodMenuId,
        foodName: foodName,
        foodPrice: foodPrice,
        foodType: foodType,
      );

  // convert Entity to Hive object

  FoodMenuApiModel toHiveModel(FoodMenuEntity entity) => FoodMenuApiModel(
        foodMenuId: entity.foodMenuId,
        foodName: entity.foodName,
        foodPrice: entity.foodPrice,
        foodType: entity.foodType,
      );

  // convert Hive list into Entity list

  List<FoodMenuEntity> toEntityList(List<FoodMenuApiModel> models) =>
      models.map((model) => model.toEntity()).toList();
}
