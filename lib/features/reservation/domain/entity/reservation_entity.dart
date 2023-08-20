import 'package:equatable/equatable.dart';

class ReservationEntity extends Equatable {
  final String? reservationId;
  final String date;
  final String time;
  final int numberOfDinners;
  final String dinnerPlace;
  final bool isCancelled;
  final bool isModifiedData;
  final bool isFoodOrder;
  final String restaurantName;
  final String userId;
  final String? userName;
  final String? userPicture;
  final String? restaurantPicture;

  const ReservationEntity({
    this.reservationId,
    required this.date,
    this.userName,
    this.userPicture,
    this.restaurantPicture,
    required this.time,
    required this.numberOfDinners,
    required this.dinnerPlace,
    required this.isCancelled,
    required this.isModifiedData,
    required this.isFoodOrder,
    required this.restaurantName,
    required this.userId,
  });

  factory ReservationEntity.fromJson(Map<String, dynamic> json) {
    return ReservationEntity(
      reservationId: json['id'],
      date: json['date'],
      time: json['time'],
      numberOfDinners: json['numberOfDinners'],
      dinnerPlace: json['dinnerPlace'],
      isCancelled: json['isCancelled'],
      isModifiedData: json['isModifiedData'],
      isFoodOrder: json['isFoodOrder'],
      restaurantName: json['restaurantName'],
      userId: json['userId'],
      userName: json['userName'] ?? '',
      userPicture: json['userPicture'] ?? '',
      restaurantPicture: json['restaurantPicture'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        reservationId,
        date,
        time,
        numberOfDinners,
        dinnerPlace,
        isCancelled,
        isModifiedData,
        isFoodOrder,
        restaurantName,
        userId,
        userName,
        userPicture,
        restaurantPicture,
      ];

  @override
  String toString() {
    return 'Reservation id : $reservationId , Restaurant name : $restaurantName , Date : $date , Time : $time , Number of dinners : $numberOfDinners , Dinner place : $dinnerPlace , User name : $userName ';
  }
}
