import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../../home/models/salon.dart';
import '../../home/widgets/salon_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../models/search_filters.dart';
import '../providers/search_history_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  bool _showResults = false;
  SearchFilters _currentFilters = SearchFilters();

  late SearchHistoryProvider _searchHistoryProvider;
  List<String> _localSearchHistory = [];

  final List<Salon> allSalons = [
    const Salon(
      id: '1',
      name: 'Barbarella Salon',
      address: '0570 Ruskin Pass',
      imageUrl: 'assets/images/salon1.jpg',
      rating: 4.3,
      distance: 2.9,
      categories: ['Haircuts'],
    ),
    const Salon(
      id: '2',
      name: 'The Godbarber Salon',
      address: '5 Southridge Hill',
      imageUrl: 'assets/images/salon2.jpg',
      rating: 4.8,
      distance: 4.4,
      categories: ['Haircuts', 'Make up'],
    ),
    const Salon(
      id: '3',
      name: 'Belle Curls Salon',
      address: '0993 Novick Parkway',
      imageUrl: 'assets/images/salon3.jpg',
      rating: 4.8,
      distance: 1.2,
      categories: ['Haircuts', 'Manicure'],
    ),
    const Salon(
      id: '4',
      name: 'Hairbreak Salon',
      address: '2759 Pearson Terrace',
      imageUrl: 'assets/images/salon4.jpg',
      rating: 4.8,
      distance: 3.6,
      categories: ['Haircuts', 'Make up'],
    ),
    const Salon(
      id: '5',
      name: 'Choppers Salon',
      address: '6 Laurel Pass',
      imageUrl: 'assets/images/salon5.jpg',
      rating: 4.2,
      distance: 1.5,
      categories: ['Haircuts'],
    ),
    const Salon(
      id: '6',
      name: 'Beauty Salon',
      address: '123 Main Street',
      imageUrl: 'assets/images/salon6.jpg',
      rating: 4.5,
      distance: 2.1,
      categories: ['Make up', 'Manicure'],
    ),
    const Salon(
      id: '7',
      name: 'Glamour Studio',
      address: '456 Beauty Boulevard',
      imageUrl: 'assets/images/salon7.jpg',
      rating: 4.7,
      distance: 3.8,
      categories: ['Make up', 'Massage'],
    ),
    const Salon(
      id: '8',
      name: 'Nail Paradise',
      address: '789 Polish Street',
      imageUrl: 'assets/images/salon8.jpg',
      rating: 4.4,
      distance: 2.5,
      categories: ['Manicure'],
    ),
    const Salon(
      id: '9',
      name: 'Relaxation Zone',
      address: '321 Calm Avenue',
      imageUrl: 'assets/images/salon9.jpg',
      rating: 4.6,
      distance: 5.2,
      categories: ['Massage'],
    ),
    const Salon(
      id: '10',
      name: 'Total Beauty Care',
      address: '654 Wellness Way',
      imageUrl: 'assets/images/salon10.jpg',
      rating: 4.9,
      distance: 4.1,
      categories: ['Haircuts', 'Make up', 'Manicure', 'Massage'],
    ),
    // Add some nearby salons (< 1km)
    const Salon(
      id: '11',
      name: 'Quick Cuts',
      address: '100 Corner Street',
      imageUrl: 'assets/images/salon11.jpg',
      rating: 4.3,
      distance: 0.3,
      categories: ['Haircuts'],
    ),
    const Salon(
      id: '12',
      name: 'Express Beauty',
      address: '50 Local Avenue',
      imageUrl: 'assets/images/salon12.jpg',
      rating: 4.1,
      distance: 0.7,
      categories: ['Make up', 'Manicure'],
    ),
    const Salon(
      id: '13',
      name: 'Nearby Nails',
      address: '25 Close Lane',
      imageUrl: 'assets/images/salon13.jpg',
      rating: 4.4,
      distance: 0.9,
      categories: ['Manicure'],
    ),
  ];

  List<Salon> get filteredSalons {
    List<Salon> results = List.from(allSalons);

    // Filter by search term
    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      results = results.where((salon) {
        return salon.name.toLowerCase().contains(searchTerm) ||
               salon.address.toLowerCase().contains(searchTerm) ||
               salon.categories.any((category) => 
                 category.toLowerCase().contains(searchTerm));
      }).toList();
    }

    // Apply filters
    results = _currentFilters.applyFilters(results);

    return results;
  }

  @override
  void initState() {
    super.initState();
    _searchFocus.requestFocus();
    _searchHistoryProvider = Provider.of<SearchHistoryProvider>(context, listen: false);
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    try {
      await _searchHistoryProvider.loadSearchHistory();
      if (mounted) {
        setState(() {
          _localSearchHistory = List<String>.from(_searchHistoryProvider.searchHistory);
        });
      }
    } catch (e) {
      debugPrint('Error loading search history: $e');
      // Fallback to local test data if there's an error
      if (mounted) {
        setState(() {
          _localSearchHistory = ['Hair salon', 'Beauty spa', 'Nail care'];
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _showFilterSheet() async {
    final filters = await showModalBottomSheet<SearchFilters>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FilterBottomSheet(initialFilters: _currentFilters),
    );
    
    if (filters != null) {
      setState(() {
        _currentFilters = filters;
      });
    }
  }

  Future<void> _addToRecent(String searchTerm) async {
    if (searchTerm.trim().isEmpty) return;
    
    final trimmedTerm = searchTerm.trim();
    
    // Update UI immediately
    setState(() {
      _localSearchHistory.remove(trimmedTerm);
      _localSearchHistory.insert(0, trimmedTerm);
      if (_localSearchHistory.length > 10) {
        _localSearchHistory = _localSearchHistory.take(10).toList();
      }
    });
    
    // Then update the provider for persistence
    try {
      await _searchHistoryProvider.addSearchTerm(trimmedTerm);
      // Sync with provider state in case there are differences
      if (mounted) {
        setState(() {
          _localSearchHistory = List<String>.from(_searchHistoryProvider.searchHistory);
        });
      }
    } catch (e) {
      debugPrint('Error adding search term to provider: $e');
      // Local state is already updated, so user sees immediate feedback
      // Provider sync will be retried on next app launch
    }
  }

  void _clearFilters() {
    setState(() {
      _currentFilters = SearchFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            if (_currentFilters.hasActiveFilters) _buildActiveFilters(),
            if (_showResults && !_currentFilters.hasActiveFilters) _buildQuickFilters(),
            Expanded(
              child: _showResults ? _buildSearchResults() : _buildRecentSearches(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: AppSpacing.screenPadding,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocus,
              decoration: InputDecoration(
                hintText: 'Search salons, services...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _showResults = false;
                          });
                        },
                      ),
                    IconButton(
                      icon: Icon(
                        Icons.tune,
                        color: _currentFilters.hasActiveFilters 
                            ? AppColors.primary 
                            : AppColors.textSecondary,
                      ),
                      onPressed: _showFilterSheet,
                    ),
                  ],
                ),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _showResults = value.isNotEmpty;
                });
              },
              onSubmitted: (value) async {
                if (value.isNotEmpty) {
                  await _addToRecent(value);
                  setState(() {
                    _showResults = true;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters() {
    final List<Widget> filterChips = [];
    
    if (_currentFilters.selectedCategory != 'All') {
      filterChips.add(_buildFilterChip(_currentFilters.selectedCategory, Icons.category));
    }
    if (_currentFilters.selectedRating > 0) {
      filterChips.add(_buildFilterChip('${_currentFilters.selectedRating}+ stars', Icons.star));
    }
    if (_currentFilters.selectedDistance != 'All') {
      filterChips.add(_buildFilterChip(_currentFilters.selectedDistance, Icons.location_on));
    }
    if (_currentFilters.selectedPriceRange != 'All') {
      filterChips.add(_buildFilterChip(_currentFilters.selectedPriceRange, Icons.attach_money));
    }
    if (_currentFilters.onlyOpenNow) {
      filterChips.add(_buildFilterChip('Open Now', Icons.access_time));
    }
    if (_currentFilters.onlyPopular) {
      filterChips.add(_buildFilterChip('Popular', Icons.trending_up));
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: filterChips.isEmpty ? 0 : null,
      padding: filterChips.isEmpty ? EdgeInsets.zero : AppSpacing.screenPaddingHorizontal,
      child: filterChips.isEmpty 
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.space8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.filter_list,
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.space8),
                  Text(
                    '${filterChips.length} filter${filterChips.length > 1 ? 's' : ''} active',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _clearFilters,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Clear all',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.space12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filterChips
                      .map((chip) => Padding(
                            padding: const EdgeInsets.only(right: AppSpacing.space8),
                            child: chip,
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.space16),
            ],
          ),
    );
  }

  Widget _buildQuickFilters() {
    final quickFilters = [
      {'label': 'Open Now', 'icon': Icons.access_time, 'filter': () => _applyQuickFilter(onlyOpenNow: true)},
      {'label': 'Popular', 'icon': Icons.trending_up, 'filter': () => _applyQuickFilter(onlyPopular: true)},
      {'label': 'Nearby', 'icon': Icons.location_on, 'filter': () => _applyQuickFilter(selectedDistance: '< 1 km')},
      {'label': 'Haircuts', 'icon': Icons.content_cut, 'filter': () => _applyQuickFilter(selectedCategory: 'Haircuts')},
      {'label': 'Make up', 'icon': Icons.face, 'filter': () => _applyQuickFilter(selectedCategory: 'Make up')},
      {'label': '4+ Stars', 'icon': Icons.star, 'filter': () => _applyQuickFilter(selectedRating: 4)},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppSpacing.screenPaddingHorizontal,
            child: Text(
              'Quick Filters',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.space8),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: AppSpacing.screenPaddingHorizontal,
              itemCount: quickFilters.length,
              itemBuilder: (context, index) {
                final filter = quickFilters[index];
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < quickFilters.length - 1 ? AppSpacing.space8 : 0,
                  ),
                  child: _buildQuickFilterChip(
                    filter['label'] as String,
                    filter['icon'] as IconData,
                    filter['filter'] as VoidCallback,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFilterChip(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space12,
          vertical: AppSpacing.space8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: AppColors.textSecondary,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _applyQuickFilter({
    String? selectedCategory,
    int? selectedRating,
    String? selectedDistance,
    String? selectedPriceRange,
    bool? onlyOpenNow,
    bool? onlyPopular,
  }) {
    setState(() {
      _currentFilters = _currentFilters.copyWith(
        selectedCategory: selectedCategory,
        selectedRating: selectedRating,
        selectedDistance: selectedDistance,
        selectedPriceRange: selectedPriceRange,
        onlyOpenNow: onlyOpenNow,
        onlyPopular: onlyPopular,
      );
    });
  }

  Widget _buildFilterChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space12,
        vertical: AppSpacing.space8,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    if (_localSearchHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.space16),
            Text(
              'No recent searches',
              style: AppTypography.titleMedium,
            ),
            const SizedBox(height: AppSpacing.space8),
            Text(
              'Your search history will appear here',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.screenPaddingHorizontal,
          child: Row(
            children: [
              Text(
                'Recent',
                style: AppTypography.titleMedium,
              ),
              const Spacer(),
              if (_localSearchHistory.isNotEmpty)
                TextButton(
                  onPressed: () async {
                    // Store backup for potential restore
                    final backupHistory = List<String>.from(_localSearchHistory);
                    
                    // Update UI immediately
                    setState(() {
                      _localSearchHistory.clear();
                    });
                    
                    // Then update the provider for persistence
                    try {
                      await _searchHistoryProvider.clearSearchHistory();
                    } catch (e) {
                      debugPrint('Error clearing search history: $e');
                      // If provider update fails, restore the backup
                      setState(() {
                        _localSearchHistory.addAll(backupHistory);
                      });
                    }
                  },
                  child: Text(
                    'Clear all',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.space16),
        Expanded(
          child: ListView.builder(
            padding: AppSpacing.screenPaddingHorizontal,
            itemCount: _localSearchHistory.length,
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.history,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                title: Text(
                  _localSearchHistory[index],
                  style: AppTypography.bodyMedium,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () async {
                    // Update UI immediately for better user experience
                    final removedTerm = _localSearchHistory[index];
                    setState(() {
                      _localSearchHistory.removeAt(index);
                    });
                    
                    // Then update the provider for persistence using the term itself
                    try {
                      await _searchHistoryProvider.removeSearchTerm(removedTerm);
                    } catch (e) {
                      debugPrint('Error removing search term: $e');
                      // If provider update fails, restore the item
                      setState(() {
                        _localSearchHistory.insert(index, removedTerm);
                      });
                    }
                  },
                ),
                onTap: () async {
                  _searchController.text = _localSearchHistory[index];
                  await _addToRecent(_localSearchHistory[index]);
                  setState(() {
                    _showResults = true;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    final results = filteredSalons;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.screenPaddingHorizontal,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _searchController.text.isNotEmpty 
                      ? 'Results for "${_searchController.text}"'
                      : 'All Results',
                  style: AppTypography.titleMedium,
                ),
              ),
              Text(
                '${results.length} ${results.length == 1 ? 'salon' : 'salons'} found',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.space16),
        Expanded(
          child: results.isEmpty 
              ? _buildNoResults()
              : ListView.builder(
                  padding: AppSpacing.screenPaddingHorizontal,
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.space16),
                      child: SalonCard(salon: results[index]),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.space16),
          Text(
            'No salons found',
            style: AppTypography.titleMedium,
          ),
          const SizedBox(height: AppSpacing.space8),
          Text(
            'Try adjusting your search or filters',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.space24),
          ElevatedButton(
            onPressed: () {
              _searchController.clear();
              _clearFilters();
              setState(() {
                _showResults = false;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear Search'),
          ),
        ],
      ),
    );
  }
} 