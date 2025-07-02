import '../../home/models/salon.dart';

class SearchFilters {
  final String selectedCategory;
  final int selectedRating;
  final String selectedDistance;
  final String selectedPriceRange;
  final bool onlyOpenNow;
  final bool onlyPopular;

  const SearchFilters({
    this.selectedCategory = 'All',
    this.selectedRating = 0,
    this.selectedDistance = 'All',
    this.selectedPriceRange = 'All',
    this.onlyOpenNow = false,
    this.onlyPopular = false,
  });

  SearchFilters copyWith({
    String? selectedCategory,
    int? selectedRating,
    String? selectedDistance,
    String? selectedPriceRange,
    bool? onlyOpenNow,
    bool? onlyPopular,
  }) {
    return SearchFilters(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedRating: selectedRating ?? this.selectedRating,
      selectedDistance: selectedDistance ?? this.selectedDistance,
      selectedPriceRange: selectedPriceRange ?? this.selectedPriceRange,
      onlyOpenNow: onlyOpenNow ?? this.onlyOpenNow,
      onlyPopular: onlyPopular ?? this.onlyPopular,
    );
  }

  bool get hasActiveFilters {
    return selectedCategory != 'All' || 
           selectedRating > 0 || 
           selectedDistance != 'All' ||
           selectedPriceRange != 'All' ||
           onlyOpenNow ||
           onlyPopular;
  }

  List<Salon> applyFilters(List<Salon> salons) {
    List<Salon> filteredSalons = List.from(salons);

    // Filter by category
    if (selectedCategory != 'All') {
      filteredSalons = filteredSalons.where((salon) {
        return salon.categories.contains(selectedCategory);
      }).toList();
    }

    // Filter by rating
    if (selectedRating > 0) {
      filteredSalons = filteredSalons.where((salon) {
        return salon.rating >= selectedRating;
      }).toList();
    }

    // Filter by distance
    if (selectedDistance != 'All') {
      filteredSalons = filteredSalons.where((salon) {
        switch (selectedDistance) {
          case '< 1 km':
            return salon.distance < 1.0;
          case '1 - 5 km':
            return salon.distance >= 1.0 && salon.distance <= 5.0;
          case '5 - 10 km':
            return salon.distance > 5.0 && salon.distance <= 10.0;
          case '> 10 km':
            return salon.distance > 10.0;
          default:
            return true;
        }
      }).toList();
    }

    // Filter by price range (mock implementation - you'd integrate with real pricing data)
    if (selectedPriceRange != 'All') {
      filteredSalons = filteredSalons.where((salon) {
        // Mock price categorization based on salon name/rating
        // In a real app, you'd have actual price data
        switch (selectedPriceRange) {
          case '\$':
            return salon.rating < 4.3; // Budget salons
          case '\$\$':
            return salon.rating >= 4.3 && salon.rating < 4.6; // Mid-range
          case '\$\$\$':
            return salon.rating >= 4.6 && salon.rating < 4.8; // Premium
          case '\$\$\$\$':
            return salon.rating >= 4.8; // Luxury
          default:
            return true;
        }
      }).toList();
    }

    // Filter by open now (mock implementation)
    if (onlyOpenNow) {
      // In a real app, you'd check actual business hours against current time
      // For now, we'll randomly include about 70% of salons as "open"
      filteredSalons = filteredSalons.where((salon) {
        // Mock: consider salons with IDs ending in certain numbers as "open"
        final salonId = int.tryParse(salon.id) ?? 0;
        return salonId % 10 < 7; // ~70% of salons are "open"
      }).toList();
    }

    // Filter by popular (high rating + many reviews)
    if (onlyPopular) {
      filteredSalons = filteredSalons.where((salon) {
        return salon.rating >= 4.5; // Only highly rated salons
      }).toList();
    }

    return filteredSalons;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchFilters &&
        other.selectedCategory == selectedCategory &&
        other.selectedRating == selectedRating &&
        other.selectedDistance == selectedDistance &&
        other.selectedPriceRange == selectedPriceRange &&
        other.onlyOpenNow == onlyOpenNow &&
        other.onlyPopular == onlyPopular;
  }

  @override
  int get hashCode {
    return selectedCategory.hashCode ^
        selectedRating.hashCode ^
        selectedDistance.hashCode ^
        selectedPriceRange.hashCode ^
        onlyOpenNow.hashCode ^
        onlyPopular.hashCode;
  }
} 