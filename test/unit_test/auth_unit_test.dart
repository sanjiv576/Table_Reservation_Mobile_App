import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:table_reservation_mobile_app/core/failure/failure.dart';
import 'package:table_reservation_mobile_app/features/auth/domain/entity/user_entity.dart';
import 'package:table_reservation_mobile_app/features/auth/domain/use_case/auth_usecase.dart';
import 'package:table_reservation_mobile_app/features/auth/presentation/viewmodel/auth_view_model.dart';

import 'auth_unit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthUseCase>(),
  MockSpec<BuildContext>(),
])
void main() {
  // acutal classes
  late AuthUseCase mockAuthUseCase;
  late BuildContext mockBuildContext;

  late ProviderContainer container;

  setUpAll(() {
    mockAuthUseCase = MockAuthUseCase();
    mockBuildContext = MockBuildContext();

    container = ProviderContainer(overrides: [
      authViewModelProvider.overrideWith(
        (ref) => AuthViewModel(mockAuthUseCase),
      ),
    ]);
  });

  group('Test cases for login', () {
    test('should login with valid user accrount credentials', () async {
      // creat Stub
      when(mockAuthUseCase.loginUser('sanjiv', 'sanjiv123'))
          .thenAnswer((_) => Future.value(const Right(true)));

      // now, call the loginUser function
      await container.read(authViewModelProvider.notifier).loginUser(
            username: 'sanjiv',
            password: 'sanjiv123',
            context: mockBuildContext,
          );

      final authState = container.read(authViewModelProvider);
      expect(authState.error, isNull);
    });

    test('should throw error with invalid account credentials', () async {
      when(mockAuthUseCase.loginUser('sanjiv', 'sanjiv1212'))
          .thenAnswer((_) => Future.value(Left(
                Failure(error: 'invalid user credentials'),
              )));

      // call above loginUser function
      await container.read(authViewModelProvider.notifier).loginUser(
            username: 'sanjiv',
            password: 'sanjiv1212',
            context: mockBuildContext,
          );

      final authState = container.read(authViewModelProvider);

      // verify using a matcher
      expect(authState.error, 'invalid user credentials');
    });
  });

  group('Test cases for sign up', () {
    test('should signup successfully with null error', () async {
      // user details
      UserEntity newUser = UserEntity(
        fullName: 'Sanjiv Shrestha',
        contact: '9823454545',
        role: 'customer',
        email: 'shrestha@gmail.com',
        username: 'sanjiv',
        password: 'sanjiv123',
      );

      // create stub
      when(mockAuthUseCase.registerUser(newUser))
          .thenAnswer((_) => Future.value(const Right(true)));

      await container
          .read(authViewModelProvider.notifier)
          .registerUser(user: newUser, context: mockBuildContext);

      final authState = container.read(authViewModelProvider);

      expect(authState.error, isNull);
    });

    test('should fail to signup  with error message', () async {
      // user details
      UserEntity newUser = UserEntity(
        fullName: 'Sanjiv Shrestha',
        contact: '9823454545',
        role: 'customer',
        email: 'shrestha@gmail.com',
        username: 'sanjiv',
        password: 'sanjiv123',
      );

      // create stub
      when(mockAuthUseCase.registerUser(newUser))
          .thenAnswer((_) => Future.value(Left(Failure(error: 'error'))));

      await container
          .read(authViewModelProvider.notifier)
          .registerUser(user: newUser, context: mockBuildContext);

      final authState = container.read(authViewModelProvider);

      expect(authState.error, isNotNull);
    });
  });

  tearDownAll(() => container.dispose());
}
