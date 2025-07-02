import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../models/salon_detail.dart';

class AboutTab extends StatefulWidget {
  final SalonDetail salonDetail;

  const AboutTab({
    super.key,
    required this.salonDetail,
  });

  @override
  State<AboutTab> createState() => _AboutTabState();
}

class _AboutTabState extends State<AboutTab> {
  bool _isDescriptionExpanded = false;
  static const int _descriptionCharacterLimit = 250;

  @override
  Widget build(BuildContext context) {
    final description = widget.salonDetail.description;
    final shouldShowReadMore = description.length > _descriptionCharacterLimit;
    final displayedDescription = _isDescriptionExpanded || !shouldShowReadMore
        ? description
        : '${description.substring(0, _descriptionCharacterLimit)}...';

    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: 4.0,    // Reduced from 16.0 to move content further left
        right: 16.0,  // Keep original right padding
        top: 16.0,    // Keep original top padding
        bottom: 16.0, // Keep original bottom padding
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            displayedDescription,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          if (shouldShowReadMore) ...[
            const SizedBox(height: AppSpacing.space8),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isDescriptionExpanded = !_isDescriptionExpanded;
                });
              },
              child: Text(
                _isDescriptionExpanded ? 'Read less...' : 'Read more...',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.space32),
          _buildWorkingHours(),
          const SizedBox(height: AppSpacing.space32),
          _buildLocationSection(),
        ],
      ),
    );
  }

  Widget _buildWorkingHours() {
    final dailySchedule = widget.salonDetail.workingHours.dailySchedule;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Working Hours',
          style: AppTypography.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.space16),
        if (dailySchedule != null) ...[
          ...dailySchedule.allDays.map((daySchedule) => _buildDayScheduleRow(daySchedule)),
        ] else
          // Fallback to old format if daily schedule is not available
          ...[
            _buildFallbackScheduleRow('Monday - Friday', widget.salonDetail.workingHours.mondayToFriday),
            const SizedBox(height: AppSpacing.space12),
            _buildFallbackScheduleRow('Saturday - Sunday', widget.salonDetail.workingHours.weekends),
          ],
      ],
    );
  }

  Widget _buildDayScheduleRow(DaySchedule daySchedule) {
    final isCurrentDay = _isCurrentDay(daySchedule.dayName);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space16),
      child: Row(
        children: [
          // Status indicator dot
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: daySchedule.isOpen ? const Color(0xFF4CAF50) : const Color(0xFFBDBDBD),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.space16),
          // Day name
          Expanded(
            child: Text(
              daySchedule.dayName,
              style: AppTypography.bodyLarge.copyWith(
                color: isCurrentDay 
                    ? const Color(0xFF000000) // Current day name in pure black
                    : AppColors.textPrimary,
                fontWeight: isCurrentDay ? FontWeight.w700 : FontWeight.w500, // Bolder for current day
              ),
            ),
          ),
          // Hours or "Closed"
          Text(
            daySchedule.displayTime,
            style: AppTypography.bodyLarge.copyWith(
              color: isCurrentDay 
                  ? const Color(0xFF000000) // Current day time in pure black
                  : daySchedule.isOpen 
                      ? AppColors.textPrimary 
                      : AppColors.textSecondary,
              fontWeight: isCurrentDay ? FontWeight.w800 : FontWeight.w600, // Extra bold for current day
            ),
          ),
        ],
      ),
    );
  }

  bool _isCurrentDay(String dayName) {
    final currentDay = DateTime.now().weekday;
    final dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final currentDayName = dayNames[currentDay - 1];
    return dayName == currentDayName;
  }

  Widget _buildFallbackScheduleRow(String label, String hours) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: Color(0xFF4CAF50),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.space16),
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          hours,
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: AppTypography.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.space16),
        _buildMap(),
      ],
    );
  }

  Widget _buildMap() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: AppSizes.cardBorderRadius,
      ),
      child: const Center(
        child: Text(
          'Map View\n(Will be implemented with live map)',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
} 