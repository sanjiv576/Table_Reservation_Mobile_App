import 'package:equatable/equatable.dart';

class FavoriteEntity extends Equatable {
  final String? favoriteId;
  final String userId;
  final String restaurantName;
  final String userName;

  const FavoriteEntity({
    this.favoriteId,
    required this.userId,
    required this.restaurantName,
    required this.userName,
  });

  factory FavoriteEntity.fromJson(Map<String, dynamic> json) {
    return FavoriteEntity(
        userId: json['userId'],
        restaurantName: json['restaurantName'],
        userName: json['userName'],
        favoriteId: json['id']);
  }

  @override
  List<Object?> get props => [favoriteId, userId, restaurantName, userName];

  @override
  String toString() {
    return 'Favoirte id : $favoriteId, userId : $userId, restaurantName : $restaurantName, userName : $userName';
  }
}
