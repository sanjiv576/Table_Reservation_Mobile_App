import '../../domain/entity/review_entity.dart';

class ReviewState {
  final bool isLoading;
  final String? error;
  final List<ReviewEntity> allReviews;

  ReviewState({
    required this.isLoading,
    this.error,
    required this.allReviews,
  });

  static ReviewEntity? singleReview;

  // initial values
  factory ReviewState.initial() => ReviewState(
        isLoading: false,
        error: null,
        allReviews: [],
      );

  ReviewState copyWith({
    bool? isLoading,
    String? error,
    List<ReviewEntity>? allReviews,
  }) {
    return ReviewState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      allReviews: allReviews ?? this.allReviews,
    );
  }
}
