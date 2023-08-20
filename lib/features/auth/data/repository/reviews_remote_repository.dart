import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../../domain/entity/review_entity.dart';
import '../../domain/repository/reviews_repository.dart';
import '../data_sources/reviews_remote_data_source.dart';

final reviewsRemoteRepositoryProvider = Provider<IReviewsRepository>(
  (ref) => ReviewsRemoteRepository(
    ref.read(reviewsRemoteDataSourceProvider),
  ),
);

class ReviewsRemoteRepository implements IReviewsRepository {
  final ReviewsRemoteDataSource _reviewsRemoteDataSource;

  ReviewsRemoteRepository(this._reviewsRemoteDataSource);

  @override
  Future<Either<Failure, List<ReviewEntity>>> getSingleRestaurantReviews(
      String restaurantId) {
    return _reviewsRemoteDataSource.getSingleRestaurantReviews(restaurantId);
  }

  @override
  Future<Either<Failure, ReviewEntity>> addReview(
      ReviewEntity reivew, String restaurantId) {
    return _reviewsRemoteDataSource.addReview(reivew, restaurantId);
  }
}
