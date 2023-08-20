import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:table_reservation_mobile_app/config/router/app_route.dart';
import 'package:table_reservation_mobile_app/features/restaurant/domain/use_case/restaurant_use_case.dart';
import 'package:table_reservation_mobile_app/features/restaurant/presentation/viewmodel/restaurant_viewmodel.dart';

import '../../../customer_dashboard/presentation/view/customer_dashboard_view_test.mocks.dart';

class CustomBindings extends AutomatedTestWidgetsFlutterBinding {
  @override
  bool get overrideHttpClient => false;
}

@GenerateNiceMocks([
  MockSpec<RestaurantUseCase>(),
])
void main() {
  CustomBindings();
  TestWidgetsFlutterBinding.ensureInitialized();
  late RestaurantUseCase mockRestaurantUseCase;
  late bool foundFavoriteList;

  setUp(() async {
    mockRestaurantUseCase = MockRestaurantUseCase();
    // favoriteList = await getAllFavoriteRestaurantsTest();
    foundFavoriteList = true;
  });
  testWidgets('get the favorite restaurants', (tester) async {
    when(mockRestaurantUseCase.getAllFavoriteRestaurants()).thenAnswer(
      (_) => Future.value(
        Right(foundFavoriteList),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          restaurantViewModelProvider.overrideWith(
            (ref) => RestaurantViewModel(
              mockRestaurantUseCase,
            ),
          ),
        ],
        child: MaterialApp(
          initialRoute: AppRoute.customerFavoriteRoute,
          routes: AppRoute.getApplicaionRoute(),
        ),
      ),
    );

    await tester.pumpAndSettle();
  });
}
