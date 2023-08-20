// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationApiModel _$ReservationApiModelFromJson(Map<String, dynamic> json) =>
    ReservationApiModel(
      reservationId: json['_id'] as String?,
      date: json['date'] as String,
      userName: json['userName'] as String?,
      time: json['time'] as String,
      numberOfDinners: json['numberOfDinners'] as int,
      dinnerPlace: json['dinnerPlace'] as String,
      isCancelled: json['isCancelled'] as bool,
      isModifiedData: json['isModifiedData'] as bool,
      isFoodOrder: json['isFoodOrder'] as bool,
      restaurantName: json['restaurantName'] as String,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$ReservationApiModelToJson(
        ReservationApiModel instance) =>
    <String, dynamic>{
      '_id': instance.reservationId,
      'date': instance.date,
      'time': instance.time,
      'numberOfDinners': instance.numberOfDinners,
      'dinnerPlace': instance.dinnerPlace,
      'isCancelled': instance.isCancelled,
      'isModifiedData': instance.isModifiedData,
      'isFoodOrder': instance.isFoodOrder,
      'restaurantName': instance.restaurantName,
      'userId': instance.userId,
      'userName': instance.userName,
    };
