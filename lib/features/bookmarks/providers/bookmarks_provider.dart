import 'package:flutter/foundation.dart';
import '../../home/models/salon.dart';

class BookmarksProvider with ChangeNotifier {
  final List<Salon> _bookmarkedSalons = [];

  List<Salon> get bookmarkedSalons => List.unmodifiable(_bookmarkedSalons);

  bool isBookmarked(Salon salon) {
    return _bookmarkedSalons.any((s) => s.id == salon.id);
  }

  void toggleBookmark(Salon salon) {
    final index = _bookmarkedSalons.indexWhere((s) => s.id == salon.id);
    
    if (index >= 0) {
      // Remove from bookmarks
      _bookmarkedSalons.removeAt(index);
    } else {
      // Add to bookmarks
      _bookmarkedSalons.add(salon.copyWith(isFavorite: true));
    }
    
    notifyListeners();
  }

  void addBookmark(Salon salon) {
    if (!isBookmarked(salon)) {
      _bookmarkedSalons.add(salon.copyWith(isFavorite: true));
      notifyListeners();
    }
  }

  void removeBookmark(Salon salon) {
    _bookmarkedSalons.removeWhere((s) => s.id == salon.id);
    notifyListeners();
  }

  void clearAllBookmarks() {
    _bookmarkedSalons.clear();
    notifyListeners();
  }

  int get bookmarksCount => _bookmarkedSalons.length;

  List<Salon> getBookmarksByCategory(String category) {
    if (category == 'All') {
      return bookmarkedSalons;
    }
    return _bookmarkedSalons
        .where((salon) => salon.categories.contains(category))
        .toList();
  }

  List<String> get availableCategories {
    if (_bookmarkedSalons.isEmpty) {
      return ['All'];
    }

    // Get all unique categories from bookmarked salons
    final Set<String> categorySet = <String>{};
    for (final salon in _bookmarkedSalons) {
      categorySet.addAll(salon.categories);
    }

    // Convert to list and sort alphabetically
    final List<String> categories = categorySet.toList()..sort();
    
    // Always put 'All' first
    return ['All', ...categories];
  }

  int getCategoryCount(String category) {
    if (category == 'All') {
      return _bookmarkedSalons.length;
    }
    return _bookmarkedSalons
        .where((salon) => salon.categories.contains(category))
        .length;
  }


} 