import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_reservation_mobile_app/features/food_order/presentation/state/food_order_state.dart';

import '../../../../config/router/app_route.dart';
import '../../../../core/common/widget/custom_appbar_widget.dart';
import '../viewmodel/food_order_viewmodel.dart';

class OwnerFoodOrderView extends ConsumerWidget {
  OwnerFoodOrderView({super.key});

  Color activeColor = Colors.black;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var foodOrderState = ref.watch(foodOrderViewModelProvider);
    var foodOrderList = foodOrderState.foodOrderList;

    print('List of food orders : ${foodOrderState.foodOrderList}');

    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Customer Food Orders'),
      body: Column(
        children: [
          if (foodOrderState.isLoading == true) ...{
            const Center(
              child: CircularProgressIndicator(),
            ),
          } else if (foodOrderState.error != null) ...{
            Text(
              'Error: ${foodOrderState.error!}',
              style: const TextStyle(color: Colors.red),
            ),
          } else if (foodOrderList!.isEmpty) ...{
            const Center(
              child: Text(
                'No food items available',
                style: TextStyle(color: Colors.white),
              ),
            )
          } else if (foodOrderList.isNotEmpty) ...{
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20,
                    ),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Wrap(
                      children: [
                        ListTile(
                          leading: const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.black,
                            backgroundImage: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTYnuvAw7_Vgyirya4Od0qjbZjASZKijOh_g&usqp=CAU',
                              // ApiEndpoints.imageUrl + foodOrderList[index].na,
                            ),
                          ),
                          // contentPadding: const EdgeInsets.all(0),
                          title: Text(
                            // 'Sanjiv Shrestha',
                            foodOrderList[index].userName.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                                color: activeColor),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ordered Food : Yes',
                                style: TextStyle(
                                    fontFamily: 'Poppins', color: activeColor),
                              ),
                              Text(
                                // 'Date: Nov 22, 2023',
                                'Date: ${foodOrderList[index].date.toString()}',
                                style: TextStyle(
                                    fontFamily: 'Poppins', color: activeColor),
                              ),
                              Text(
                                // 'Time: 11:30 AM',
                                'Time: ${foodOrderList[index].time.toString()}',
                                style: TextStyle(
                                    fontFamily: 'Poppins', color: activeColor),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                // store individual food order in the state
                                FoodOrderState.individualFoodOrder =
                                    foodOrderList[index];

                                Navigator.pushNamed(context,
                                    AppRoute.ownerIndividualOrderRoute);
                              },
                              icon: const Icon(
                                Icons.remove_red_eye,
                                color: Colors.black,
                                size: 35,
                              )),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: foodOrderList.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    color: Colors.transparent,
                  );
                },
              ),
            ),
          },
        ],
      ),
    );
  }
}
