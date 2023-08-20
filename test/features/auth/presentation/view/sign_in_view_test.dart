import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:table_reservation_mobile_app/config/router/app_route.dart';
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
  late bool isLogin;

  setUpAll(() {
    mockAuthUseCase = MockAuthUseCase();
    isLogin = true;
  });

  testWidgets('Login with valid user\'s username and password', (tester) async {
    when(mockAuthUseCase.loginUser('sanjiv', 'sanjiv123'))
        .thenAnswer((_) async => Right(isLogin));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authViewModelProvider
              .overrideWith((ref) => AuthViewModel(mockAuthUseCase)),
        ],
        child: MaterialApp(
          initialRoute: AppRoute.signInRoute,
          routes: AppRoute.getApplicaionRoute(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // find textformfields and insert values
    await tester.enterText(find.byType(TextFormField).at(0), 'sanjiv');
    await tester.enterText(find.byType(TextFormField).at(1), 'sanjiv123');

    // find and tap on the button
    await tester.tap(find.widgetWithText(ElevatedButton, 'SIGN IN'));

    // Note: below code is for handling Multiple Excpetions thrown by Flutter framework

    // wait for the next frame to process the exceptions
    await tester.pump();

    // handle and acknowledge all exceptions
    dynamic exception;
    while ((exception = tester.takeException()) != null) {
      // Handle or assert on each exception if needed
      print('Caught exception: $exception');
    }

    expect(find.text('Restaurant'), findsNWidgets(0));
  });
}
