import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_reservation_mobile_app/features/food_menu/domain/entity/food_menu_entity.dart';

import '../../../restaurant/presentation/state/restaurant_state.dart';
import '../../domain/use_case/food_menu_use_case.dart';
import '../state/food_menu_state.dart';

final foodMenuViewModelProvider =
    StateNotifierProvider<FoodMenuViewModel, FoodMenuState>(
  (ref) => FoodMenuViewModel(
    ref.read(foodMenuUseCaseProvider),
  ),
);

class FoodMenuViewModel extends StateNotifier<FoodMenuState> {
  String targetedRestaurantId = RestaurantState.restaurantId!;

  final FoodMenuUseCase foodMenuUseCase;
  FoodMenuViewModel(this.foodMenuUseCase) : super(FoodMenuState.initial()) {
    getFoodMenu(restaurantId: targetedRestaurantId);
  }

  // get food items i.e food menu by its restaurant id
  Future<void> getFoodMenu({required restaurantId}) async {
    // load ON the progress bar
    state = state.copyWith(isLoading: true);

    // get the data
    var data = await foodMenuUseCase.getFoodMenu(restaurantId);

    data.fold(
      (failed) => state = state.copyWith(isLoading: false, error: failed.error),
      (menu) =>
          state = state.copyWith(isLoading: false, error: null, foodMenu: menu),
    );
  }

  // add a single food item
  Future<void> addFoodItem({required FoodMenuEntity foodItem}) async {
    // ON the progress bar
    state = state.copyWith(isLoading: true);

    // get the response from the use case
    var data = await foodMenuUseCase.addFoodItem(foodItem);

    data.fold((failed) {
      state = state.copyWith(isLoading: false, error: failed.error);
    }, (success) {
      // add new food item at the top of the list in food menu state
      // this is commented because of error in unit testing
      state.foodMenu.insert(0, FoodMenuState.singleFoodItem!);

      // OFF the progress bar
      state = state.copyWith(isLoading: false, error: null);
    });
  }

  // update a food item by calling useCase method
  Future<void> updateAFoodItem(
      {required String foodItemId, required FoodMenuEntity foodItem}) async {
    // rotate the progress bar
    state = state.copyWith(isLoading: true);

    // get the data
    var data = await foodMenuUseCase.updateAFoodItem(foodItemId, foodItem);

    data.fold((failed) {
      state = state.copyWith(isLoading: false, error: failed.error);
    }, (success) {
      // this is commented because of error in unit testing
      state.foodMenu.removeWhere((item) => item.foodMenuId == foodItemId);
      // add the updated value in the top of the list
      state.foodMenu.insert(0, FoodMenuState.singleFoodItem!);

      state = state.copyWith(isLoading: false, error: null);
    });
  }

  // delete a food item
  Future<void> deleteAFoodItem({required FoodMenuEntity foodItem}) async {
    state = state.copyWith(isLoading: true);

    var data = await foodMenuUseCase.deleteAFoodItem(foodItem);

    data.fold((failed) {
      state = state.copyWith(isLoading: false, error: failed.error);
    }, (success) {
      // remove the food item from the state as well
      state.foodMenu.remove(foodItem);

      // off the progress bar
      state = state.copyWith(isLoading: false, error: null);
    });
  }
}
