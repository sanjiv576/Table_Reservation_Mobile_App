import '../../domain/entity/food_order_entity.dart';

class FoodOrderState {
  bool? isLoading;
  String? error;
  List<FoodOrderEntity>? foodOrderList;

  static FoodOrderEntity? individualFoodOrder;

  FoodOrderState({
    this.isLoading,
    this.error,
    this.foodOrderList,
  });

  factory FoodOrderState.initial() => FoodOrderState(
        isLoading: false,
        error: null,
        foodOrderList: const [],
      );

  FoodOrderState copyWith({
    bool? isLoading,
    String? error,
    List<FoodOrderEntity>? foodOrderList,
  }) {
    return FoodOrderState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      foodOrderList: foodOrderList ?? this.foodOrderList,
    );
  }
}
