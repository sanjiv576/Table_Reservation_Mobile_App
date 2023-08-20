import 'package:flutter/material.dart';

import '../../../../config/constants/api_endpoints.dart';
import '../../../../config/router/app_route.dart';
import '../../../restaurant/presentation/state/restaurant_state.dart';

class HorizontalRestaurantsView extends StatelessWidget {
  const HorizontalRestaurantsView({
    super.key,
    required this.restaurantState,
    required this.gap,
  });

  final RestaurantState? restaurantState;
  final SizedBox gap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Expanded(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoute.restaurantRoute,
                        arguments: restaurantState!.allRestaurants![index],
                      );
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        // 'https://hips.hearstapps.com/housebeautiful.cdnds.net/17/42/2048x1024/landscape-1508239345-family-eating-lunch-close-up-of-food-on-wooden-table.jpg?resize=1200:*',
                        '${ApiEndpoints.imageUrl}${restaurantState!.allRestaurants![index].picture}',
                      ),
                    ),
                  ),
                  gap,
                  Text(
                    // 'ABC restaurant',
                    restaurantState!.allRestaurants![index].name,
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              width: 20,
            );
          },
          itemCount: restaurantState!.allRestaurants!.length),
    );
  }
}
