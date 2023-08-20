import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/router/app_route.dart';
import '../../../../core/common/widget/snackbar_messages.dart';
import '../../domain/entity/reservation_entity.dart';
import '../../domain/use_case/reservation_use_case.dart';
import '../state/reservation_state.dart';

final reservationViewModelProvider =
    StateNotifierProvider<ReservationViewModel, ReservationState>(
  (ref) => ReservationViewModel(
    ref.read(reservationUseCaseProvider),
  ),
);

class ReservationViewModel extends StateNotifier<ReservationState> {
  final ReservationUseCase _reservationUseCase;
  ReservationViewModel(this._reservationUseCase)
      : super(ReservationState.initial()) {
    getAllUserReservations();
  }

  // create reservation
  Future<void> createReservation(ReservationEntity reservation,
      String restaurantId, BuildContext context) async {
    state = state.copyWith(isLoading: true);
    final result =
        await _reservationUseCase.createReservation(reservation, restaurantId);
    result.fold(
        (failure) =>
            state = state.copyWith(isLoading: false, error: failure.error),
        (reservation) {
      // add the updated value in the top of the list
      state.allReservations!.insert(0, reservation);
      state = state.copyWith(
          isLoading: false, error: null, reservationEntity: reservation);

      getAllUserReservations();
    });
  }

  // get all reservations
  Future<void> getAllUserReservations() async {
    state = state.copyWith(isLoading: true);
    final result = await _reservationUseCase.getAllReservations();
    result.fold(
        (failure) =>
            state = state.copyWith(isLoading: false, error: failure.error),
        (reservations) {
      state = state.copyWith(
          isLoading: false, error: null, allReservations: reservations);
    });
  }

  // update a reservation
  Future<void> updateReservation(ReservationEntity reservationEntity,
      String reservationId, BuildContext context) async {
    state = state.copyWith(isLoading: true);

    final result = await _reservationUseCase.updateReservation(
        reservationEntity, reservationId);
    // get the result
    result.fold((l) {
      state = state.copyWith(isLoading: false, error: l.error);
      showSnackbarMsg(
        context: context,
        targetTitle: 'Error',
        targetMessage: l.error,
        type: ContentType.failure,
      );
    }, (r) {
      // remove from the list
      state.allReservations!
          .removeWhere((item) => item.reservationId == reservationId);

      // add the updated value in the top of the list
      state.allReservations!.insert(0, reservationEntity);
      // off the loading and set the value
      state = state.copyWith(
          isLoading: false,
          error: null,
          reservationEntity: reservationEntity,
          allReservations: state.allReservations);

      showSnackbarMsg(
        context: context,
        targetTitle: 'Success',
        targetMessage: 'Edited reservation successfully',
        type: ContentType.success,
      );
      getAllUserReservations();

      Navigator.popAndPushNamed(context, AppRoute.navigationRoute);
    });
  }

  // delete a reservation
  Future<void> deleteReservation(
      ReservationEntity reservation, BuildContext context) async {
    state = state.copyWith(isLoading: true);
    final result =
        await _reservationUseCase.deleteReservation(reservation.reservationId!);
    result.fold((l) {
      state = state.copyWith(isLoading: false, error: l.error);

      // show error in UI
      showSnackbarMsg(
        context: context,
        targetTitle: 'Error',
        targetMessage: l.error,
        type: ContentType.failure,
      );

      Navigator.pop(context);
    }, (r) {
      // remove the reservation from the state as well
      state.allReservations!.remove(reservation);

      // off the loading and set the value
      state = state.copyWith(
        isLoading: false,
        error: null,
      );
    });
  }

  // get a reservation
  Future<void> getAReservation(
      ReservationEntity reservation, BuildContext context) async {
    state = state.copyWith(isLoading: true);

    final result =
        await _reservationUseCase.getAReservation(reservation.reservationId!);
    result.fold((failure) {
      state = state.copyWith(isLoading: false, error: failure.error);

      showSnackbarMsg(
        context: context,
        targetTitle: 'Error',
        targetMessage: failure.error,
        type: ContentType.failure,
      );
    }, (reservation) {
      state = state.copyWith(
          isLoading: false, error: null, reservationEntity: reservation);

      Navigator.pushNamed(
        context,
        AppRoute.ownerReservationRequestRoute,
        arguments: reservation,
      );
    });
  }
}
