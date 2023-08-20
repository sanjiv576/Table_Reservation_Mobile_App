import 'dart:async';
import 'dart:core';

import 'package:all_sensors2/all_sensors2.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../config/themes/constant.dart';
import '../../../../core/common/provider/is_dark_theme.dart';
import '../../../../core/common/widget/snackbar_messages.dart';
import '../../../../core/utils/sensors/SwapTheme.dart';
import '../../../../core/utils/sensors/take_screenshote.dart';
import '../../../auth/presentation/state/auth_state.dart';
import '../../../auth/presentation/viewmodel/auth_view_model.dart';
import '../../../restaurant/domain/entity/restaurant_entity.dart';
import '../../../restaurant/presentation/state/restaurant_state.dart';
import '../../../restaurant/presentation/viewmodel/restaurant_viewmodel.dart';
import '../widget/horizontal_restaurants_view.dart';
import '../widget/vertical_restauratns_view.dart';

final selectedSearchOptionProvider = StateProvider<String>((ref) => 'Location');

class CustomerDashboardView extends ConsumerStatefulWidget {
  const CustomerDashboardView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerDashboardViewState();
}

class _CustomerDashboardViewState extends ConsumerState<CustomerDashboardView> {
  SizedBox gap = const SizedBox(height: 10);

  final _searchController = TextEditingController();

  final ScreenshotController _screenshotController = ScreenshotController();

  bool _isObjectNear = false;

  final int _limitDistance = 4;

  final List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

  late TakeScreenShot _takeScreenShot;
  late bool isDark;
  int counter = 0;
  RestaurantState? restaurantState;

  List<RestaurantEntity> _filteredRestaurants = [];

  bool _isInitializeSearching = false;

  void _takeScreenshotFromPromixity() {
    _takeScreenShot = TakeScreenShot(_screenshotController);
    _streamSubscriptions.add(proximityEvents!.listen((ProximityEvent event) {
      // condition for screenshot
      if (event.proximity <= _limitDistance) {
        // allow to screen shot
        if (!_isObjectNear) {
          _isObjectNear = true;
          // start timing upto 3 seconds, if the user holds then take screenshot
          _takeScreenShot.startTimerAndTakeScreenshot();
        }
      } else {
        _isObjectNear = false;
        // stop timer
        TakeScreenShot.cancelTimer();
      }
    }));
  }

  void _startGyroscopeSensor() {
    gyroscopeEvents!.listen((event) {
      if (event.x > 1) {
        // print('Crossed x range');
        counter++;
        if (counter > 2) {
          // swap the dark/light mode
          if (isDark) {
            ref.watch(isDarkThemeProvider.notifier).updateTheme(false);

            setState(() {
              isDark = false;
            });
          } else {
            ref.watch(isDarkThemeProvider.notifier).updateTheme(true);
            setState(() {
              isDark = true;
            });
          }

          showSnackbarMsg(
              context: context,
              targetTitle: isDark ? 'Dark on!' : 'Light on!',
              targetMessage: isDark
                  ? 'Dark mode is turned on.'
                  : 'Light mode is turned on.',
              type: ContentType.success);

          counter = 0;

          _loadData();
        }
      }
    });
  }

  void _swapDarkTheme() {
    gyroscopeEvents!.listen((event) {
      setState(() {
        isDark = SwapThem.turnDarkMode(isDark: isDark, x: event.x);
      });

      ref.watch(isDarkThemeProvider.notifier).updateTheme(isDark);

      showSnackbarMsg(
          context: context,
          targetTitle: isDark ? 'Dark on!' : 'Light on!',
          targetMessage:
              isDark ? 'Dark mode is turned on.' : 'Light mode is turned on.',
          type: ContentType.success);
    });
  }

  Future<void> _loadData() async {
    setState(() async {
      restaurantState = await ref.watch(restaurantViewModelProvider);
    });

    // ignore: use_build_context_synchronously
    showSnackbarMsg(
        context: context,
        targetTitle: 'Refresh',
        targetMessage: 'Refreshing the screen.',
        type: ContentType.success);
  }

