import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../../config/router/app_route.dart';
import '../../../../core/shared_prefs/user_shared_prefs.dart';
import '../../../auth/domain/entity/user_entity.dart';
import '../../../auth/presentation/state/auth_state.dart';
import '../../../restaurant/presentation/state/restaurant_state.dart';

final splashViewModelProvider = StateNotifierProvider<SplashViewModel, void>(
  (ref) {
    return SplashViewModel(
      ref.read(userSharedPrefsProvider),
    );
  },
);

class SplashViewModel extends StateNotifier<void> {
  final UserSharedPrefs _userSharedPrefs;
  SplashViewModel(this._userSharedPrefs) : super(null);

  init({required context}) async {
    // get the token
    final data = await _userSharedPrefs.getUserToken();

    data.fold((l) => null, (token) async {
      if (token != null && token != '') {
        bool isTokenExpired = isValidToken(token);
        if (isTokenExpired) {
          // do not do navigation like this,
          // later on , it will be handled by using mixin and navigator class for this
          Navigator.popAndPushNamed(context, AppRoute.signInRoute);
        } else {
          UserSharedPrefs userSharedPrefs = UserSharedPrefs();
          // get the user from the shared prefs to make decision to navigate which dashboard Customer or Restaurant Owner
          UserEntity? user;
          var data = await userSharedPrefs.getUserEntity();

          data.fold((fail) => user = null, (success) => user = success!);
          if (user != null) {
            AuthState.userEntity = user!;
          }

          // if (await userSharedPrefs.getUserRole() == 'customer') {
          if (user!.role == 'customer') {
            Navigator.popAndPushNamed(context, AppRoute.navigationRoute);
          } else {
            // get the restaurant Id
            // String RestaurantState.restaurantId;
            var data = await userSharedPrefs.getRestaurantId();
            data.fold((l) => RestaurantState.restaurantId = null, (r) {
              RestaurantState.restaurantId = r!;
            });

            // set the Restaurant
            Navigator.popAndPushNamed(context, AppRoute.ownerDashboardRoute);
          }
        }
      } else {
        Navigator.popAndPushNamed(context, AppRoute.introductionRoute);
      }
    });
  }

  bool isValidToken(String token) {
    //  decoding the token
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    int expirationTimestamp = decodedToken['exp'];

    final currentDate = DateTime.now().millisecondsSinceEpoch;
    // If current date is greater than expiration timestamp then token is expired
    return currentDate > expirationTimestamp * 1000;
  }
}
