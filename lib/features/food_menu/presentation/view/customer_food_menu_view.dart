import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common/widget/custom_appbar_widget.dart';
import '../../../../core/common/widget/device_size.dart';
import '../../domain/entity/food_menu_entity.dart';
import '../state/food_menu_state.dart';
import '../viewmodel/food_menu_viewmodel.dart';

class CustomerFoodMenuView extends ConsumerWidget {
  CustomerFoodMenuView({super.key});

  List<FoodMenuEntity> _foodMenu = [];

  final TextStyle _textStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var foodMenuState = ref.watch(foodMenuViewModelProvider);

    _foodMenu = FoodMenuState.restaurantFoodMenu!;

    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Food Menu'),
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
              Center(
                child: Text(
                  'No food items available',
                  style: _textStyle.copyWith(color: Colors.white),
                ),
              )
            } else if (_foodMenu.isNotEmpty) ...{
              Expanded(
                child: ListView.separated(
                  itemCount: _foodMenu.length,
                  itemBuilder: (context, index) {
                    final foodItem = _foodMenu[index];
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                          title: Text(
                            foodItem.foodName,
                            style: _textStyle,
                          ),
                          subtitle: Text(
                            foodItem.foodType,
                            style: _textStyle.copyWith(
                                fontWeight: FontWeight.normal, fontSize: 14),
                          ),
                          trailing: Text(
                            'Price: ${foodItem.foodPrice}',
                            style: _textStyle.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          )),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      height: 20,
                      color: Colors.transparent,
                    );
                  },
                ),
              ),
            },
          ],
        ),
      ),
    );
  }
}
