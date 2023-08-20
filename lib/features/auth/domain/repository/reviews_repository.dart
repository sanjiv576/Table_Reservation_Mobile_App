import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../../data/repository/reviews_remote_repository.dart';
import '../entity/review_entity.dart';

final reviewsRepositoryProvider = Provider<IReviewsRepository>(
  (ref) => ref.read(reviewsRemoteRepositoryProvider),
);

abstract class IReviewsRepository {
  // get customers' review by owner
  Future<Either<Failure, List<ReviewEntity>>> getSingleRestaurantReviews(
      String restaurantId);

  // add review
  Future<Either<Failure, ReviewEntity>> addReview(
      ReviewEntity reivew, String restaurantId);
}
