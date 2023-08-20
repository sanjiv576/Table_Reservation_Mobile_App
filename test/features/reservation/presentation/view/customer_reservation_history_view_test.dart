import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:table_reservation_mobile_app/config/router/app_route.dart';
import 'package:table_reservation_mobile_app/features/reservation/domain/entity/reservation_entity.dart';
import 'package:table_reservation_mobile_app/features/reservation/domain/use_case/reservation_use_case.dart';
import 'package:table_reservation_mobile_app/features/reservation/presentation/viewmodel/reservation_viewmodel.dart';

import '../../../../../test_data/reservations_entity_test.dart';
import 'customer_reservation_history_view_test.mocks.dart';

class CustomBindings extends AutomatedTestWidgetsFlutterBinding {
  @override
  bool get overrideHttpClient => false;
}

@GenerateNiceMocks([
  MockSpec<ReservationUseCase>(),
])
void main() {
  CustomBindings();
  TestWidgetsFlutterBinding.ensureInitialized();
  late ReservationUseCase mockReservationUseCase;
  late List<ReservationEntity> reservationList;

  setUp(() async {
    mockReservationUseCase = MockReservationUseCase();
    reservationList = await getReservationsTest();
  });
  testWidgets('view customer reservation history', (tester) async {
    when(mockReservationUseCase.getAllReservations()).thenAnswer(
      (_) => Future.value(
        Right(reservationList),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          reservationViewModelProvider.overrideWith(
            (ref) => ReservationViewModel(
              mockReservationUseCase,
            ),
          ),
        ],
        child: MaterialApp(
          initialRoute: AppRoute.customerReservationHistoryRoute,
          routes: AppRoute.getApplicaionRoute(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Reservations'), findsNWidgets(0));

    await tester.pump();
    expect(find.byType(GestureDetector).at(0), findsOneWidget);
  });
}
