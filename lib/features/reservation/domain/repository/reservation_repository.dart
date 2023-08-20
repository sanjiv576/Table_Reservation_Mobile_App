import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../../data/repository/reservation_remote_repository_impl.dart';
import '../entity/reservation_entity.dart';

// allowed only Internet is available
final reservationRepositoryProvier = Provider<IReservationRepository>(
  (ref) => ref.read(reservationRemoteRepoImlProvider),
);

abstract class IReservationRepository {
  // create reservation
  Future<Either<Failure, ReservationEntity>> createReservation(
      ReservationEntity reservationEntity, String restaurantId);

  // update reservation
  Future<Either<Failure, bool>> updateReservation(
      ReservationEntity reservationEntity, String reservationId);

  // delete reservation
  Future<Either<Failure, bool>> deleteReservation(String reservationId);

  // get a reservation
  Future<Either<Failure, ReservationEntity>> getAReservation(
      String reservationId);

  // get all reservations where either the user role is owner or customer is filetered in Data source
  Future<Either<Failure, List<ReservationEntity>>> getAllReservations();
}
