import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../models/salon_detail.dart';

class FullReviewsScreen extends StatefulWidget {
  final List<SalonReview> reviews;
  final double overallRating;
  final String salonName;

  const FullReviewsScreen({
    super.key,
    required this.reviews,
    required this.overallRating,
    required this.salonName,
  });

  @override
  State<FullReviewsScreen> createState() => _FullReviewsScreenState();
}

class _FullReviewsScreenState extends State<FullReviewsScreen> {
  int selectedStarFilter = 0; // 0 means all reviews
  String sortBy = 'Latest';
  late ScrollController _scrollController;
  
  List<SalonReview> get filteredReviews {
    List<SalonReview> filtered = widget.reviews;
    
    // Apply star filter
    if (selectedStarFilter > 0) {
      filtered = filtered.where((review) => review.rating.toInt() == selectedStarFilter).toList();
    }
    
    // Apply sorting
    switch (sortBy) {
      case 'Latest':
        filtered.sort((a, b) => b.date.compareTo(a.date));
        break;
      case 'Oldest':
        filtered.sort((a, b) => a.date.compareTo(b.date));
        break;
      case 'Highest Rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Lowest Rating':
        filtered.sort((a, b) => a.rating.compareTo(b.rating));
        break;
    }
    
    return filtered;
  }
  
  Map<int, int> get ratingCounts {
    Map<int, int> counts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (var review in widget.reviews) {
      int rating = review.rating.toInt();
      counts[rating] = (counts[rating] ?? 0) + 1;
    }
    return counts;
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Refresh data while maintaining current filters
    setState(() {
      // Just trigger a rebuild to refresh the current view
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Reviews',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        backgroundColor: Colors.white,
        color: AppColors.primary,
        strokeWidth: 2.5,
        child: Container(
          color: AppColors.background,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              color: AppColors.background,
              child: Column(
                children: [
                  _buildFilterSection(),
                  _buildReviewsList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    final counts = ratingCounts;
    
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating summary
          Row(
            children: [
              Icon(
                Icons.star,
                color: AppColors.star,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                '${widget.overallRating} (${widget.reviews.length} reviews)',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Filter pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterPill('All', 0, widget.reviews.length),
                const SizedBox(width: 8),
                _buildFilterPill('5', 5, counts[5] ?? 0),
                const SizedBox(width: 8),
                _buildFilterPill('4', 4, counts[4] ?? 0),
                const SizedBox(width: 8),
                _buildFilterPill('3', 3, counts[3] ?? 0),
                const SizedBox(width: 8),
                _buildFilterPill('2', 2, counts[2] ?? 0),
                const SizedBox(width: 8),
                _buildFilterPill('1', 1, counts[1] ?? 0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String label, int starValue, int count) {
    bool isSelected = selectedStarFilter == starValue;
    bool isDisabled = count == 0;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : () {
          setState(() {
            selectedStarFilter = isSelected ? 0 : starValue;
          });
        },
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppColors.primary 
                : isDisabled 
                    ? AppColors.surface.withOpacity(0.3)
                    : AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected 
                  ? AppColors.primary 
                  : AppColors.border.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (starValue > 0) ...[
                Icon(
                  Icons.star,
                  color: isSelected 
                      ? Colors.white 
                      : isDisabled 
                          ? AppColors.textSecondary.withOpacity(0.5)
                          : AppColors.star,
                  size: 16,
                ),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: AppTypography.labelMedium.copyWith(
                  color: isSelected 
                      ? Colors.white 
                      : isDisabled 
                          ? AppColors.textSecondary.withOpacity(0.5)
                          : AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewsList() {
    if (filteredReviews.isEmpty) {
      return Container(
        height: 400,
        decoration: const BoxDecoration(color: Colors.white),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.rate_review_outlined,
                size: 64,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: AppSpacing.space16),
              Text(
                'No reviews found',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.space8),
              Text(
                selectedStarFilter > 0 
                    ? 'No reviews with ${selectedStarFilter} stars'
                    : 'Be the first to leave a review!',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: filteredReviews.map((review) {
          return Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.border.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: _buildReviewCard(review),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReviewCard(SalonReview review) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile image/avatar
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.8),
                AppColors.primary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              review.userName.isNotEmpty ? review.userName[0].toUpperCase() : 'U',
              style: AppTypography.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Review content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User name and rating
              Row(
                children: [
                  Expanded(
                    child: Text(
                      review.userName,
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.star.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.star,
                          size: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          review.rating.toString(),
                          style: AppTypography.labelSmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Review text
              Text(
                review.comment,
                style: AppTypography.bodyMedium.copyWith(
                  height: 1.4,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              // Like button and date
              Row(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.favorite_border,
                        color: AppColors.textSecondary,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${(review.rating * 100).toInt()}', // Mock like count
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    _formatDate(review.date),
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Options menu
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.more_horiz,
            color: AppColors.textSecondary,
            size: 20,
          ),
          constraints: const BoxConstraints(),
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return '${months} month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
} 