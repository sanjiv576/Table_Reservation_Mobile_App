import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../../domain/entity/reservation_entity.dart';
import '../../domain/repository/reservation_repository.dart';
import '../data_sources/reservation_remote_data_source.dart';

final reservationRemoteRepoImlProvider = Provider<IReservationRepository>(
  (ref) => ReservationRemoteRepoImpl(
    ref.read(reservationRemoteDataSourceProvider),
  ),
);

class ReservationRemoteRepoImpl extends IReservationRepository {
  final ReservationRemoteDataSource _reservationRemoteDataSource;

  ReservationRemoteRepoImpl(this._reservationRemoteDataSource);

  @override
  Future<Either<Failure, ReservationEntity>> createReservation(
      ReservationEntity reservationEntity, String restaurantId) {
    return _reservationRemoteDataSource.createReservation(
        reservationEntity, restaurantId);
  }

  @override
  Future<Either<Failure, List<ReservationEntity>>> getAllReservations() {
    return _reservationRemoteDataSource.getAllReservations();
  }

  @override
  Future<Either<Failure, bool>> updateReservation(
      ReservationEntity reservationEntity, String reservationId) {
    return _reservationRemoteDataSource.updateReservation(
        reservationEntity, reservationId);
  }

  @override
  Future<Either<Failure, bool>> deleteReservation(String reservationId) {
    return _reservationRemoteDataSource.deleteReservation(reservationId);
  }

  @override
  Future<Either<Failure, ReservationEntity>> getAReservation(
      String reservationId) {
    return _reservationRemoteDataSource.getAReservation(reservationId);
  }
}
