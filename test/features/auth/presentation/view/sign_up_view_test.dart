import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:table_reservation_mobile_app/config/router/app_route.dart';
import 'package:table_reservation_mobile_app/features/auth/domain/entity/user_entity.dart';
import 'package:table_reservation_mobile_app/features/auth/domain/use_case/auth_usecase.dart';
import 'package:table_reservation_mobile_app/features/auth/presentation/viewmodel/auth_view_model.dart';

import '../../../../unit_test/auth_unit_test.mocks.dart';

class CustomBindings extends AutomatedTestWidgetsFlutterBinding {
  @override
  bool get overrideHttpClient => false;
}

void main() {
  CustomBindings();
  TestWidgetsFlutterBinding.ensureInitialized();
  late AuthUseCase mockAuthUseCase;
  UserEntity user = const UserEntity(
    fullName: 'Sanjiv Shrestha',
    contact: '9834545656',
    role: 'restaurant owner',
    email: 'shrestha@gmail.com',
    username: 'sanjiv',
    password: 'sanjiv123',
    picture: 'image.png',
    restaurantId: '1'
  );

  setUpAll(() {
    mockAuthUseCase = MockAuthUseCase();
  });

  testWidgets('Register user account with valid details', (tester) async {
    when(mockAuthUseCase.registerUser(user))
        .thenAnswer((_) async => const Right(true));

    await tester.pumpWidget(ProviderScope(
        overrides: [
          authViewModelProvider
              .overrideWith((ref) => AuthViewModel(mockAuthUseCase))
        ],
        child: MaterialApp(
          initialRoute: AppRoute.signUpRoute,
          routes: AppRoute.getApplicaionRoute(),
        )));

    await tester.pumpAndSettle();

    // find and insert values in the textformfields
    // 0. fullname
    await tester.enterText(find.byType(TextFormField).at(0), 'Sanjiv Shrestha');
    // 1. contact
    await tester.enterText(find.byType(TextFormField).at(1), '9834545656');

    // 0. role  dropdown --> Restaurant Owner  , Customer
    Finder dropdownFinder = find.byType(DropdownButtonFormField<String>);
    await tester.ensureVisible(dropdownFinder);
    await tester.tap(dropdownFinder);
    // hold to display options
    await tester.pumpAndSettle();

    // tap on 'restaurant owner' option
    await tester.tap(find.byType(DropdownMenuItem<String>).at(0));
    // close dropdown
    await tester.pumpAndSettle();

    // 2. username
    await tester.enterText(find.byType(TextFormField).at(2), 'sanjiv');
    // 3. email
    await tester.enterText(
        find.byType(TextFormField).at(3), 'shrestha@gmail.com');
    // 4. password
    await tester.enterText(find.byType(TextFormField).at(4), 'sanjiv123');
    // 5 .confirm passowrd
    await tester.enterText(find.byType(TextFormField).at(5), 'sanjiv123');


  });
}
