import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:table_reservation_mobile_app/core/failure/failure.dart';
import 'package:table_reservation_mobile_app/features/food_menu/domain/entity/food_menu_entity.dart';
import 'package:table_reservation_mobile_app/features/food_menu/domain/use_case/food_menu_use_case.dart';
import 'package:table_reservation_mobile_app/features/food_menu/presentation/viewmodel/food_menu_viewmodel.dart';

import '../../test_data/food_menu_entity_test.dart';
import 'food_menu_unit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FoodMenuUseCase>(),
])

// dart run build_runner build --delete-conflicting-outputs
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late FoodMenuUseCase mockFoodMenuUsecase;
  late ProviderContainer container;
  late List<FoodMenuEntity> menuList;

  // initialization of above properties
  setUpAll(() async {
    mockFoodMenuUsecase = MockFoodMenuUseCase();
    menuList = await getFoodMenuTest();

    // make empty call of food menu
    when(mockFoodMenuUsecase.getFoodMenu('649c13b643544d9eecd419b6'))
        .thenAnswer((_) => Future.value(const Right([])));

    container = ProviderContainer(
      overrides: [
        // override the foodMenuUsecase with mock use case
        foodMenuViewModelProvider.overrideWith(
          (ref) => FoodMenuViewModel(mockFoodMenuUsecase),
        ),
      ],
    );
  });

  group('Test cases for Food menu', () {
    test('should get a food menu', () async {
      when(mockFoodMenuUsecase.getFoodMenu('649c13b643544d9eecd419b6'))
          .thenAnswer((_) => Future.value(Right(menuList)));

      //  call above function
      await container
          .read(foodMenuViewModelProvider.notifier)
          .getFoodMenu(restaurantId: '649c13b643544d9eecd419b6');

      final foodMenuState = container.read(foodMenuViewModelProvider);

      // verify the length of menu list is not empty
      expect(foodMenuState.foodMenu, isNotEmpty);
    });

    test('should add food item', () async {
      when(mockFoodMenuUsecase.addFoodItem(menuList[0]))
          .thenAnswer((_) => Future.value(const Right(true)));

      await container
          .read(foodMenuViewModelProvider.notifier)
          .addFoodItem(foodItem: menuList[0]);

      final foodMenuState = container.read(foodMenuViewModelProvider);

      // verify that erro is null
      expect(foodMenuState.error, isNull);
    });

    test('should update a food item', () async {
      when(mockFoodMenuUsecase.updateAFoodItem(
              '649c13b643544d9eecd419b6', menuList[0]))
          .thenAnswer((_) => Future.value(const Right(true)));

      await container.read(foodMenuViewModelProvider.notifier).updateAFoodItem(
          foodItemId: '649c13b643544d9eecd419b6', foodItem: menuList[0]);

      final foodMenuState = container.read(foodMenuViewModelProvider);

      expect(foodMenuState.error, isNull);
    });

    test('should delete a food item', () async {
      when(mockFoodMenuUsecase.deleteAFoodItem(menuList[1]))
          .thenAnswer((_) => Future.value(const Right(true)));

      await container
          .read(foodMenuViewModelProvider.notifier)
          .deleteAFoodItem(foodItem: menuList[1]);

      final foodMenuState = container.read(foodMenuViewModelProvider);

      expect(foodMenuState.error, isNull);
    });

    test('should fail to delete a food item', () async {
      when(mockFoodMenuUsecase.deleteAFoodItem(menuList[1])).thenAnswer(
          (_) => Future.value(Left(Failure(error: 'invalid food item'))));

      await container
          .read(foodMenuViewModelProvider.notifier)
          .deleteAFoodItem(foodItem: menuList[1]);

      final foodMenuState = container.read(foodMenuViewModelProvider);

      expect(foodMenuState.error, 'invalid food item');
    });
  });

  tearDownAll(() => container.dispose());
}
