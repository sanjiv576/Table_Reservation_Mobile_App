import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String? reviewId;
  final String text;
  final int rating;
  final String userName;
  final String userPicture;
  final String userId;
  final String restaurantId;
  final String? restaurantName;

  const ReviewEntity({
    this.reviewId,
    required this.text,
    required this.rating,
    required this.userName,
    required this.userId,
    required this.userPicture,
    required this.restaurantId,
    this.restaurantName,
  });

  factory ReviewEntity.fromJson(Map<String, dynamic> json) {
    return ReviewEntity(
      text: json['text'],
      rating: json['rating'],
      userName: json['userName'],
      userId: json['userId'],
      restaurantId: json['restaurantId'],
      userPicture: json['userPicture'],
    );
  }

  @override
  List<Object?> get props => [
        reviewId,
        text,
        rating,
        userName,
        userId,
        userPicture,
        restaurantId,
        restaurantName,
      ];

  @override
  String toString() {
    return 'Review text : $text user name : $userName';
  }
}
