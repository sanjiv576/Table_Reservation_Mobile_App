import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:table_reservation_mobile_app/config/router/app_route.dart';
import 'package:table_reservation_mobile_app/features/restaurant/domain/entity/restaurant_entity.dart';
import 'package:table_reservation_mobile_app/features/restaurant/domain/use_case/restaurant_use_case.dart';
import 'package:table_reservation_mobile_app/features/restaurant/presentation/viewmodel/restaurant_viewmodel.dart';

import '../../../../../test_data/restaurants_entity_test.dart';
import 'customer_dashboard_view_test.mocks.dart';

class CustomBindings extends AutomatedTestWidgetsFlutterBinding {
  @override
  bool get overrideHttpClient => false;
}

@GenerateNiceMocks([MockSpec<RestaurantUseCase>()])
void main() {
  CustomBindings();
  TestWidgetsFlutterBinding.ensureInitialized();
  late RestaurantUseCase mockRestaurantUseCase;
  late List<RestaurantEntity> restaurantList;

  setUp(() async {
    mockRestaurantUseCase = MockRestaurantUseCase();
    restaurantList = await getAllRestaurantsTest();
  });

  testWidgets('get all restaurants', (tester) async {
    when(mockRestaurantUseCase.getAllRestaurants()).thenAnswer(
      (_) => Future.value(
        Right(restaurantList),
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
          initialRoute: AppRoute.customerDashboardRoute,
          routes: AppRoute.getApplicaionRoute(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Restaurant'), findsNWidgets(0));

    // Note: below code is for handling Multiple Excpetions thrown by Flutter framework
    // wait for the next frame to process the exceptions
    await tester.pump();

    // handle and acknowledge all exceptions
    dynamic exception;
    while ((exception = tester.takeException()) != null) {
      // Handle or assert on each exception if needed
      print('Caught exception: $exception');
    }
  });
}
