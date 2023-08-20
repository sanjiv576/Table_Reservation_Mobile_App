import 'package:equatable/equatable.dart';

class FoodItems extends Equatable {
  final String foodName;
  final double price;
  final int quantity;
  const FoodItems({
    required this.foodName,
    required this.price,
    required this.quantity,
  });

  factory FoodItems.fromJson(Map<String, dynamic> json) {
    return FoodItems(
        foodName: json['foodName'],
        price: json['price'].toDouble(),
        quantity: json['quantity']);
  }

// toJson for converting food items enitity into JSON
  Map<String, dynamic> toJson() {
    return {
      'foodName': foodName,
      'price': price,
      'quantity': quantity,
    };
  }

  @override
  List<Object?> get props => [foodName, price, quantity];

  @override
  String toString() {
    return 'Food name : $foodName , price : $price , quantity : $quantity';
  }
}
