import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

import '../../../../core/common/widget/custom_appbar_widget.dart';
import '../../../../core/common/widget/device_size.dart';
import '../../../../core/common/widget/snackbar_messages.dart';
import '../../../auth/presentation/state/auth_state.dart';
import '../../../food_menu/domain/entity/food_menu_entity.dart';
import '../../../food_menu/presentation/state/food_menu_state.dart';
import '../../../food_menu/presentation/viewmodel/food_menu_viewmodel.dart';
import '../../../reservation/data/model/pick_date_time.dart';
import '../../../restaurant/presentation/state/restaurant_state.dart';
import '../../domain/entity/food_items.dart';
import '../../domain/entity/food_order_entity.dart';
import '../viewmodel/food_order_viewmodel.dart';

final foodItemQuantityCounterProvider = StateProvider<int>((ref) => 0);

class FoodOrderView extends ConsumerStatefulWidget {
  const FoodOrderView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FoodOrderViewState();
}

class _FoodOrderViewState extends ConsumerState<FoodOrderView> {
  // final List<Map<String, dynamic>> _selectedFoodItems = [];

  final List<FoodItems> _selectedFoodItems = [];

  List<FoodMenuEntity> _foodMenu = [];

  final int _lowerLimit = 0;
  final int _upperLimit = 10;
  double _foodOrderAmount = 0;

  void _addToCart(FoodItems foodItem) {
    _foodOrderAmount += foodItem.price * foodItem.quantity;

    setState(() {
      _selectedFoodItems.add(foodItem);
    });
  }

  int _getAmount() => _foodOrderAmount.round();

  void _openKhaltiPaymentView(BuildContext context) {
    var config = PaymentConfig(
      // Note: Because of limitaion in Khalti test payment Rs 10 send as deafult instead of _getAmount()
      amount: 10 * 100,
      productIdentity: '5510-2021',
      productName: 'Food Items',
      // productUrl: 'https://www.khalti.com/#/bazaar',
      // additionalData: {
      //   'vendor': 'Table Reservation ',
      // },
    );

    KhaltiScope.of(context).pay(
      config: config,
      preferences: [
        PaymentPreference.khalti,
        PaymentPreference.connectIPS,
        PaymentPreference.eBanking,
        PaymentPreference.sct,
      ],
      onSuccess: (successModel) {
        FoodOrderEntity foodOrder = FoodOrderEntity(
          date: PickDateTime.convertDate(date: DateTime.now()),
          time: PickDateTime.convertTime(time: TimeOfDay.now()),
          items: _selectedFoodItems,
          status: 'pending',
          isPaid: true,
          totalAmount: _foodOrderAmount,
          userId: AuthState.userEntity!.id!,
          userName: AuthState.userEntity!.fullName,
        );

        ref.watch(foodOrderViewModelProvider.notifier).createFoodOrder(
            restaurantId: RestaurantState.restaurantId,
            foodOrderEntity: foodOrder,
            context: context);
        showSnackbarMsg(
          context: context,
          targetTitle: 'Success',
          targetMessage: 'Payment success',
          type: ContentType.success,
        );
      },
      onFailure: (failureModel) {
        showSnackbarMsg(
          context: context,
          targetTitle: 'Failed',
          targetMessage: 'Failed in paymebt',
          type: ContentType.failure,
        );
      },
      onCancel: () {
        showSnackbarMsg(
          context: context,
          targetTitle: 'Cancellation',
          targetMessage: 'Payment is cancelled.',
          type: ContentType.warning,
        );
      },
    );
  }

  void _removeFromCart(int index) {
    _foodOrderAmount -=
        _selectedFoodItems[index].price * _selectedFoodItems[index].quantity;
    setState(() {
      _selectedFoodItems.removeAt(index);
    });
  }

  void _placeOrder() {
    // open Khalti page
    _openKhaltiPaymentView(context);
  }

  void _showCart() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        // Customize the cart display
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Your Cart',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _selectedFoodItems.length,
                itemBuilder: (context, index) {
                  final foodName = _selectedFoodItems[index].foodName;
                  final price = _selectedFoodItems[index].price;
                  final quantity = _selectedFoodItems[index].quantity;
                  return ListTile(
                    title: Text(foodName),
                    subtitle: Text('Price: $price | Quantity: $quantity'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeFromCart(index),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Text('Your total amount is Rs $_foodOrderAmount'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _placeOrder();
                },
                child: const Text('Place Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final TextStyle _textStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    // ref.watch(foodOrderViewModelProvider);
    var foodMenuState = ref.watch(foodMenuViewModelProvider);

    // _foodMenu = foodMenuState.foodMenu;
    _foodMenu = FoodMenuState.restaurantFoodMenu!;

    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Food Order'),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: DeviceSize.height * .01,
        ),
        child: Column(
          children: [
            if (foodMenuState.isLoading) ...{
              const Center(
                child: CircularProgressIndicator(),
              ),
            } else if (foodMenuState.error != null) ...{
              Text(
                'Error: ${foodMenuState.error!}',
                style: const TextStyle(color: Colors.red),
              ),
            } else if (_foodMenu.isEmpty) ...{
              const Center(
                child: Text(
                  'No food items available',
                  style: TextStyle(color: Colors.white),
                ),
              )
            } else if (_foodMenu.isNotEmpty) ...{
              Expanded(
                child: ListView.builder(
                  itemCount: _foodMenu.length,
                  itemBuilder: (context, index) {
                    final foodItem = _foodMenu[index];
                    return ListTile(
                      title: Text(
                        foodItem.foodName,
                        style: _textStyle,
                      ),
                      subtitle: Text(
                        'Price: ${foodItem.foodPrice}',
                        style: _textStyle.copyWith(fontSize: 14),
                      ),
                      trailing: Wrap(
                        direction: Axis.horizontal,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                            onPressed:
                                ref.watch(foodItemQuantityCounterProvider) >
                                        _lowerLimit
                                    ? () {
                                        ref
                                            .watch(
                                                foodItemQuantityCounterProvider
                                                    .notifier)
                                            .state = ref.watch(
                                                foodItemQuantityCounterProvider) -
                                            1;
                                      }
                                    : null,
                          ),
                          Text(
                            ref
                                .watch(foodItemQuantityCounterProvider)
                                .toString(),
                            style: _textStyle.copyWith(fontSize: 16),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            onPressed:
                                ref.watch(foodItemQuantityCounterProvider) <
                                        _upperLimit
                                    ? () {
                                        ref
                                            .watch(
                                                foodItemQuantityCounterProvider
                                                    .notifier)
                                            .state = ref.watch(
                                                foodItemQuantityCounterProvider) +
                                            1;
                                      }
                                    : null,
                          ),
                          ElevatedButton(
                            onPressed:
                                ref.watch(foodItemQuantityCounterProvider) != 0
                                    ? () {
                                        FoodItems addedFoodItem = FoodItems(
                                          foodName: foodItem.foodName,
                                          price: foodItem.foodPrice,
                                          quantity: ref.watch(
                                              foodItemQuantityCounterProvider),
                                        );
                                        _addToCart(addedFoodItem);
                                        // reset quanitity
                                        ref
                                            .watch(
                                                foodItemQuantityCounterProvider
                                                    .notifier)
                                            .state = 0;
                                      }
                                    : null,
                            child: const Text(
                              'Add',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            },
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _selectedFoodItems.isNotEmpty ? _showCart : null,
        label: const Text('View Cart'),
        icon: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
