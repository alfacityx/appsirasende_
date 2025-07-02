import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../../home/widgets/salon_card.dart';
import '../../home/widgets/category_chip.dart';
import '../providers/bookmarks_provider.dart';
import '../widgets/remove_bookmark_dialog.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Bookmark',
          style: AppTypography.appBarTitle,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<BookmarksProvider>(
        builder: (context, bookmarksProvider, child) {
          final allBookmarkedSalons = bookmarksProvider.bookmarkedSalons;
          final availableCategories = bookmarksProvider.availableCategories;
          
          // Reset selectedCategory if it's no longer available
          if (!availableCategories.contains(selectedCategory)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                selectedCategory = 'All';
              });
            });
          }
          
          // Filter by selected category
          final filteredSalons = selectedCategory == 'All'
              ? allBookmarkedSalons
              : allBookmarkedSalons.where((salon) => 
                  salon.categories.contains(selectedCategory)).toList();

          return Column(
            children: [
              // Only show category filter if there are bookmarks
              if (allBookmarkedSalons.isNotEmpty) ...[
                _buildCategoryFilter(availableCategories, bookmarksProvider),
                const SizedBox(height: AppSpacing.space16),
              ],
              Expanded(
                child: allBookmarkedSalons.isEmpty 
                    ? _buildEmptyState()
                    : filteredSalons.isEmpty
                        ? _buildCategoryEmptyState()
                        : ListView.builder(
                            padding: AppSpacing.screenPaddingHorizontal,
                            itemCount: filteredSalons.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.space16),
                                child: SalonCard(
                                  salon: filteredSalons[index],
                                  onFavoriteToggle: () => _handleRemoveBookmark(
                                    context, 
                                    bookmarksProvider, 
                                    filteredSalons[index]
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _handleRemoveBookmark(BuildContext context, BookmarksProvider bookmarksProvider, salon) {
    RemoveBookmarkDialog.show(
      context: context,
      salon: salon,
      onConfirm: () => bookmarksProvider.toggleBookmark(salon),
    );
  }



  Widget _buildCategoryFilter(List<String> categories, BookmarksProvider bookmarksProvider) {
    return Container(
      padding: AppSpacing.screenPaddingHorizontal,
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final count = bookmarksProvider.getCategoryCount(category);
            final displayLabel = category == 'All' ? 'All ($count)' : '$category ($count)';
            
            return Padding(
              padding: EdgeInsets.only(
                right: index < categories.length - 1 ? AppSpacing.space8 : 0,
              ),
              child: CategoryChip(
                label: displayLabel,
                isSelected: selectedCategory == category,
                onTap: () => setState(() => selectedCategory = category),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_outline,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.space16),
          Text(
            'No bookmarks yet',
            style: AppTypography.titleMedium,
          ),
          const SizedBox(height: AppSpacing.space8),
          Text(
            'Start exploring and bookmark your favorite salons',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.space24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Explore Salons'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.space16),
          Text(
            'No $selectedCategory bookmarks',
            style: AppTypography.titleMedium,
          ),
          const SizedBox(height: AppSpacing.space8),
          Text(
            'You don\'t have any bookmarked salons in this category yet.\nTry switching to another category or bookmark more salons.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.space24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () => setState(() => selectedCategory = 'All'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary),
                ),
                child: const Text('View All'),
              ),
              const SizedBox(width: AppSpacing.space12),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Explore Salons'),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 