import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/themes/app_color_constant.dart';
import '../../../../core/common/provider/is_dark_theme.dart';
import '../../../auth/presentation/view/customer_profile_view.dart';
import '../../../restaurant/presentation/view/customer_favorite_view.dart';
import '../../../reservation/presentation/view/customer_reservation_history_view.dart';
import 'customer_dashboard_view.dart';

final selectedIndexProvider = StateProvider<int>((ref) => 2);

class BottomNavigationView extends ConsumerStatefulWidget {
  const BottomNavigationView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BottomNavigationViewState();
}

class _BottomNavigationViewState extends ConsumerState<BottomNavigationView> {
  void _onTapItem(int index) {
    ref.watch(selectedIndexProvider.notifier).state = index;
  }

  final List<Widget> _screens = [
    CustomerReservationHistoryView(),
    const CustomerProfileView(),
    const CustomerDashboardView(),
    const CustomerFavoriteView()
  ];

  late bool isDark;
  @override
  void initState() {
    isDark = ref.read(isDarkThemeProvider);

    super.initState();
  }

  final List<CurvedNavigationBarItem> _navigationIcons = [
    const CurvedNavigationBarItem(
        label: 'Reservation',
        child: Icon(
          Icons.table_bar,
          color: AppColorConstant.navigationIconColor,
        )),
    const CurvedNavigationBarItem(
        label: 'Profile',
        child: Icon(
          Icons.person,
          color: AppColorConstant.navigationIconColor,
        )),
    const CurvedNavigationBarItem(
        label: 'Home',
        child: Icon(
          Icons.home,
          color: AppColorConstant.navigationIconColor,
        )),
    const CurvedNavigationBarItem(
        label: 'Favorite',
        child: Icon(
          Icons.favorite,
          color: AppColorConstant.navigationIconColor,
        )),
  ];

  @override
  Widget build(BuildContext context) {
    // ref.read(reservationApiModelProvider);
    isDark = ref.watch(isDarkThemeProvider);
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          items: _navigationIcons,
          index: ref.watch(selectedIndexProvider),
          onTap: _onTapItem,
          // container background color
          color: isDark ? Colors.black : Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: isDark
              ? AppColorConstant.nightScafoldBackgroundColor
              : AppColorConstant.dayScafoldBackgroundColor,
          animationCurve: Curves.easeInSine,
          animationDuration: const Duration(milliseconds: 300),
        ),
        body: _screens.elementAt(ref.watch(selectedIndexProvider)));
  }
}
