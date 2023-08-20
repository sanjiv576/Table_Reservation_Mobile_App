import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:table_reservation_mobile_app/features/reservation/domain/entity/reservation_entity.dart';

Future<List<ReservationEntity>> getReservationsTest() async {
  final response =
      await rootBundle.loadString('test_data/reservations_test_data.json');

// decode json data
  final jsonList = await json.decode(response);

// convert each decoded JSON of reservation object and add in the list
  final List<ReservationEntity> reservationList = jsonList
      .map<ReservationEntity>((json) => ReservationEntity.fromJson(json))
      .toList();

  return Future.value(reservationList);
}
