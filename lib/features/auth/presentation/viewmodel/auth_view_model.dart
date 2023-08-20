import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/router/app_route.dart';
import '../../../../core/common/widget/snackbar_messages.dart';
import '../../../../core/failure/failure.dart';
import '../../../restaurant/presentation/state/restaurant_state.dart';
import '../../domain/entity/update_customer_profile_entity.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/use_case/auth_usecase.dart';
import '../state/auth_state.dart';

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  return AuthViewModel(ref.read(authUseCaseProvider));
});

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthUseCase _authUseCase;

  AuthViewModel(this._authUseCase) : super(AuthState(isLoading: false));

// NOte: UI call this method for registration
  Future<void> registerUser(
      {required UserEntity user, required BuildContext context}) async {
    // load the progress bar
    state = state.copyWith(isLoading: true);
    // get the data from the server
    Either<Failure, bool> data = await _authUseCase.registerUser(user);

    data.fold(
        // registration fail
        (failure) {
      // error that comes from server
      state = state.copyWith(isLoading: false, error: failure.error);

      showSnackbarMsg(
        context: context,
        targetMessage: failure.error,
        targetTitle: 'Error',
        type: ContentType.failure,
      );
    },

        // registration success
        (registerSuccess) {
      state = state.copyWith(isLoading: false, error: null);
    });
  }

// NOte: UI call this method for registration
  Future<void> loginUser({
    required username,
    required String password,
    required BuildContext context,
  }) async {
    // load the progress bar
    state = state.copyWith(isLoading: true);

    // get the response from the server
    Either<Failure, bool> data =
        await _authUseCase.loginUser(username, password);

    data.fold((failure) {
      state = state.copyWith(isLoading: false, error: failure.error);
      // TODO Note: DO NOT write flutter code here but it will be fixed later on
      showSnackbarMsg(
        context: context,
        targetMessage: failure.error,
        targetTitle: 'Error',
        type: ContentType.failure,
      );
    }, (success) {
      state = state.copyWith(isLoading: false, error: null);

      // uncomment Flutter code because of issue during unit test

      // Navigator.pushNamed(context, AppRoute.ownerDashboardRoute);  // uncomment this for testing login widget testing

      if (AuthState.userEntity!.role == 'customer') {
        Navigator.pushNamed(context, AppRoute.navigationRoute);
      } else {
        if (RestaurantState.restaurantId == 'NA' ||
            RestaurantState.restaurantId == 'test101') {
          Navigator.pushNamed(context, AppRoute.fillRestaurantDetailsRoute);
        } else {
          Navigator.pushNamed(context, AppRoute.ownerDashboardRoute);
        }
      }
    });
  }

  // update user profile
  Future<void> updateUserProfile(
      {required UpdateCustomerProfileEntity customerProfileEntity,
      required BuildContext context}) async {
    // load the progress bar
    state = state.copyWith(isLoading: true);

    // get the response from the server
    var data = await _authUseCase.updateUserProfile(customerProfileEntity);

    data.fold((failed) {
      state = state.copyWith(isLoading: false, error: failed.error);

      showSnackbarMsg(
        context: context,
        targetMessage: failed.error,
        targetTitle: 'Error',
        type: ContentType.failure,
      );
    }, (success) {
      // store old details
      UserEntity oldUserDetails = AuthState.userEntity!;

      // also update auth state ==> fullName, contact, email, username
      AuthState.userEntity = UserEntity(
        id: oldUserDetails.id,
        fullName: customerProfileEntity.fullName,
        contact: customerProfileEntity.contact,
        role: oldUserDetails.role,
        email: customerProfileEntity.email,
        username: customerProfileEntity.username,
      );

      // close the loading
      state = state.copyWith(isLoading: false, error: null);

      // close the showModalBottom sheet
      Navigator.popAndPushNamed(context, AppRoute.navigationRoute);
      showSnackbarMsg(
        context: context,
        targetTitle: 'Success',
        targetMessage: 'Account credentials are updated.',
        type: ContentType.success,
      );
    });
  }

  // upload profile pic
  Future<void> uploadImage(File? file) async {
    state = state.copyWith(isLoading: true);
    var data = await _authUseCase.uploadProfilePicture(file!);
    data.fold(
      (l) {
        state = state.copyWith(isLoading: false, error: l.error);
      },
      (imageName) {
        state =
            state.copyWith(isLoading: false, error: null, imageName: imageName);
      },
    );
  }

  Future<void> deleteAccount({required BuildContext context}) async {
    state = state.copyWith(isLoading: true);
    var data = await _authUseCase.deleteAccount();
    data.fold(
      (l) {
        state = state.copyWith(isLoading: false, error: l.error);
        showSnackbarMsg(
          context: context,
          targetTitle: 'Error',
          targetMessage: l.error,
          type: ContentType.failure,
        );
      },
      (success) {
        state = state.copyWith(
          isLoading: false,
          error: null,
        );

        showSnackbarMsg(
          context: context,
          targetTitle: 'Success',
          targetMessage: 'Account is deleted successfully.',
          type: ContentType.success,
        );

        Navigator.pushNamedAndRemoveUntil(
            context, AppRoute.signInRoute, (route) => false);
      },
    );
  }

  Future<void> logout({required BuildContext context}) async {
    state = state.copyWith(isLoading: true);
    var data = await _authUseCase.logout();
    data.fold(
      (l) {
        state = state.copyWith(isLoading: false, error: l.error);
        showSnackbarMsg(
          context: context,
          targetTitle: 'Error',
          targetMessage: l.error,
          type: ContentType.failure,
        );
      },
      (success) {
        state = state.copyWith(
          isLoading: false,
          error: null,
        );

        showSnackbarMsg(
          context: context,
          targetTitle: 'Success',
          targetMessage: 'Logout successfully.',
          type: ContentType.success,
        );

        Navigator.pushNamedAndRemoveUntil(
            context, AppRoute.signInRoute, (route) => false);
      },
    );
  }
}
