import 'package:flutter/material.dart';
import 'package:table_reservation_mobile_app/features/food_menu/presentation/state/food_menu_state.dart';
import 'package:table_reservation_mobile_app/features/restaurant/presentation/state/restaurant_state.dart';

import '../../../../config/constants/api_endpoints.dart';
import '../../../../config/router/app_route.dart';
import '../../../restaurant/domain/entity/restaurant_entity.dart';

class VerticalRestaurantsView extends StatelessWidget {
  final bool _isInitializeSearching;
  final List<RestaurantEntity> _filteredRestaurants;

  final RestaurantState _restaurantState;
  final bool _isDark;

  const VerticalRestaurantsView(this._filteredRestaurants,
      this._isInitializeSearching, this._restaurantState, this._isDark,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        // shrinkWrap: true,
        itemCount:
            // _restaurantState!.allRestaurants!.length,
            _isInitializeSearching
                ? _filteredRestaurants.length
                : _restaurantState.allRestaurants!.length,
        // itemCount: 3,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              AppRoute.restaurantRoute,
              arguments:
                  // _restaurantState!.allRestaurants![index],
                  _isInitializeSearching
                      ? _filteredRestaurants[index]
                      : _restaurantState.allRestaurants![index],
            ),
            onDoubleTap: () {
              // store restaurant id in the state ==> futher used in Food order
              RestaurantState.restaurantId = _isInitializeSearching
                  ? _filteredRestaurants[index].restaurantId
                  : _restaurantState.allRestaurants![index].restaurantId;

              // store food menu in the state ==> futher used in Food Order

              FoodMenuState.restaurantFoodMenu = _isInitializeSearching
                  ? _filteredRestaurants[index].foodMenu
                  : _restaurantState.allRestaurants![index].foodMenu;

              Navigator.pushNamed(context, AppRoute.customerReservationRoute,
                  arguments: {
                    'reservation': null,
                    'restaurant': _isInitializeSearching
                        ? _filteredRestaurants[index]
                        : _restaurantState.allRestaurants![index],
                  });
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 12,
              shadowColor: const Color.fromARGB(255, 211, 199, 199),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(
                          // 'https://media.istockphoto.com/id/1212417063/photo/table-full-of-food-for-family-dinner.jpg?s=612x612&w=0&k=20&c=VQw95DggeCDG_NHy5wHcg8BV7MhQmDDtLr-qxs4suiY=',
                          // '${ApiEndpoints.imageUrl}${_restaurantState!.allRestaurants![index].picture}',
                          _isInitializeSearching
                              ? '${ApiEndpoints.imageUrl}${_filteredRestaurants[index].picture}'
                              : '${ApiEndpoints.imageUrl}${_restaurantState.allRestaurants![index].picture}',
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
                            // 'ABC restaurant',
                            _isInitializeSearching
                                ? _filteredRestaurants[index].name.toString()
                                : _restaurantState.allRestaurants![index].name
                                    .toString(),

                            style: TextStyle(
                                color: _isDark ? Colors.white : Colors.black,
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
                                      _isInitializeSearching
                                          ? _filteredRestaurants[index]
                                              .location
                                              .toString()
                                          : _restaurantState
                                              .allRestaurants![index].location
                                              .toString(),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
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

                                      _isInitializeSearching
                                          ? _filteredRestaurants[index].contact
                                          : _restaurantState
                                              .allRestaurants![index].contact
                                              .toString(),

                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
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
                                    child: Text(
                                      // '237 Reviews',
                                      _isInitializeSearching
                                          ? '${_filteredRestaurants[index].reviews!.length} Reviews'
                                          : '${_restaurantState.allRestaurants![index].reviews!.length} Reviews',

                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
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
    );
  }
}
