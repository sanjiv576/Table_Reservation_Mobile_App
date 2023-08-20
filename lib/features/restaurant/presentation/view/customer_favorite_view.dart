import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/constants/api_endpoints.dart';
import '../../../../config/themes/app_color_constant.dart';
import '../../../../core/common/provider/is_dark_theme.dart';
import '../../../../core/common/widget/custom_appbar_widget.dart';
import '../state/favorite_state.dart';
import '../viewmodel/restaurant_viewmodel.dart';

class CustomerFavoriteView extends ConsumerWidget {
  const CustomerFavoriteView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDark = ref.read(isDarkThemeProvider);
    Color activeTextColor = isDark
        ? AppColorConstant.nightTextColor
        : AppColorConstant.dayTextColor;
    // ref.watch(restaurantViewModelProvider.notifier).getAllFavoriteRestaurants();
    ref.watch(restaurantViewModelProvider);
    List<dynamic>? allFavoriteRestaurants =
        FavoriteState.allFavoriteRestaurants;

    var favoriteState = ref.watch(restaurantViewModelProvider);
    return Scaffold(
      appBar: const CustomAppBarWidget(
        title: 'My Favorites',
      ),
      body: Column(
        children: [
          // if (favoriteState.isLoading) ...{
          //   const Center(
          //     child: CircularProgressIndicator(),
          //   ),
          // }
          if (favoriteState.error != null) ...{
            Expanded(
              child: Center(
                child: Text(
                  'Error: ${favoriteState.error!}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          } else if (allFavoriteRestaurants!.isEmpty) ...{
            const Center(
              child: Text('No favorite restaurants yet'),
            ),
          } else if (allFavoriteRestaurants.isNotEmpty) ...{
            // else ...{
            Expanded(
              child: ListView.separated(
                itemCount: allFavoriteRestaurants.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 12,
                    shadowColor: const Color.fromARGB(255, 211, 199, 199),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            // color: Colors.pink,
                            margin: const EdgeInsets.all(10),
                            child: CircleAvatar(
                              radius: 70,
                              backgroundImage: NetworkImage(
                                // 'https://media.istockphoto.com/id/1212417063/photo/table-full-of-food-for-family-dinner.jpg?s=612x612&w=0&k=20&c=VQw95DggeCDG_NHy5wHcg8BV7MhQmDDtLr-qxs4suiY=',
                                ApiEndpoints.imageUrl +
                                    allFavoriteRestaurants[index]['picture'],
                              ),
                              backgroundColor: Colors.black,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // 'ABC Restaurant',
                                  '${allFavoriteRestaurants[index]['restaurantsName']}',
                                  style: TextStyle(
                                      color: activeTextColor,
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        leading: const Icon(Icons.location_on),
                                        contentPadding: const EdgeInsets.all(0),
                                        title: Transform(
                                          transform: Matrix4.translationValues(
                                              -28, 0.0, 0.0),
                                          child: Text(
                                            // 'xyz location',
                                            '${allFavoriteRestaurants[index]['location']}',

                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: activeTextColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        leading: const Icon(Icons.call),
                                        contentPadding: const EdgeInsets.all(0),
                                        title: Transform(
                                          transform: Matrix4.translationValues(
                                              -28, 0.0, 0.0),
                                          child: Text(
                                            // '9812345678',
                                            '${allFavoriteRestaurants[index]['contact']}',

                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: activeTextColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: ListTile(
                                        contentPadding: EdgeInsets.all(0),
                                        leading: Wrap(
                                          children: [
                                            Icon(Icons.star),
                                            Icon(Icons.star),
                                            Icon(Icons.star),
                                            Icon(Icons.star_half),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        leading: const Icon(Icons.message),
                                        contentPadding: const EdgeInsets.all(0),
                                        title: Transform(
                                          transform: Matrix4.translationValues(
                                              -28, 0.0, 0.0),
                                          child: const Text(
                                            'NA',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    color: Colors.transparent,
                    height: 30,
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
