import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryProvider extends ChangeNotifier {
  static const String _searchHistoryKey = 'search_history';
  static const int _maxHistoryLength = 10;
  
  List<String> _searchHistory = [];
  bool _isLoaded = false;

  List<String> get searchHistory => List.unmodifiable(_searchHistory);
  bool get isLoaded => _isLoaded;

  /// Load search history from SharedPreferences
  Future<void> loadSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyList = prefs.getStringList(_searchHistoryKey) ?? [];
      _searchHistory = historyList;
      _isLoaded = true;
      debugPrint('Search history loaded: ${_searchHistory.length} items');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading search history: $e');
      _searchHistory = [];
      _isLoaded = true;
      notifyListeners();
    }
  }

  /// Add a search term to history
  Future<void> addSearchTerm(String searchTerm) async {
    if (searchTerm.trim().isEmpty) return;

    final trimmedTerm = searchTerm.trim();
    
    // Remove if already exists to avoid duplicates
    _searchHistory.remove(trimmedTerm);
    
    // Add to the beginning of the list
    _searchHistory.insert(0, trimmedTerm);
    
    // Keep only the most recent searches
    if (_searchHistory.length > _maxHistoryLength) {
      _searchHistory = _searchHistory.take(_maxHistoryLength).toList();
    }

    debugPrint('Adding search term: $trimmedTerm');
    debugPrint('Search history now has: ${_searchHistory.length} items');
    
    await _saveToPreferences();
    notifyListeners();
  }

  /// Remove a specific search term from history
  Future<void> removeSearchTerm(String searchTerm) async {
    if (_searchHistory.remove(searchTerm)) {
      await _saveToPreferences();
      notifyListeners();
    }
  }

  /// Remove search term at specific index
  Future<void> removeSearchTermAt(int index) async {
    if (index >= 0 && index < _searchHistory.length) {
      _searchHistory.removeAt(index);
      await _saveToPreferences();
      notifyListeners();
    }
  }

  /// Clear all search history
  Future<void> clearSearchHistory() async {
    _searchHistory.clear();
    await _saveToPreferences();
    notifyListeners();
  }

  /// Save search history to SharedPreferences
  Future<void> _saveToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_searchHistoryKey, _searchHistory);
    } catch (e) {
      debugPrint('Error saving search history: $e');
    }
  }

  /// Get search suggestions based on current input
  List<String> getSearchSuggestions(String query) {
    if (query.trim().isEmpty) {
      return searchHistory;
    }

    final lowercaseQuery = query.toLowerCase();
    return searchHistory
        .where((term) => term.toLowerCase().contains(lowercaseQuery))
        .toList();
  }

  /// Check if a search term exists in history
  bool containsSearchTerm(String searchTerm) {
    return _searchHistory.contains(searchTerm.trim());
  }
} 