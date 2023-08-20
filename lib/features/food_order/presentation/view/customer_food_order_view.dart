import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common/widget/custom_appbar_widget.dart';
import '../../../../core/common/widget/device_size.dart';

final itemSelectionProvider = StateProvider<bool>((ref) => false);

class CustomerFoodOrderView extends ConsumerStatefulWidget {
  const CustomerFoodOrderView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerFoodOrderViewState();
}

class _CustomerFoodOrderViewState extends ConsumerState<CustomerFoodOrderView> {
  // final _foodItems = FoodMenuState.getFoodMenuFromState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Food Order'),
      body: Container(
        // color: Colors.pink,
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: DeviceSize.height * .01,
        ),
        child: ListView.separated(
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Checkbox(
                        value: ref.watch(itemSelectionProvider),
                        onChanged: (value) {
                          if (ref.watch(itemSelectionProvider)) {
                            ref.watch(itemSelectionProvider.notifier).state =
                                false;
                          } else {
                            ref.watch(itemSelectionProvider.notifier).state =
                                true;
                          }
                        }),
                    // Text(
                    //   // __foodItemList[index].foodName.toString(),
                    //   '${_foodItems[index].foodName} - ${_foodItems[index].foodType}',
                    //   style: kBoldPoppinsTextStyle.copyWith(
                    //       fontSize: 14, fontWeight: FontWeight.w500),
                    // ),
                    const Spacer(),
                    // Text(
                    //   'Rs. ${_foodItems[index].foodPrice}',
                    //   style: kBoldPoppinsTextStyle.copyWith(fontSize: 14),
                    // ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.transparent, height: 15),
            // itemCount: _foodItems.length),
            itemCount: 2),
      ),
    );
  }
}
