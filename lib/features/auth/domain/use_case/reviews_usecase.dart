import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../entity/review_entity.dart';
import '../repository/reviews_repository.dart';

final reviewsUseCaseProvider =
    Provider((ref) => ReviewsUseCase(ref.read(reviewsRepositoryProvider)));

class ReviewsUseCase {
  final IReviewsRepository _iReviewsRepository;

  ReviewsUseCase(this._iReviewsRepository);

  // get single restaurant reviews
  Future<Either<Failure, List<ReviewEntity>>> getSingleRestaurantReviews(
      String restaurantId) {
    return _iReviewsRepository.getSingleRestaurantReviews(restaurantId);
  }

  // add review
  Future<Either<Failure, ReviewEntity>> addReview(
      ReviewEntity reivew, String restaurantId) {
    return _iReviewsRepository.addReview(reivew, restaurantId);
  }
}
