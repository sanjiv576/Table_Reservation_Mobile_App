import 'package:table_reservation_mobile_app/features/reservation/domain/entity/reservation_entity.dart';

class ReservationState {
  final bool isLoading;
  final String? error;
  final ReservationEntity? reservationEntity;
  final List<ReservationEntity>? allReservations;

  ReservationState(
      {required this.isLoading,
      this.error,
      this.reservationEntity,
      this.allReservations});

  factory ReservationState.initial() {
    return ReservationState(
        isLoading: false,
        error: null,
        reservationEntity: null,
        allReservations: null);
  }

  ReservationState copyWith(
      {bool? isLoading, String? error, ReservationEntity? reservationEntity,  List<ReservationEntity>? allReservations}) {
    return ReservationState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      reservationEntity: reservationEntity ?? this.reservationEntity,
      allReservations: allReservations ?? [],
    );
  }
}
