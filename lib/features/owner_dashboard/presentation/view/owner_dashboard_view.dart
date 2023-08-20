import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/constants/api_endpoints.dart';
import '../../../../config/router/app_route.dart';
import '../../../../config/themes/app_color_constant.dart';
import '../../../../config/themes/constant.dart';
import '../../../../core/common/provider/is_dark_theme.dart';
import '../../../../core/common/widget/device_size.dart';
import '../../../auth/presentation/state/auth_state.dart';
import '../../../auth/presentation/viewmodel/auth_view_model.dart';
import '../../../food_order/presentation/viewmodel/food_order_viewmodel.dart';
import '../../../restaurant/presentation/state/restaurant_state.dart';
import '../../../restaurant/presentation/viewmodel/restaurant_viewmodel.dart';
import '../widget/dashboard_card_widget.dart';

final isDarkProvider = StateProvider<bool>((ref) => false);

class OwnerDashboardView extends ConsumerWidget {
  OwnerDashboardView({super.key});

  String? restaurantId = RestaurantState.restaurantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var restaurantState = ref.watch(restaurantViewModelProvider);
    ref
        .watch(restaurantViewModelProvider.notifier)
        .getARestaurant(restaurantId: RestaurantState.restaurantId!);

    ref.watch(isDarkThemeProvider);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leadingWidth: DeviceSize.width * .17,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: CircleAvatar(
              minRadius: 20,
              backgroundImage: NetworkImage(
                // 'https://hips.hearstapps.com/housebeautiful.cdnds.net/17/42/2048x1024/landscape-1508239345-family-eating-lunch-close-up-of-food-on-wooden-table.jpg?resize=1200:*',
                '${ApiEndpoints.imageUrl}${AuthState.userEntity!.picture}',
              ),
              backgroundColor: Colors.white,
            ),
          ),
          title: Text(
            restaurantState.singleRestaurant!.name.toString(),
            // RestaurantState.restaurantEntity!.name.toString(),
            style: kBoldPoppinsTextStyle.copyWith(
                color: ref.watch(isDarkThemeProvider)
                    ? AppColorConstant.nightTextColor
                    : AppColorConstant.dayTextColor),
          ),
          centerTitle: true,
          elevation: 0.0,
          toolbarHeight: DeviceSize.height * 0.12,
          actions: [
            Switch(
                value: ref.watch(isDarkThemeProvider),
                onChanged: (value) {
                  ref.watch(isDarkThemeProvider.notifier).updateTheme(value);
                }),
            IconButton(
                onPressed: () {
                  ref
                      .watch(authViewModelProvider.notifier)
                      .logout(context: context);
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: Container(
          margin: EdgeInsets.all(DeviceSize.width * .1),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            children: [
              DashboardCardWidget(
                imagePath: 'assets/images/png_dashboard/profile.png',
                title: 'Profile',
                onCustomTap: () {
                  Navigator.pushNamed(context, AppRoute.ownerProfileRoute);
                },
              ),
              DashboardCardWidget(
                imagePath: 'assets/images/png_dashboard/new_reservation.png',
                title: 'New Reservation',
                onCustomTap: () {
                  Navigator.pushNamed(context, AppRoute.ownerReservationRoute);
                },
              ),
              DashboardCardWidget(
                imagePath: 'assets/images/png_dashboard/food_order.png',
                title: 'Food Order',
                onCustomTap: () {
                  ref
                      .watch(foodOrderViewModelProvider.notifier)
                      .getAllFoodOrders(RestaurantState.restaurantId!);

                  Navigator.pushNamed(context, AppRoute.ownerFoodOrderRoute);
                },
              ),
              DashboardCardWidget(
                imagePath: 'assets/images/png_dashboard/reviews.png',
                title: 'Reviews',
                onCustomTap: () {
                  Navigator.pushNamed(context, AppRoute.ownerReviewRoute);
                },
              ),
              DashboardCardWidget(
                imagePath: 'assets/images/png_dashboard/menu.png',
                title: 'Menu',
                onCustomTap: () {
                  Navigator.pushNamed(context, AppRoute.ownerAddMenuViewRoute);
                },
              ),
            ],
          ),
        ));
  }
}
