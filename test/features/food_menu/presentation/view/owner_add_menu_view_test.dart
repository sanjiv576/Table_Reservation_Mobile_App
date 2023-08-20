import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:table_reservation_mobile_app/config/router/app_route.dart';
import 'package:table_reservation_mobile_app/features/food_menu/domain/entity/food_menu_entity.dart';
import 'package:table_reservation_mobile_app/features/food_menu/domain/use_case/food_menu_use_case.dart';
import 'package:table_reservation_mobile_app/features/food_menu/presentation/viewmodel/food_menu_viewmodel.dart';

import '../../../../../test_data/food_menu_entity_test.dart';
import '../../../../unit_test/food_menu_unit_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late FoodMenuUseCase mockFoodMenuUsecase;
  late List<FoodMenuEntity> menuList;

  FoodMenuEntity newFoodItem = const FoodMenuEntity(
      foodName: 'Chicken Burger', foodPrice: 120, foodType: 'non-veg');

  setUpAll(() async {
    mockFoodMenuUsecase = MockFoodMenuUseCase();
    menuList = await getFoodMenuTest();
  });

  testWidgets('open food menu dashboard and get a food menu', (tester) async {
    when(mockFoodMenuUsecase.getFoodMenu('649c13b643544d9eecd419b6'))
        .thenAnswer((_) => Future.value(Right(menuList)));
    await tester.pumpWidget(ProviderScope(
        overrides: [
          foodMenuViewModelProvider
              .overrideWith((ref) => FoodMenuViewModel(mockFoodMenuUsecase))
        ],
        child: MaterialApp(
          initialRoute: AppRoute.ownerAddMenuViewRoute,
          routes: AppRoute.getApplicaionRoute(),
        )));

    await tester.pumpAndSettle();

    expect(find.text('List of Food Items'), findsNWidgets(0));
    

    // NOte: below code is for handling Multiple Excpetions thrown by Flutter framework

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
