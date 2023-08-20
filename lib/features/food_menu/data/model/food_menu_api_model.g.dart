// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_menu_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodMenuApiModel _$FoodMenuApiModelFromJson(Map<String, dynamic> json) =>
    FoodMenuApiModel(
      foodMenuId: json['id'] as String?,
      foodName: json['foodName'] as String,
      foodPrice: (json['foodPrice'] as num).toDouble(),
      foodType: json['foodType'] as String,
    );

Map<String, dynamic> _$FoodMenuApiModelToJson(FoodMenuApiModel instance) =>
    <String, dynamic>{
      'id': instance.foodMenuId,
      'foodName': instance.foodName,
      'foodPrice': instance.foodPrice,
      'foodType': instance.foodType,
    };
