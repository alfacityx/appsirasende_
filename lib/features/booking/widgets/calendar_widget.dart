import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final List<DateTime> availableDates;
  final DateTime? minDate;
  final DateTime? maxDate;

  const CalendarWidget({
    super.key,
    this.selectedDate,
    required this.onDateSelected,
    this.availableDates = const [],
    this.minDate,
    this.maxDate,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _currentMonth;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.selectedDate ?? DateTime.now();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.all16,
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: AppSpacing.space16),
          _buildWeekdaysHeader(),
          const SizedBox(height: AppSpacing.space8),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: _previousMonth,
          icon: const Icon(
            Icons.chevron_left,
            size: AppSizes.iconLg,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          _getMonthYearText(_currentMonth),
          style: AppTypography.titleLarge,
        ),
        IconButton(
          onPressed: _nextMonth,
          icon: const Icon(
            Icons.chevron_right,
            size: AppSizes.iconLg,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildWeekdaysHeader() {
    const weekdays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    return Row(
      children: weekdays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final firstWeekday = firstDayOfMonth.weekday; // Monday = 1, Sunday = 7

    // Calculate days to show (including previous month's trailing days)
    final totalCells = ((daysInMonth + firstWeekday - 1) / 7).ceil() * 7;
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final dayNumber = index - firstWeekday + 2;
        
        if (dayNumber <= 0 || dayNumber > daysInMonth) {
          return const SizedBox(); // Empty cell for previous/next month
        }

        final date = DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
        final isSelected = widget.selectedDate != null &&
            _isSameDay(date, widget.selectedDate!);
        final isAvailable = _isDateAvailable(date);
        final isToday = _isSameDay(date, DateTime.now());

        return _buildCalendarCell(
          date: date,
          dayNumber: dayNumber,
          isSelected: isSelected,
          isAvailable: isAvailable,
          isToday: isToday,
        );
      },
    );
  }

  Widget _buildCalendarCell({
    required DateTime date,
    required int dayNumber,
    required bool isSelected,
    required bool isAvailable,
    required bool isToday,
  }) {
    return GestureDetector(
      onTap: isAvailable ? () => widget.onDateSelected(date) : null,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : isToday
                  ? AppColors.primaryWithOpacity
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          border: isToday && !isSelected
              ? Border.all(color: AppColors.primary, width: 1)
              : null,
        ),
        child: Center(
          child: Text(
            dayNumber.toString(),
            style: AppTypography.bodyMedium.copyWith(
              color: !isAvailable
                  ? AppColors.textDisabled
                  : isSelected
                      ? AppColors.background
                      : isToday
                          ? AppColors.primary
                          : AppColors.textPrimary,
              fontWeight: isSelected || isToday ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  bool _isDateAvailable(DateTime date) {
    // Check if date is in the past
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    if (dateOnly.isBefore(todayOnly)) return false;

    // Check min/max date constraints
    if (widget.minDate != null && date.isBefore(widget.minDate!)) return false;
    if (widget.maxDate != null && date.isAfter(widget.maxDate!)) return false;

    // If availableDates is provided, check if date is in the list
    if (widget.availableDates.isNotEmpty) {
      return widget.availableDates.any((availableDate) =>
          _isSameDay(date, availableDate));
    }

    return true;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  String _getMonthYearText(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }
} 