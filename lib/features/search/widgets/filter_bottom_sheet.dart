import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../home/widgets/category_chip.dart';
import '../models/search_filters.dart';

class FilterBottomSheet extends StatefulWidget {
  final SearchFilters initialFilters;

  const FilterBottomSheet({
    super.key,
    this.initialFilters = const SearchFilters(),
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet>
    with TickerProviderStateMixin {
  late String selectedCategory;
  late int selectedRating;
  late String selectedDistance;
  late String selectedPriceRange;
  late bool onlyOpenNow;
  late bool onlyPopular;

  final List<String> categories = ['All', 'Haircuts', 'Make up', 'Manicure', 'Massage'];
  final List<String> distances = ['All', '< 1 km', '1 - 5 km', '5 - 10 km', '> 10 km'];
  final List<String> priceRanges = ['All', '\$', '\$\$', '\$\$\$', '\$\$\$\$'];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialFilters.selectedCategory;
    selectedRating = widget.initialFilters.selectedRating;
    selectedDistance = widget.initialFilters.selectedDistance;
    selectedPriceRange = widget.initialFilters.selectedPriceRange;
    onlyOpenNow = widget.initialFilters.onlyOpenNow;
    onlyPopular = widget.initialFilters.onlyPopular;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _resetAllFilters() {
    setState(() {
      selectedCategory = 'All';
      selectedRating = 0;
      selectedDistance = 'All';
      selectedPriceRange = 'All';
      onlyOpenNow = false;
      onlyPopular = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.all24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuickToggles(),
                    const SizedBox(height: AppSpacing.space32),
                    _buildCategorySection(),
                    const SizedBox(height: AppSpacing.space32),
                    _buildRatingSection(),
                    const SizedBox(height: AppSpacing.space32),
                    _buildPriceSection(),
                    const SizedBox(height: AppSpacing.space32),
                    _buildDistanceSection(),
                    const SizedBox(height: AppSpacing.space40),
                  ],
                ),
              ),
            ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.tune,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Filter & Sort',
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              _buildActiveFilterBadge(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilterBadge() {
    final activeCount = _getActiveFilterCount();
    if (activeCount == 0) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$activeCount active',
        style: AppTypography.labelSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (selectedCategory != 'All') count++;
    if (selectedRating > 0) count++;
    if (selectedDistance != 'All') count++;
    if (selectedPriceRange != 'All') count++;
    if (onlyOpenNow) count++;
    if (onlyPopular) count++;
    return count;
  }

  Widget _buildQuickToggles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Filters',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.space16),
        Row(
          children: [
            Expanded(
              child: _buildToggleCard(
                'Open Now',
                'Available today',
                Icons.access_time,
                onlyOpenNow,
                (value) => setState(() => onlyOpenNow = value),
              ),
            ),
            const SizedBox(width: AppSpacing.space12),
            Expanded(
              child: _buildToggleCard(
                'Popular',
                'Highly rated',
                Icons.trending_up,
                onlyPopular,
                (value) => setState(() => onlyPopular = value),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleCard(
    String title,
    String subtitle,
    IconData icon,
    bool isSelected,
    Function(bool) onChanged,
  ) {
    return GestureDetector(
      onTap: () => onChanged(!isSelected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  size: 20,
                ),
                const Spacer(),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 12,
                          color: Colors.white,
                        )
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTypography.labelMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            Text(
              subtitle,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return _buildFilterSection(
      'Category',
      'Service type',
      Icons.category_outlined,
      Wrap(
        spacing: AppSpacing.space8,
        runSpacing: AppSpacing.space8,
        children: categories.map((category) {
          return CategoryChip(
            label: category,
            isSelected: selectedCategory == category,
            onTap: () => setState(() => selectedCategory = category),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRatingSection() {
    return _buildFilterSection(
      'Rating',
      'Minimum star rating',
      Icons.star_outline,
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(5, (index) {
            final rating = index == 0 ? 0 : index + 1;
            final label = index == 0 ? 'All' : '$rating+';
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.space8),
              child: _buildRatingChip(rating, label),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildRatingChip(int rating, String label) {
    final isSelected = selectedRating == rating;
    return GestureDetector(
      onTap: () => setState(() => selectedRating = rating),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border.withValues(alpha: 0.3),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (rating > 0) ...[
              Icon(
                Icons.star,
                size: 16,
                color: isSelected ? Colors.white : AppColors.star,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSection() {
    return _buildFilterSection(
      'Price Range',
      'Expected cost level',
      Icons.attach_money,
      Wrap(
        spacing: AppSpacing.space8,
        runSpacing: AppSpacing.space8,
        children: priceRanges.map((price) {
          final isSelected = selectedPriceRange == price;
          return GestureDetector(
            onTap: () => setState(() => selectedPriceRange = price),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border.withValues(alpha: 0.3),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Text(
                price,
                style: AppTypography.labelMedium.copyWith(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDistanceSection() {
    return _buildFilterSection(
      'Distance',
      'How far you\'re willing to travel',
      Icons.location_on_outlined,
      Wrap(
        spacing: AppSpacing.space8,
        runSpacing: AppSpacing.space8,
        children: distances.map((distance) {
          return CategoryChip(
            label: distance,
            isSelected: selectedDistance == distance,
            onTap: () => setState(() => selectedDistance = distance),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    String subtitle,
    IconData icon,
    Widget content,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space16),
          content,
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: _resetAllFilters,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(color: AppColors.border),
                  ),
                ),
                child: Text(
                  'Reset All',
                  style: AppTypography.buttonMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.space16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  final filters = SearchFilters(
                    selectedCategory: selectedCategory,
                    selectedRating: selectedRating,
                    selectedDistance: selectedDistance,
                    selectedPriceRange: selectedPriceRange,
                    onlyOpenNow: onlyOpenNow,
                    onlyPopular: onlyPopular,
                  );
                  Navigator.pop(context, filters);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Apply Filters',
                  style: AppTypography.buttonMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 