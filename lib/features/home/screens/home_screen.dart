import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../models/salon.dart';
import '../widgets/category_chip.dart';
import '../widgets/salon_card.dart';
import '../../search/screens/search_screen.dart';
import '../../notifications/screens/notifications_screen.dart';
import '../../notifications/providers/notifications_provider.dart';
import '../../bookmarks/screens/bookmarks_screen.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> categories = [
    'Haircuts',
    'Make up',
    'Manicure',
    'Massage',
  ];

  // Special offers for the carousel
  final List<Map<String, dynamic>> specialOffers = [
    {
      'discount': 30,
      'title': 'Today\'s Special',
      'description': 'Get a discount for every service order!\nOnly valid for today!',
      'color': AppColors.primary,
    },
    {
      'discount': 25,
      'title': 'Weekend Deal',
      'description': 'Special weekend promotion for all\nhair styling services!',
      'color': const Color(0xFF6C63FF),
    },
    {
      'discount': 40,
      'title': 'First Timer',
      'description': 'New customer special offer!\nBook your first appointment now.',
      'color': const Color(0xFFFF6B6B),
    },
    {
      'discount': 20,
      'title': 'Loyalty Reward',
      'description': 'Thank you for being a loyal customer!\nEnjoy this exclusive discount.',
      'color': const Color(0xFF4ECDC4),
    },
    {
      'discount': 35,
      'title': 'Group Booking',
      'description': 'Book with friends and save more!\nPerfect for special occasions.',
      'color': const Color(0xFFFFD93D),
    },
  ];

  final List<Salon> nearbySalons = [
    const Salon(
      id: '1',
      name: 'Belle Curls',
      address: '0993 Novick Parkway',
      imageUrl: 'assets/images/salon1.jpg',
      rating: 4.8,
      distance: 1.2,
      categories: ['Haircuts', 'Make up'],
    ),
    const Salon(
      id: '2',
      name: 'Barbarella Salon',
      address: '0570 Ruskin Pass',
      imageUrl: 'assets/images/salon2.jpg',
      rating: 4.3,
      distance: 2.9,
      categories: ['Haircuts', 'Manicure'],
    ),
    const Salon(
      id: '3',
      name: 'Glamour Studio',
      address: '1234 Beauty Avenue',
      imageUrl: 'assets/images/salon3.jpg',
      rating: 4.6,
      distance: 1.8,
      categories: ['Make up', 'Massage'],
    ),
    const Salon(
      id: '4',
      name: 'Relaxation Spa',
      address: '5678 Wellness Street',
      imageUrl: 'assets/images/salon4.jpg',
      rating: 4.9,
      distance: 3.2,
      categories: ['Massage', 'Manicure'],
    ),
    const Salon(
      id: '5',
      name: 'Perfect Nails',
      address: '9876 Style Boulevard',
      imageUrl: 'assets/images/salon5.jpg',
      rating: 4.4,
      distance: 0.8,
      categories: ['Manicure'],
    ),
    const Salon(
      id: '6',
      name: 'Hair & Beyond',
      address: '4321 Fashion Lane',
      imageUrl: 'assets/images/salon6.jpg',
      rating: 4.7,
      distance: 2.1,
      categories: ['Haircuts'],
    ),
  ];

  String selectedCategory = 'All';
  PageController _offerPageController = PageController();
  int _currentOfferIndex = 0;
  Timer? _carouselTimer;

  // Category navigation
  PageController _categoryPageController = PageController();
  int _currentCategoryIndex = 0;
  ScrollController _categoryScrollController = ScrollController();
  
  // All categories including "All"
  List<String> get allCategories => ['All', ...categories];

  // Filtered salon list based on selected category
  List<Salon> get filteredSalons {
    if (selectedCategory == 'All') {
      return nearbySalons;
    }
    return nearbySalons.where((salon) => 
      salon.categories.contains(selectedCategory)
    ).toList();
  }

  // Get salons for a specific category
  List<Salon> getSalonsForCategory(String category) {
    if (category == 'All') {
      return nearbySalons;
    }
    return nearbySalons.where((salon) => 
      salon.categories.contains(category)
    ).toList();
  }

  @override
  void initState() {
    super.initState();
    _startCarouselTimer();
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _offerPageController.dispose();
    _categoryPageController.dispose();
    _categoryScrollController.dispose();
    super.dispose();
  }

  void _startCarouselTimer() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_offerPageController.hasClients) {
        final nextIndex = (_currentOfferIndex + 1) % specialOffers.length;
        _offerPageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopCarouselTimer() {
    _carouselTimer?.cancel();
  }

  void _restartCarouselTimer() {
    _stopCarouselTimer();
    _startCarouselTimer();
  }

  void _onCategorySelected(int index) {
    // Calculate distance to determine animation approach
    final currentIndex = _currentCategoryIndex;
    final targetIndex = index;
    final distance = (targetIndex - currentIndex).abs();
    
    setState(() {
      _currentCategoryIndex = index;
      selectedCategory = allCategories[index];
    });
    
    if (distance <= 1) {
      // Small jump - use smooth animation
      _categoryPageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      
      // Scroll category chip into view with a slight delay to prevent conflicts
      Future.delayed(const Duration(milliseconds: 50), () {
        _scrollCategoryChipIntoView(index);
      });
    } else {
      // Large jump - use instant jump to prevent animation issues
      _categoryPageController.jumpToPage(index);
      _scrollCategoryChipIntoView(index);
    }
  }

  void _onCategoryPageChanged(int index) {
    setState(() {
      _currentCategoryIndex = index;
      selectedCategory = allCategories[index];
    });

    // Scroll category chip into view when swiping
    _scrollCategoryChipIntoView(index);
  }

  double _calculateTextWidth(String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: AppTypography.labelMedium.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.size.width;
  }

  void _scrollCategoryChipIntoView(int index) {
    if (!_categoryScrollController.hasClients) return;
    
    final double screenWidth = MediaQuery.of(context).size.width;
    final double maxScroll = _categoryScrollController.position.maxScrollExtent;
    
    // Calculate actual widths for each chip
    double totalWidthToTarget = AppSpacing.screenHorizontal; // Initial padding
    double targetChipWidth = 0;
    
    for (int i = 0; i <= index; i++) {
      final category = allCategories[i];
      final double textWidth = _calculateTextWidth(category);
      final double chipWidth = textWidth + (AppSpacing.space20 * 2); // horizontal padding
      
      if (i == index) {
        targetChipWidth = chipWidth;
      } else {
        totalWidthToTarget += chipWidth + AppSpacing.space8; // chip + spacing
      }
    }
    
    // Calculate ideal scroll position to center the target chip
    double targetScroll = totalWidthToTarget + (targetChipWidth / 2) - (screenWidth / 2);
    
    // Handle special cases for better UX
    if (index == 0) {
      // First item: scroll to beginning
      targetScroll = 0.0;
    } else if (index == allCategories.length - 1) {
      // Last item: scroll to end
      targetScroll = maxScroll;
    } else {
      // Middle items: ensure they're visible with some buffer
      final double bufferZone = 60.0; // pixels of buffer on each side
      final double minScroll = totalWidthToTarget - bufferZone;
      final double maxVisibleScroll = totalWidthToTarget + targetChipWidth + bufferZone - screenWidth;
      
      if (targetScroll < minScroll) {
        targetScroll = minScroll;
      } else if (targetScroll > maxVisibleScroll) {
        targetScroll = maxVisibleScroll;
      }
    }
    
    // Ensure we don't scroll beyond bounds
    final double finalScroll = targetScroll.clamp(0.0, maxScroll);
    
    _categoryScrollController.animateTo(
      finalScroll,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildSpecialOffer(),
              _buildNearbySection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: AppSpacing.screenPaddingHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top bar with logo, app name and icons
          Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback if logo doesn't load
                    return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.space12),
              Text(
                'SıraSende',
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Consumer<NotificationsProvider>(
                builder: (context, notificationsProvider, child) {
                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationsScreen(),
                            ),
                          );
                        },
                      ),
                      if (notificationsProvider.unreadCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.background,
                                width: 1,
                              ),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              notificationsProvider.unreadCount > 9 
                                  ? '9+' 
                                  : '${notificationsProvider.unreadCount}',
                              style: AppTypography.labelSmall.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.bookmark_outline),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookmarksScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space24),
          // Welcome message positioned lower
          Text(
            'Morning, Daniel 👋',
            style: AppTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SearchScreen(),
            ),
          );
        },
        child: Container(
          padding: AppSpacing.all16,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppSizes.inputBorderRadius,
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.space12),
              Text(
                'Search',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.tune,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialOffer() {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: GestureDetector(
            onPanDown: (_) => _stopCarouselTimer(),
            onPanEnd: (_) => _restartCarouselTimer(),
            onTapDown: (_) => _stopCarouselTimer(),
            onTapUp: (_) => _restartCarouselTimer(),
            child: PageView.builder(
              controller: _offerPageController,
              onPageChanged: (index) {
                setState(() {
                  _currentOfferIndex = index;
                });
              },
              itemCount: specialOffers.length,
              itemBuilder: (context, index) {
                final offer = specialOffers[index];
                return Padding(
                  padding: AppSpacing.screenPaddingHorizontal,
                  child: Container(
                    padding: AppSpacing.all24,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          offer['color'] as Color,
                          (offer['color'] as Color).withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.space12,
                            vertical: AppSpacing.space4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${offer['discount']}% OFF',
                            style: AppTypography.labelMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space16),
                        Text(
                          offer['title'] as String,
                          style: AppTypography.headlineMedium.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space8),
                        Text(
                          offer['description'] as String,
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.space16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            specialOffers.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentOfferIndex == index ? 24 : 8,
              height: 8,
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                color: _currentOfferIndex == index 
                    ? AppColors.primary 
                    : AppColors.primary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.space24),
      ],
    );
  }

  Widget _buildNearbySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.screenPaddingHorizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nearby Your Location',
                style: AppTypography.titleLarge,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.space12),
        _buildCategoryFilter(),
        const SizedBox(height: AppSpacing.space16),
        // Category indicator dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            allCategories.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: _currentCategoryIndex == index ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentCategoryIndex == index 
                    ? AppColors.primary 
                    : AppColors.primary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.space16),
        // Swipeable salon content
        SizedBox(
          height: 400, // Fixed height for the swipeable area
          child: PageView.builder(
            controller: _categoryPageController,
            onPageChanged: _onCategoryPageChanged,
            itemCount: allCategories.length,
            itemBuilder: (context, pageIndex) {
              final category = allCategories[pageIndex];
              final salonsForCategory = getSalonsForCategory(category);
              
              return salonsForCategory.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: AppSpacing.screenPaddingHorizontal,
                      itemCount: salonsForCategory.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.space16),
                          child: SalonCard(salon: salonsForCategory[index]),
                        );
                      },
                    );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.space32),
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: AppSpacing.space16),
            Text(
              'No salons found',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.space8),
            Text(
              'Try selecting a different category',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.space32),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        controller: _categoryScrollController,
        scrollDirection: Axis.horizontal,
        padding: AppSpacing.screenPaddingHorizontal,
        itemCount: allCategories.length,
        itemBuilder: (context, index) {
          final category = allCategories[index];
          return Padding(
            padding: EdgeInsets.only(
              right: index < allCategories.length - 1 ? AppSpacing.space8 : 0,
            ),
            child: CategoryChip(
              label: category,
              isSelected: _currentCategoryIndex == index,
              onTap: () => _onCategorySelected(index),
            ),
          );
        },
      ),
    );
  }
} 
