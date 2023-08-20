import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/reservation_entity.dart';
part 'reservation_api_model.g.dart';

final reservationApiModelProvider = Provider<ReservationApiModel>((ref) {
  return ReservationApiModel(
    date: '',
    time: '',
    numberOfDinners: 0,
    dinnerPlace: '',
    isCancelled: false,
    isModifiedData: false,
    isFoodOrder: false,
    restaurantName: '',
    userId: '',
  );
});

@JsonSerializable()
class ReservationApiModel {
  @JsonKey(name: '_id')
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

  ReservationApiModel({
    this.reservationId,
    required this.date,
    this.userName,
    required this.time,
    required this.numberOfDinners,
    required this.dinnerPlace,
    required this.isCancelled,
    required this.isModifiedData,
    required this.isFoodOrder,
    required this.restaurantName,
    required this.userId,
  });

// convert json to object
  factory ReservationApiModel.fromJson(Map<String, dynamic> json) {
    return _$ReservationApiModelFromJson(json);
  }

// convert object to json
  Map<String, dynamic> toJson() {
    return _$ReservationApiModelToJson(this);
  }

// convert ReservationApiModel to ReservationEntity
  ReservationEntity toEntity() {
    return ReservationEntity(
      reservationId: reservationId,
      date: date,
      time: time,
      numberOfDinners: numberOfDinners,
      dinnerPlace: dinnerPlace,
      isCancelled: isCancelled,
      isModifiedData: isModifiedData,
      isFoodOrder: isFoodOrder,
      restaurantName: restaurantName,
      userId: userId,
    );
  }

  // Convert AuthApiModel list to AuthEntity list
  List<ReservationEntity> listFromJson(List<ReservationApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  String toString() {
    return 'ReservationApiModel(id: $reservationId, restaurantName: $restaurantName)';
  }
}
