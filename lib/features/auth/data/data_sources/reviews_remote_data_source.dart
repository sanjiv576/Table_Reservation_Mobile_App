import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_reservation_mobile_app/features/auth/presentation/state/review_state.dart';

import '../../../../config/constants/api_endpoints.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/network/remote/http_services.dart';
import '../../../../core/shared_prefs/user_shared_prefs.dart';
import '../../domain/entity/review_entity.dart';

final reviewsRemoteDataSourceProvider = Provider((ref) {
  return ReviewsRemoteDataSource(
    ref.read(httpServicesProvider),
    ref.read(userSharedPrefsProvider),
  );
});

class ReviewsRemoteDataSource {
  final Dio _dio;
  final UserSharedPrefs _userSharedPrefs;

  ReviewsRemoteDataSource(this._dio, this._userSharedPrefs);

  // get reviews of a restaurant
  Future<Either<Failure, List<ReviewEntity>>> getSingleRestaurantReviews(
      String restaurantId) async {
    try {
      String? token;

      var data = await _userSharedPrefs.getUserToken();
      data.fold((l) => token = null, (r) => token = r!);

      Response response = await _dio.get(
          '${ApiEndpoints.getAllReviewsByRestaurantId}$restaurantId/reviews',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200) {
        // convert JSON object into Entity list and return
        List<ReviewEntity> reviewEntityList = (response.data as List)
            .map((e) => ReviewEntity.fromJson(e))
            .toList();

        return Right(reviewEntityList);
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

  Future<Either<Failure, ReviewEntity>> addReview(
      ReviewEntity reivew, String restaurantId) async {
    try {
      String? token;
      var data = await _userSharedPrefs.getUserToken();
      data.fold((l) => token = null, (r) => token = r!);

      Response response = await _dio.post(
        '${ApiEndpoints.createAReviewByRestaurantId}$restaurantId/reviews',
        data: {'text': reivew.text},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 201) {
        // convert Json object into Entity
        ReviewEntity reviewEntity = ReviewEntity.fromJson(response.data);

        ReviewState.singleReview = reviewEntity;

        // return converted entity
        return Right(reviewEntity);
      } else {
        return Left(
          Failure(
            error: response.data['error'].toString(),
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
            error: e.message.toString(),
            statusCode: e.response?.statusCode.toString() ?? '0'),
      );
    }
  }
}
