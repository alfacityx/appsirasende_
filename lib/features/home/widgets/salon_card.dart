import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../models/salon.dart';
import '../../salon_detail/screens/salon_detail_screen.dart';
import '../../bookmarks/providers/bookmarks_provider.dart';
import '../../bookmarks/widgets/remove_bookmark_dialog.dart';

class SalonCard extends StatelessWidget {
  final Salon salon;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;

  const SalonCard({
    super.key,
    required this.salon,
    this.onTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<BookmarksProvider>(
      builder: (context, bookmarksProvider, child) {
        final isBookmarked = bookmarksProvider.isBookmarked(salon);
        
        return GestureDetector(
          onTap: onTap ?? () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SalonDetailScreen(salon: salon),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: AppSizes.cardBorderRadius,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    color: AppColors.surface,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    child: Container(
                      color: AppColors.surface,
                      child: const Icon(
                        Icons.store,
                        color: AppColors.textSecondary,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: AppSpacing.all16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                salon.name,
                                style: AppTypography.titleMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _handleBookmarkTap(context, bookmarksProvider, isBookmarked),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  isBookmarked 
                                      ? Icons.bookmark 
                                      : Icons.bookmark_outline,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.space4),
                        Text(
                          salon.address,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.space8),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: AppColors.primary,
                              size: AppSizes.iconXs,
                            ),
                            const SizedBox(width: AppSpacing.space4),
                            Text(
                              '${salon.distance} km',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.space16),
                            Icon(
                              Icons.star,
                              color: AppColors.star,
                              size: AppSizes.iconXs,
                            ),
                            const SizedBox(width: AppSpacing.space4),
                            Text(
                              salon.rating.toString(),
                              style: AppTypography.labelSmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleBookmarkTap(BuildContext context, BookmarksProvider bookmarksProvider, bool isBookmarked) {
    if (onFavoriteToggle != null) {
      onFavoriteToggle!();
      return;
    }

    if (isBookmarked) {
      // Show confirmation dialog when removing
      RemoveBookmarkDialog.show(
        context: context,
        salon: salon,
        onConfirm: () => bookmarksProvider.toggleBookmark(salon),
      );
    } else {
      // Add directly when bookmarking
      bookmarksProvider.toggleBookmark(salon);
    }
  }
} 
