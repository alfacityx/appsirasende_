import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../screens/full_gallery_screen.dart' show ImageViewerScreen;

class GalleryTab extends StatelessWidget {
  final List<String> images;

  const GalleryTab({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.screenPadding,
          child: Row(
            children: [
              Text(
                'Our Gallery',
                style: AppTypography.titleLarge,
              ),
              const Spacer(),
              Text(
                'See All',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.space16),
        SizedBox(
          height: 400, // Fixed height for the grid
          child: GridView.builder(
            padding: AppSpacing.screenPaddingHorizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return _buildGalleryItem(context, images[index], index);
            },
          ),
        ),
        const SizedBox(height: AppSpacing.space24),
      ],
    );
  }

  Widget _buildGalleryItem(BuildContext context, String imageUrl, int index) {
    return GestureDetector(
      onTap: () {
        _showImageViewer(context, images, index);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            color: AppColors.surface,
            child: Icon(
              Icons.image,
              color: AppColors.textSecondary,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }

  void _showImageViewer(BuildContext context, List<String> images, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageViewerScreen(
          images: images,
          initialIndex: initialIndex,
        ),
      ),
    );
  }
} 
