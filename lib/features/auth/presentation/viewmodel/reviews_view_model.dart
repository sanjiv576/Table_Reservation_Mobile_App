import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_reservation_mobile_app/features/restaurant/domain/entity/restaurant_entity.dart';
import 'package:table_reservation_mobile_app/features/restaurant/presentation/state/restaurant_state.dart';

import '../../domain/use_case/reviews_usecase.dart';
import '../state/review_state.dart';

final reviewsViewModelProvider =
    StateNotifierProvider<ReviewsViewModel, ReviewState>(
  (ref) => ReviewsViewModel(
    ref.read(reviewsUseCaseProvider),
  ),
);

class ReviewsViewModel extends StateNotifier<ReviewState> {
  final ReviewsUseCase _reviewsUseCase;

  ReviewsViewModel(this._reviewsUseCase) : super(ReviewState.initial()) {
    String targetedRestaurantId = RestaurantState.restaurantId!;

    getSingleRestaurantReviews(restaurantId: targetedRestaurantId);
  }

// get reviews of a restaurant
  Future<void> getSingleRestaurantReviews(
      {required String restaurantId}) async {
    state = state.copyWith(isLoading: true);
    var data = await _reviewsUseCase.getSingleRestaurantReviews(restaurantId);
    data.fold(
      (l) {
        state = state.copyWith(isLoading: false, error: l.error);
      },
      (reviews) {
        state =
            state.copyWith(isLoading: false, error: null, allReviews: reviews);
      },
    );
  }

  // add review
  Future<void> addReview(
      {required review, required RestaurantEntity restaurant}) async {
    state = state.copyWith(isLoading: true);
    var data =
        await _reviewsUseCase.addReview(review, restaurant.restaurantId!);
    data.fold(
      (failed) {
        state = state.copyWith(isLoading: false, error: failed.error);
      },
      (addedReview) {
        // add review at the top of the list
        state.allReviews.insert(0, addedReview);

        state = state.copyWith(isLoading: false, error: null);
      },
    );
  }
}
