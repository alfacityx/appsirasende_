import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../models/salon_detail.dart';
import '../screens/full_reviews_screen.dart';

class ReviewsTab extends StatefulWidget {
  final List<SalonReview> reviews;
  final double overallRating;
  final String salonName;

  const ReviewsTab({
    super.key,
    required this.reviews,
    required this.overallRating,
    required this.salonName,
  });

  @override
  State<ReviewsTab> createState() => _ReviewsTabState();
}

class _ReviewsTabState extends State<ReviewsTab> {
  @override
  Widget build(BuildContext context) {
    // Show only first 2 reviews initially
    final displayedReviews = widget.reviews.take(2).toList();
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(),
        const SizedBox(height: AppSpacing.space20),
        // Dynamic height based on number of displayed reviews
        ...displayedReviews.map((review) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.space24),
            child: _buildReviewCard(review),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.star,
          color: AppColors.star,
          size: 20,
        ),
        const SizedBox(width: AppSpacing.space8),
        Text(
          '${widget.overallRating} (${widget.reviews.length} reviews)',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        const Spacer(),
        if (widget.reviews.length > 2) // Only show if there are more than 2 reviews
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullReviewsScreen(
                    reviews: widget.reviews,
                    overallRating: widget.overallRating,
                    salonName: widget.salonName,
                  ),
                ),
              );
            },
            child: Text(
              'See All',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildReviewCard(SalonReview review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile image
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: review.userImageUrl.isNotEmpty 
                    ? DecorationImage(
                        image: NetworkImage(review.userImageUrl),
                        fit: BoxFit.cover,
                      ) 
                    : null,
                color: review.userImageUrl.isEmpty ? AppColors.surface : null,
              ),
              child: review.userImageUrl.isEmpty 
                  ? const Icon(
                      Icons.person,
                      color: AppColors.textSecondary,
                      size: 24,
                    )
                  : null,
            ),
            const SizedBox(width: AppSpacing.space12),
            // User info and rating
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          review.userName,
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      // Star rating pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: AppColors.primary,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              review.rating.toInt().toString(),
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // More options
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.more_horiz,
                          color: AppColors.textSecondary,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.space12),
                  // Review text
                  Text(
                    review.comment,
                    style: AppTypography.bodyMedium.copyWith(
                      height: 1.5,
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space16),
                  // Like count and timestamp
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Handle like
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: AppColors.error,
                              size: 16,
                            ),
                            const SizedBox(width: AppSpacing.space8),
                            Text(
                              review.likes.toString(),
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.space24),
                      Text(
                        _formatDate(review.date),
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}