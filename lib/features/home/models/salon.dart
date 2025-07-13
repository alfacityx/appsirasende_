import '../../salon_detail/models/salon_detail.dart';

class Salon {
  final String id;
  final String name;
  final String address;
  final String imageUrl;
  final double rating;
  final double distance;
  final List<String> categories;
  final bool isFavorite;

  const Salon({
    required this.id,
    required this.name,
    required this.address,
    required this.imageUrl,
    required this.rating,
    required this.distance,
    required this.categories,
    this.isFavorite = false,
  });

  Salon copyWith({
    String? id,
    String? name,
    String? address,
    String? imageUrl,
    double? rating,
    double? distance,
    List<String>? categories,
    bool? isFavorite,
  }) {
    return Salon(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      distance: distance ?? this.distance,
      categories: categories ?? this.categories,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
} 