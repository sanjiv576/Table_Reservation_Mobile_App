import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/router/app_route.dart';
import '../../../../core/common/widget/snackbar_messages.dart';
import '../../../restaurant/presentation/state/restaurant_state.dart';
import '../../domain/entity/food_order_entity.dart';
import '../../domain/use_case/food_order_use_case.dart';
import '../state/food_order_state.dart';

final foodOrderViewModelProvider =
    StateNotifierProvider<FoodOrderViewModel, FoodOrderState>(
  (ref) => FoodOrderViewModel(
    ref.read(foodOrderUseCaseProvider),
  ),
);

class FoodOrderViewModel extends StateNotifier<FoodOrderState> {
  final FoodOrderUseCase _foodOrderUseCase;

  String targetedRestaurantId = RestaurantState.restaurantId!;

  FoodOrderViewModel(this._foodOrderUseCase) : super(FoodOrderState.initial()) {
    getAllFoodOrders(targetedRestaurantId);
  }

  Future<void> getAllFoodOrders(String restaurantId) async {
    state = state.copyWith(isLoading: true);

    // get the data
    var data = await _foodOrderUseCase.getAllFoodOrders(restaurantId);
    data.fold((failed) {
      state = state.copyWith(isLoading: false, error: failed.error);
    }, (foodOrders) {
      state = state.copyWith(
          isLoading: false, error: null, foodOrderList: foodOrders);
    });
  }

  Future<void> createFoodOrder(
      {required restaurantId,
      required FoodOrderEntity foodOrderEntity,
      required BuildContext context}) async {
    state = state.copyWith(isLoading: true);
    // get the data
    var data =
        await _foodOrderUseCase.createFoodOrder(restaurantId, foodOrderEntity);
    data.fold((failed) {
      state = state.copyWith(isLoading: false, error: failed.error);

      showSnackbarMsg(
          context: context,
          targetTitle: 'Error',
          targetMessage: failed.error,
          type: ContentType.failure);
    }, (foodOrders) {
      state = state.copyWith(isLoading: false, error: null);

      _showOrderSuccessDialog(context);
    });
  }

  void _showOrderSuccessDialog(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order Placed Successfully'),
        content: const Text('Your order has been placed successfully.'),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.popAndPushNamed(context, AppRoute.navigationRoute),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
