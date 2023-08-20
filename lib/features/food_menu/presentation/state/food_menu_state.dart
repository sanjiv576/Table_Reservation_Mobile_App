import '../../domain/entity/food_menu_entity.dart';

class FoodMenuState {
  // FoodMenuState._();

  final bool isLoading;
  final String? error;
  final List<FoodMenuEntity> foodMenu;

  static FoodMenuEntity? singleFoodItem;

  FoodMenuState({
    required this.isLoading,
    required this.error,
    required this.foodMenu,
  });

  static List<FoodMenuEntity>? restaurantFoodMenu;

  // initial values
  factory FoodMenuState.initial() => FoodMenuState(
        isLoading: false,
        error: null,
        foodMenu: [],
      );

  FoodMenuState copyWith({
    bool? isLoading,
    String? error,
    List<FoodMenuEntity>? foodMenu,
  }) {
    return FoodMenuState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      foodMenu: foodMenu ?? this.foodMenu,
    );
  }

// --------------- below code for UI testing ------------------------

  // static late List<FoodMenuEntity> foodMenuFromState;

  // static List<FoodMenuEntity> getFoodMenuFromState() {
  //   return foodMenuFromState = [
  //     FoodMenuEntity(
  //       foodName: 'Chicken Burger',
  //       foodPrice: 160.toDouble(),
  //       foodType: 'non-veg',
  //     ),
  //     FoodMenuEntity(
  //       foodName: 'Mushroom Pizza',
  //       foodPrice: 180.toDouble(),
  //       foodType: 'veg',
  //     ),
  //   ];
  // }
}
