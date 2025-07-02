import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../home/models/salon.dart';
import '../models/salon_detail.dart';
import '../widgets/hero_image_carousel.dart';
import '../widgets/contact_actions_row.dart';
import '../tabs/about_tab.dart';
import '../tabs/services_tab.dart';
import '../tabs/package_tab.dart';
import '../tabs/gallery_tab.dart';
import '../tabs/reviews_tab.dart';
import '../../booking/screens/service_selection_screen.dart';

class SalonTabsScreen extends StatefulWidget {
  final Salon salon;
  final SalonDetail salonDetail;
  final int initialTab;

  const SalonTabsScreen({
    super.key,
    required this.salon,
    required this.salonDetail,
    this.initialTab = 0,
  });

  @override
  State<SalonTabsScreen> createState() => _SalonTabsScreenState();
}

class _SalonTabsScreenState extends State<SalonTabsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late SalonDetail salonDetail;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: widget.initialTab,
    );
    
    // Add mock data to salon detail
    salonDetail = widget.salonDetail.copyWith(
      services: [
        const SalonService(name: 'Hair Cut', typeCount: 44),
        const SalonService(name: 'Hair Coloring', typeCount: 12),
        const SalonService(name: 'Hair Wash', typeCount: 8),
        const SalonService(name: 'Shaving', typeCount: 22),
        const SalonService(name: 'Skin Care', typeCount: 12),
        const SalonService(name: 'Hair Dryer', typeCount: 4),
        const SalonService(name: 'Face Make up', typeCount: 18),
      ],
      packages: [
        SalonPackage(
          id: '1',
          name: 'Haircut & Hairstyle',
          description: 'Special Offers Package, valid until Dec 10, 2024',
          price: 125,
          imageUrl: 'assets/images/package1.jpg',
          validUntil: DateTime(2024, 12, 10),
        ),
        SalonPackage(
          id: '2',
          name: 'Beauty Make up',
          description: 'Special Offers Package, valid until Dec 20, 2024',
          price: 140,
          imageUrl: 'assets/images/package2.jpg',
          validUntil: DateTime(2024, 12, 20),
        ),
        SalonPackage(
          id: '3',
          name: 'Haircut & Hair Coloring',
          description: 'Special Offers Package, valid until Dec 16, 2024',
          price: 100,
          imageUrl: 'assets/images/package3.jpg',
          validUntil: DateTime(2024, 12, 16),
        ),
        SalonPackage(
          id: '4',
          name: 'Bridal Make up',
          description: 'Special Offers Package, valid until Dec 24, 2024',
          price: 160,
          imageUrl: 'assets/images/package4.jpg',
          validUntil: DateTime(2024, 12, 24),
        ),
        SalonPackage(
          id: '5',
          name: 'Hair Wash & Coloring',
          description: 'Special Offers Package, valid until Dec 15, 2024',
          price: 90,
          imageUrl: 'assets/images/package5.jpg',
          validUntil: DateTime(2024, 12, 15),
        ),
      ],
      galleryImages: List.generate(18, (index) => 'assets/images/gallery${index + 1}.jpg'),
      reviews: [
        SalonReview(
          id: '1',
          userName: 'Marielle Wigington',
          userImageUrl: 'assets/images/user1.jpg',
          rating: 5.0,
          comment: 'The people who work here are very friendly and professional. I really like it! 👍👍',
          date: DateTime.now().subtract(const Duration(days: 30)),
          likes: 982,
        ),
        SalonReview(
          id: '2',
          userName: 'Annabel Rohan',
          userImageUrl: 'assets/images/user2.jpg',
          rating: 4.0,
          comment: 'This is my first time trying the service, but the results are very satisfying! love it! ❤️❤️❤️',
          date: DateTime.now().subtract(const Duration(days: 30)),
          likes: 748,
        ),
        SalonReview(
          id: '3',
          userName: 'Rayford Chenail',
          userImageUrl: 'assets/images/user3.jpg',
          rating: 4.0,
          comment: 'I just found out that this salon is near my house. I think I\'ll be visiting it more often! 😊😊',
          date: DateTime.now().subtract(const Duration(days: 60)),
          likes: 572,
        ),
        SalonReview(
          id: '4',
          userName: 'Tynisha Obey',
          userImageUrl: 'assets/images/user4.jpg',
          rating: 5.0,
          comment: 'Professional service and satisfying results! I highly recommend this to my friends! 🔥🔥🔥',
          date: DateTime.now().subtract(const Duration(days: 90)),
          likes: 493,
        ),
        SalonReview(
          id: '5',
          userName: 'Willard Purnell',
          userImageUrl: 'assets/images/user5.jpg',
          rating: 4.0,
          comment: 'This is my first time trying the service, but the results are very satisfying! love it! ❤️',
          date: DateTime.now().subtract(const Duration(days: 120)),
          likes: 367,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeroSection(),
          _buildSalonInfo(),
          _buildContactActions(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                AboutTab(salonDetail: salonDetail),
                ServicesTab(services: salonDetail.services),
                PackageTab(packages: salonDetail.packages),
                GalleryTab(images: salonDetail.galleryImages),
                ReviewsTab(
                  reviews: salonDetail.reviews,
                  overallRating: salonDetail.rating,
                  salonName: salonDetail.name,
                ),
              ],
            ),
          ),
          _buildBottomBookButton(),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Stack(
      children: [
        HeroImageCarousel(
          images: salonDetail.heroImages,
          height: 300,
        ),
        SafeArea(
          child: Padding(
            padding: AppSpacing.all16,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.more_horiz, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSalonInfo() {
    return Padding(
      padding: AppSpacing.all24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  salonDetail.name,
                  style: AppTypography.headlineMedium,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: salonDetail.isOpen ? AppColors.success : AppColors.error,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  salonDetail.isOpen ? 'Open' : 'Closed',
                  style: AppTypography.labelMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space8),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: AppColors.primary,
                size: AppSizes.iconSm,
              ),
              const SizedBox(width: AppSpacing.space4),
              Expanded(
                child: Text(
                  salonDetail.address,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space8),
          Row(
            children: [
              Icon(
                Icons.star,
                color: AppColors.star,
                size: AppSizes.iconSm,
              ),
              const SizedBox(width: AppSpacing.space4),
              Text(
                '${salonDetail.rating} (${salonDetail.reviewCount} reviews)',
                style: AppTypography.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactActions() {
    return Padding(
      padding: AppSpacing.screenPaddingHorizontal,
      child: ContactActionsRow(
        onPhoneTap: () {},
        onWebsiteTap: () {},
        onInstagramTap: () {},
        onDirectionTap: () {},
        onShareTap: () {},
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.primary,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(25),
        ),
        labelStyle: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: AppTypography.labelMedium,
        tabs: const [
          Tab(text: 'About us'),
          Tab(text: 'Services'),
          Tab(text: 'Package'),
          Tab(text: 'Gallery'),
          Tab(text: 'Review'),
        ],
      ),
    );
  }

  Widget _buildBottomBookButton() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ServiceSelectionScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
            ),
            child: Text(
              'Book Now',
              style: AppTypography.labelLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
} 
