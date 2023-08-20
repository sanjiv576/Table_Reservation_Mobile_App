import 'package:equatable/equatable.dart';
import 'package:table_reservation_mobile_app/features/food_order/domain/entity/food_items.dart';

class FoodOrderEntity extends Equatable {
  final String? foodOrderId;
  final String date;
  final String time;
  final List<FoodItems> items;
  final String status;
  final bool isPaid;
  final double totalAmount;
  final String userId;
  final String userName;

  const FoodOrderEntity({
    this.foodOrderId,
    required this.date,
    required this.time,
    required this.items,
    required this.status,
    required this.isPaid,
    required this.totalAmount,
    required this.userId,
    required this.userName,
  });

  factory FoodOrderEntity.fromJson(Map<String, dynamic> json) {
    final List<dynamic> jsonItems = json['items'];
    final List<FoodItems> items =
        jsonItems.map<FoodItems>((json) => FoodItems.fromJson(json)).toList();
    return FoodOrderEntity(
        date: json['date'],
        time: json['time'],
        items: items,
        status: json['status'],
        isPaid: json['isPaid'],
        totalAmount: json['totalAmount'].toDouble(),
        userId: json['userId'],
        userName: json['userName'],
        foodOrderId: json['id']);
  }

  @override
  List<Object?> get props => [
        foodOrderId,
        date,
        time,
        items,
        status,
        isPaid,
        totalAmount,
        userId,
        userName
      ];

  @override
  String toString() {
    return 'Food order id : $foodOrderId, date : $date, time : $time, items : $items, totalAmount : $totalAmount, userName : $userName';
  }
}
