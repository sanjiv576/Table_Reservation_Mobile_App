import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../entity/reservation_entity.dart';
import '../repository/reservation_repository.dart';

final reservationUseCaseProvider = Provider(
  (ref) => ReservationUseCase(
    ref.read(reservationRepositoryProvier),
  ),
);

class ReservationUseCase {
  final IReservationRepository _reservationRepository;
  ReservationUseCase(this._reservationRepository);

  // create reservation
  Future<Either<Failure, ReservationEntity>> createReservation(
      ReservationEntity reservationEntity, String restaurantId) {
    return _reservationRepository.createReservation(
        reservationEntity, restaurantId);
  }

  // get all reservations
  Future<Either<Failure, List<ReservationEntity>>> getAllReservations() {
    return _reservationRepository.getAllReservations();
  }

  // update a reservation
  Future<Either<Failure, bool>> updateReservation(
      ReservationEntity reservationEntity, String reservationId) {
    return _reservationRepository.updateReservation(
        reservationEntity, reservationId);
  }

  // delete a reservation
  Future<Either<Failure, bool>> deleteReservation(String reservationId) {
    return _reservationRepository.deleteReservation(reservationId);
  }

  // get a reservation
  Future<Either<Failure, ReservationEntity>> getAReservation(
      String reservationId) {
    return _reservationRepository.getAReservation(reservationId);
  }
}
