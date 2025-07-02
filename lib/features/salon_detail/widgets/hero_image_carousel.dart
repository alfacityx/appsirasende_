import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

class HeroImageCarousel extends StatefulWidget {
  final List<String> images;
  final double height;

  const HeroImageCarousel({
    super.key,
    required this.images,
    this.height = 300,
  });

  @override
  State<HeroImageCarousel> createState() => _HeroImageCarouselState();
}

class _HeroImageCarouselState extends State<HeroImageCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    if (widget.images.length > 1) {
      _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
        if (_pageController.hasClients) {
          final nextIndex = (_currentIndex + 1) % widget.images.length;
          _pageController.animateToPage(
            nextIndex,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
  }

  void _resumeAutoScroll() {
    _autoScrollTimer?.cancel();
    _startAutoScroll();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: Stack(
        children: [
          GestureDetector(
            onPanStart: (_) => _stopAutoScroll(),
            onPanEnd: (_) => _resumeAutoScroll(),
            onTap: () {
              _stopAutoScroll();
              Future.delayed(const Duration(seconds: 2), () => _resumeAutoScroll());
            },
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: widget.images.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
              return Container(
                width: double.infinity,
                height: widget.height,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background placeholder
                    Container(
                      color: AppColors.surface,
                      child: Icon(
                        Icons.image_outlined,
                        size: 60,
                        color: AppColors.textSecondary.withOpacity(0.3),
                      ),
                    ),
                    // High-quality hero image with better styling
                    _buildHeroImage(index),
                    // Subtle gradient overlay for better text readability
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black.withOpacity(0.1),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            ),
          ),
          // Page indicators
          if (widget.images.length > 1)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentIndex == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == index 
                          ? AppColors.primary 
                          : Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(int index) {
    // Create beautiful salon-themed images with gradients and professional styling
    final List<Color> gradients = [
      // Elegant salon colors
      const Color(0xFF6366F1), // Indigo
      const Color(0xFFEC4899), // Pink
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFF10B981), // Emerald
    ];

    final List<IconData> salonIcons = [
      Icons.content_cut,
      Icons.face_retouching_natural,
      Icons.spa,
      Icons.self_improvement,
      Icons.palette,
    ];

    final List<String> salonTexts = [
      'Hair Styling',
      'Facial Care',
      'Spa Services',
      'Wellness',
      'Beauty Care',
    ];

    final colorIndex = index % gradients.length;
    final baseColor = gradients[colorIndex];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            baseColor,
            baseColor.withOpacity(0.8),
            baseColor.withOpacity(0.6),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    radius: 1.2,
                    colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(60),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    salonIcons[colorIndex],
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  salonTexts[colorIndex],
                  style: AppTypography.headlineMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Professional Beauty Services',
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}