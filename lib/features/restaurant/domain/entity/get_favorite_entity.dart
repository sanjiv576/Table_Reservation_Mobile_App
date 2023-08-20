import 'package:equatable/equatable.dart';

class GetFavoriteEntity extends Equatable {
  final String? id;
  final String reestaurantName;
  final String ownerName;
  final String location;
  final String picture;
  final String contact;

  const GetFavoriteEntity({
    this.id,
    required this.reestaurantName,
    required this.ownerName,
    required this.location,
    required this.picture,
    required this.contact,
  });

  factory GetFavoriteEntity.fromJson(Map<String, dynamic> json) {
    return GetFavoriteEntity(
      // id: json['id'] ?? 'NA',
      reestaurantName: json['restaurantName'],
      ownerName: json['ownerName'],
      location: json['location'],
      picture: json['picture'],
      contact: json['contact'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        reestaurantName,
        ownerName,
        location,
        picture,
        contact,
      ];
}
