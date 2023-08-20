import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/constants/api_endpoints.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/network/remote/http_services.dart';
import '../../../../core/shared_prefs/user_shared_prefs.dart';
import '../../../auth/presentation/state/auth_state.dart';
import '../../../restaurant/presentation/state/restaurant_state.dart';
import '../../domain/entity/reservation_entity.dart';

final reservationRemoteDataSourceProvider = Provider(
  (ref) => ReservationRemoteDataSource(
    ref.read(httpServicesProvider),
    ref.read(userSharedPrefsProvider),
  ),
);

class ReservationRemoteDataSource {
  final Dio _dio;
  final UserSharedPrefs _userSharedPrefs;

  ReservationRemoteDataSource(this._dio, this._userSharedPrefs);

  // create reservation
  Future<Either<Failure, ReservationEntity>> createReservation(
      ReservationEntity reservation, String restaurantId) async {
    try {
      // get user token
      String? token;
      var data = await _userSharedPrefs.getUserToken();
      data.fold((l) => token = null, (r) => token = r!);

      // set token in header
      Response response =
          await _dio.post(ApiEndpoints.createReservation + restaurantId,
              data: {
                "date": reservation.date,
                "time": reservation.time,
                "numberOfDinners": reservation.numberOfDinners,
                "dinnerPlace": reservation.dinnerPlace,
              },
              options: Options(headers: {
                'Authorization': 'Bearer $token',
              }));

      if (response.statusCode == 201) {
        // convert JSON into Entity
        ReservationEntity reservationEntity =
            ReservationEntity.fromJson(response.data);

        // return reservation entity
        return Right(reservationEntity);
      } else {
        return Left(
          Failure(
            error: response.data['error'],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  // update reservation

  Future<Either<Failure, bool>> updateReservation(
      ReservationEntity reservation, String reservationId) async {
    try {
      // get user token
      String? token;
      var data = await _userSharedPrefs.getUserToken();
      data.fold((l) => token = null, (r) => token = r!);

      // set token in header
      Response response =
          await _dio.put(ApiEndpoints.updateAReservation + reservationId,
              data: {
                "time": reservation.time,
                "date": reservation.date,
                "numberOfDinners": reservation.numberOfDinners,
                "dinnerPlace": reservation.dinnerPlace,
              },
              options: Options(headers: {
                'Authorization': 'Bearer $token',
              }));

      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data['error'],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  // delete reservation
  Future<Either<Failure, bool>> deleteReservation(String reservationId) async {
    try {
      // get user token
      String? token;
      var data = await _userSharedPrefs.getUserToken();
      data.fold((l) => token = null, (r) => token = r!);

      // set token in header
      Response response =
          await _dio.delete(ApiEndpoints.deleteAReservation + reservationId,
              options: Options(headers: {
                'Authorization': 'Bearer $token',
              }));

      if (response.statusCode == 204) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data['error'],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  // get a reservation
  Future<Either<Failure, ReservationEntity>> getAReservation(
      String reservationId) async {
    try {
      // get user token
      String? token;
      var data = await _userSharedPrefs.getUserToken();
      data.fold((l) => token = null, (r) => token = r!);

      // set token in header
      Response response =
          await _dio.get(ApiEndpoints.getAReservation + reservationId,
              options: Options(headers: {
                'Authorization': 'Bearer $token',
              }));

      if (response.statusCode == 200) {
        // convert JSON into Entity
        ReservationEntity reservationEntity =
            ReservationEntity.fromJson(response.data);

        // return reservation entity
        return Right(reservationEntity);
      } else {
        return Left(
          Failure(
            error: response.data['error'],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  // get all reservations
  Future<Either<Failure, List<ReservationEntity>>> getAllReservations() async {
    try {
      // get user token
      String? token;
      var data = await _userSharedPrefs.getUserToken();
      data.fold((l) => token = null, (r) => token = r!);

      // set token in header
      Response? response;
      if (AuthState.userEntity!.role == 'customer') {
        response = await _dio.get(ApiEndpoints.getAllReservationsByCustomer,
            options: Options(headers: {
              'Authorization': 'Bearer $token',
            }));
      } else {
        response = await _dio.get(
            ApiEndpoints.getAllReservationsByOwner +
                RestaurantState.restaurantId!,
            options: Options(headers: {
              'Authorization': 'Bearer $token',
            }));
      }

      if (response.statusCode == 200) {
        // convert JSON into Entity List
        List<ReservationEntity> allReservationsList = (response.data as List)
            .map((e) => ReservationEntity.fromJson(e))
            .toList();

        // return reservation entity
        return Right(allReservationsList);
      } else {
        return Left(
          Failure(
            error: response.data['error'],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }
}
