import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/router/app_route.dart';
import '../../../../core/common/widget/snackbar_messages.dart';
import '../../../auth/presentation/state/auth_state.dart';
import '../../domain/entity/restaurant_entity.dart';
import '../../domain/entity/update_restaurant_entity.dart';
import '../../domain/use_case/restaurant_use_case.dart';
import '../state/restaurant_state.dart';

final restaurantViewModelProvider =
    StateNotifierProvider<RestaurantViewModel, RestaurantState>(
  (ref) => RestaurantViewModel(
    ref.read(restaurantUseCaseProvider),
  ),
);

class RestaurantViewModel extends StateNotifier<RestaurantState> {
  // Note: restaurantId is already declared in Splash view model by reading from Shared Prefs
  String? targetedRestaurantId = RestaurantState.restaurantId;
  final RestaurantUseCase restaurantUseCase;

  RestaurantViewModel(this.restaurantUseCase)
      : super(RestaurantState.initial()) {
    if (AuthState.userEntity!.role == 'customer') {
      // for customers
      getAllRestaurants();
      getAllFavoriteRestaurants();
    } else {
      // for owners
      getARestaurant(restaurantId: targetedRestaurantId!);
    }
  }

  Future<void> getARestaurant({required String restaurantId}) async {
    // on the loading
    state = state.copyWith(isLoading: true);
// get the data
    var data = await restaurantUseCase.getARestaurant(restaurantId);
    data.fold(
        (failed) =>
            state = state.copyWith(isLoading: false, error: failed.error),
        (gotRestaurant) {
      // also update the state
      RestaurantState.restaurantEntity = gotRestaurant;
      // stop the loading, store the restaurant
      state = state.copyWith(
          isLoading: false, error: null, singleRestaurant: gotRestaurant);
    });
  }

  // get all restaurants
  Future<void> getAllRestaurants() async {
    state = state.copyWith(isLoading: true);

    var data = await restaurantUseCase.getAllRestaurants();

    data.fold((failed) {
      state = state.copyWith(isLoading: false, error: failed.error);
    }, (gotAllRestaurants) {
      // also store in the state
      state = state.copyWith(
          isLoading: false, error: null, allRestaurants: gotAllRestaurants);
    });
  }

  // create a restaurant
  Future<void> createARestaurant(
      RestaurantEntity restaurantEntity, BuildContext context) async {
    state = state.copyWith(isLoading: true);
    var data = await restaurantUseCase.createARestaurant(restaurantEntity);
    data.fold((failed) {
      state = state.copyWith(isLoading: false, error: failed.error);
      showSnackbarMsg(
        context: context,
        targetTitle: 'Error',
        targetMessage: failed.error,
        type: ContentType.failure,
      );
    }, (success) {
      state = state.copyWith(isLoading: false, error: null);

      // navigate to sign in view
      Navigator.pushNamed(context, AppRoute.ownerDashboardRoute);
    });
  }

  // add favorite restaurant
  Future<void> addFavoriteRestaurant({required String restaurantId}) async {
    state = state.copyWith(isLoading: true);
    var data = await restaurantUseCase.addFavoriteRestaurant(restaurantId);
    data.fold(
      (l) {
        state = state.copyWith(isLoading: false, error: l.error);
      },
      (success) {
        state = state.copyWith(isLoading: false, error: null);
        getAllFavoriteRestaurants();
      },
    );
  }

  // delete favorite restaurant
  Future<void> deleteFavoriteRestaurant(
      {required String restaurantId, required String favoriteId}) async {
    state = state.copyWith(isLoading: true);
    var data = await restaurantUseCase.deleteFavoriteRestaurant(
        restaurantId, favoriteId);
    data.fold(
      (l) {
        state = state.copyWith(isLoading: false, error: l.error);
      },
      (success) {
        state = state.copyWith(isLoading: false, error: null);
        getAllFavoriteRestaurants();
      },
    );
  }

  // get all favorite restaurants
  Future<void> getAllFavoriteRestaurants() async {
    state = state.copyWith(isLoading: true);
    var data = await restaurantUseCase.getAllFavoriteRestaurants();
    data.fold(
      (l) {
        state = state.copyWith(isLoading: false, error: l.error);
      },
      (success) {
        state = state.copyWith(isLoading: false, error: null);
      },
    );
  }

  // update restaurant and owner details
  Future<void> updateUserAndRestaurant(
      {required UpdateRestaurantEntity restaurantEntity,
      required BuildContext context}) async {
    state = state.copyWith(isLoading: true);
    var data =
        await restaurantUseCase.updateUserAndRestaurant(restaurantEntity);
    data.fold(
      (failed) {
        state = state.copyWith(isLoading: false, error: failed.error);
        showSnackbarMsg(
          context: context,
          targetMessage: failed.error,
          targetTitle: 'Error',
          type: ContentType.failure,
        );
      },
      (success) {
        state = state.copyWith(isLoading: false, error: null);
        Navigator.pop(context);
        showSnackbarMsg(
          context: context,
          targetTitle: 'Success',
          targetMessage: 'Account credentials are updated.',
          type: ContentType.success,
        );
      },
    );
  }
}