  @override
  void initState() {
    isDark = ref.read(isDarkThemeProvider);

    _takeScreenshotFromPromixity();

    _startGyroscopeSensor();
    // _swapDarkTheme();

    _searchController.addListener(_onSearching);

    super.initState();
  }

  void _onSearching() {
    final searchQuery = _searchController.text.trim().toLowerCase();
    if (searchQuery.isEmpty) {
      setState(() {
        _filteredRestaurants = restaurantState!.allRestaurants!;
      });
    } else {
      setState(() {
        _isInitializeSearching = true;
        // Filter restaurants by name or location
        _filteredRestaurants = restaurantState!.allRestaurants!
            .where((restaurant) =>
                restaurant.name.toLowerCase().contains(searchQuery) ||
                restaurant.location.toLowerCase().contains(searchQuery))
            .toList();
      });
    }
  }

  @override
  void dispose() {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    restaurantState = ref.watch(restaurantViewModelProvider);
    return Scaffold(
      body: Screenshot(
        controller: _screenshotController,
        child: SafeArea(
            child: RefreshIndicator(
          onRefresh: _loadData,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF631FF5),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Hi, ${AuthState.userEntity!.fullName.split(' ')[0]}!',
                              style: kBoldPoppinsTextStyle.copyWith(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Switch(
                                value: isDark,
                                onChanged: (value) {
                                  setState(() {
                                    isDark = value;
                                    ref
                                        .watch(isDarkThemeProvider.notifier)
                                        .updateTheme(value);
                                  });
                                }),
                            const Spacer(),
                            // IconButton(
                            //   onPressed: () {
                            //     Navigator.pushNamed(
                            //         context, AppRoute.navigationRoute);
                            //   },
                            //   icon: const Icon(Icons.restaurant_menu),
                            //   color: Colors.white,
                            //   iconSize: 25,
                            // ),
                            // IconButton(
                            //   onPressed: () {},
                            //   icon: const Icon(Icons.notifications_active),
                            //   color: Colors.white,
                            //   iconSize: 25,
                            // ),
                            IconButton(
                              onPressed: () {
                                ref
                                    .watch(authViewModelProvider.notifier)
                                    .logout(context: context);
                                // Navigator.pushNamedAndRemoveUntil(context,
                                //     AppRoute.signInRoute, (route) => false);
                              },
                              icon: const Icon(Icons.logout),
                              color: Colors.white,
                              iconSize: 25,
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: _searchController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              showSnackbarMsg(
                                  context: context,
                                  targetTitle: 'Error',
                                  targetMessage: 'Search is empty',
                                  type: ContentType.failure);
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintText:
                                  'Search for restaurants by its name or location',
                              hintStyle: const TextStyle(
                                  color: Colors.black,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14),
                              prefixIcon: Icon(
                                Icons.search,
                                color: isDark ? Colors.white : Colors.black,
                                size: 35,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8))),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              gap,
              // FOr horizontal
              if (restaurantState!.isLoading) ...{
                const Center(
                  child: CircularProgressIndicator(),
                ),
              } else if (restaurantState!.error != null) ...{
                Expanded(
                    child: Center(
                  child: Text(
                    'Error: ${restaurantState!.error!}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ))
              } else if (_isInitializeSearching
                  ? _filteredRestaurants.isEmpty
                  : restaurantState!.allRestaurants!.isEmpty) ...{
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Text('No Restaurants Found',
                        style: kTextStyle.copyWith(
                            fontSize: 20, color: Colors.white)),
                  ),
                )
              } else if (restaurantState!.allRestaurants != []) ...{
                // FOr horizontal
                HorizontalRestaurantsView(
                    restaurantState: restaurantState, gap: gap),
                // },
                Expanded(
                  flex: 3,
                  child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Popular',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          ),
                          gap,

                          // For vertical Restaurants
                          VerticalRestaurantsView(_filteredRestaurants,
                              _isInitializeSearching, restaurantState!, isDark),
                        ],
                      )),
                ),
              },
            ],
          ),
        )),
      ),
    );
  }
}
