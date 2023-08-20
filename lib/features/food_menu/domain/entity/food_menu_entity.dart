import 'package:equatable/equatable.dart';

class FoodMenuEntity extends Equatable {
  final String? foodMenuId;
  final String foodName;
  final double foodPrice;
  final String foodType;
  final String? updatedAt;
  final String? createdAt;

  const FoodMenuEntity({
    this.foodMenuId,
    required this.foodName,
    required this.foodPrice,
    required this.foodType,
    this.updatedAt,
    this.createdAt,
  });

  // added this

  factory FoodMenuEntity.fromJson(Map<String, dynamic> json) {
    return FoodMenuEntity(
      foodMenuId: json['id'],
      foodName: json['foodName'],
      foodPrice: json['price'].toDouble(),
      foodType: json['foodType'],
    );
  }

  // convert JSON object to a entity
  Map<String, dynamic> toJson(data) {
    return {
      'id': foodMenuId,
      'foodName': foodName,
      'price': foodPrice.toDouble(),
      'foodType': foodType,
    };
  }

  @override
  List<Object?> get props => [foodMenuId, foodName, foodPrice, foodType];

  @override
  String toString() {
    return 'Food id : $foodMenuId, Food name : $foodName';
  }
}
