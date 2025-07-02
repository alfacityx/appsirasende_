import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../home/models/salon.dart';
import '../models/staff_member_detail.dart';
import '../models/salon_detail.dart';
import '../widgets/contact_actions_row.dart';
import '../widgets/specialist_card.dart';
import '../widgets/hero_image_carousel.dart';
import '../tabs/about_tab.dart';
import '../tabs/reviews_tab.dart';
import '../../booking/screens/selected_services_screen.dart';
import 'full_gallery_screen.dart' show FullGalleryScreen, ImageViewerScreen;

class SalonDetailScreen extends StatefulWidget {
  final Salon salon;

  const SalonDetailScreen({
    super.key,
    required this.salon,
  });

  @override
  State<SalonDetailScreen> createState() => _SalonDetailScreenState();
}

class _SalonDetailScreenState extends State<SalonDetailScreen> {
  late SalonDetail salonDetail;
  late ScrollController _scrollController;
  late PageController _servicePageController;
  late ScrollController _categoryScrollController;
  
  bool _showStickyHeader = false;
  String _currentSection = 'Services';
  int _selectedServiceIndex = 0;
  
  // Selected services for booking
  List<Map<String, dynamic>> _selectedServices = [];
  
  // Global keys for sections
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _galleryKey = GlobalKey();
  final GlobalKey _reviewsKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  
  final List<String> sectionTabs = ['Services', 'Reviews', 'Gallery', 'About'];
  
  final List<String> serviceCategories = [
    'Featured',
    'Nails',
    'Facial', 
    'Lash extensions',
    'Hair Care',
    'Massage',
    'Skincare',
  ];

  @override
  void initState() {
    super.initState();
    
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _servicePageController = PageController();
    _categoryScrollController = ScrollController();

    salonDetail = SalonDetail(
      id: widget.salon.id,
      name: widget.salon.name,
      address: widget.salon.address,
      rating: widget.salon.rating,
      reviewCount: 3279, // Mock review count
      isOpen: true, // Mock open status
      heroImages: [
        'https://images.unsplash.com/photo-1560066984-138dadb4c035?ixlib=rb-4.0.3&auto=format&fit=crop&w=2074&q=80',
        'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80',
        'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?ixlib=rb-4.0.3&auto=format&fit=crop&w=2069&q=80',
        'https://images.unsplash.com/photo-1559599101-f09722fb4948?ixlib=rb-4.0.3&auto=format&fit=crop&w=2069&q=80',
      ],
      specialists: [
        StaffMemberDetail(
          id: '1',
          name: 'Sarah Johnson',
          title: 'Senior Therapist',
          imageUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
          rating: 4.9,
          isAvailable: true,
          specialties: ['Deep Tissue Massage', 'Aromatherapy'],
          experienceYears: 8,
        ),
        StaffMemberDetail(
          id: '2',
          name: 'Michael Chen',
          title: 'Massage Therapist',
          imageUrl: 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
          rating: 4.8,
          isAvailable: true,
          specialties: ['Hot Stone Therapy', 'Sports Massage'],
          experienceYears: 6,
        ),
        StaffMemberDetail(
          id: '3',
          name: 'Emily Rodriguez',
          title: 'Facial Specialist',
          imageUrl: 'https://images.unsplash.com/photo-1594824720882-42a9c30b2500?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
          rating: 4.9,
          isAvailable: true,
          specialties: ['Facial Treatments', 'Anti-aging Therapy'],
          experienceYears: 10,
        ),
      ],
      description: 'Welcome to Let\'s Relax My Spa & Therapy, where tranquility meets luxury. Our expert therapists provide world-class treatments in a serene environment designed to rejuvenate your mind, body, and soul.',
      phone: '+1 (555) 123-4567',
      website: 'https://www.letsrelaxspa.com',
      workingHours: const WorkingHours(
        mondayToFriday: '9:00 AM - 9:00 PM',
        weekends: '8:00 AM - 10:00 PM',
        dailySchedule: DailySchedule(
          monday: DaySchedule(
            dayName: 'Monday',
            isOpen: true,
            openTime: '9:00 AM',
            closeTime: '8:00 PM',
          ),
          tuesday: DaySchedule(
            dayName: 'Tuesday',
            isOpen: true,
            openTime: '9:00 AM',
            closeTime: '8:00 PM',
          ),
          wednesday: DaySchedule(
            dayName: 'Wednesday',
            isOpen: true,
            openTime: '9:00 AM',
            closeTime: '8:00 PM',
          ),
          thursday: DaySchedule(
            dayName: 'Thursday',
            isOpen: true,
            openTime: '9:00 AM',
            closeTime: '8:00 PM',
          ),
          friday: DaySchedule(
            dayName: 'Friday',
            isOpen: true,
            openTime: '9:00 AM',
            closeTime: '8:00 PM',
          ),
          saturday: DaySchedule(
            dayName: 'Saturday',
            isOpen: true,
            openTime: '9:00 AM',
            closeTime: '6:00 PM',
          ),
          sunday: DaySchedule(
            dayName: 'Sunday',
            isOpen: false,
          ),
        ),
      ),
      services: [
        const SalonService(name: 'Massage Therapy', typeCount: 12),
        const SalonService(name: 'Facial Treatments', typeCount: 8),
        const SalonService(name: 'Body Treatments', typeCount: 6),
        const SalonService(name: 'Aromatherapy', typeCount: 5),
        const SalonService(name: 'Hot Stone Therapy', typeCount: 4),
        const SalonService(name: 'Reflexology', typeCount: 3),
      ],
      galleryImages: [
        'https://images.unsplash.com/photo-1560066984-138dadb4c035?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1559599101-f09722fb4948?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1540555700478-4be289fbecef?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      ],
      reviews: [
        SalonReview(
          id: '1',
          userName: 'Sarah Wilson',
          userImageUrl: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80',
          rating: 5.0,
          comment: 'Amazing experience! The staff is professional and the ambiance is perfect.',
          date: DateTime.now().subtract(const Duration(days: 7)),
          likes: 23,
        ),
        SalonReview(
          id: '2',
          userName: 'Mike Johnson',
          userImageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80',
          rating: 5.0,
          comment: 'Best massage I\'ve ever had. Will definitely come back.',
          date: DateTime.now().subtract(const Duration(days: 14)),
          likes: 18,
        ),
        SalonReview(
          id: '3',
          userName: 'Emma Davis',
          userImageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80',
          rating: 4.0,
          comment: 'Clean facilities and friendly service. Highly recommended!',
          date: DateTime.now().subtract(const Duration(days: 21)),
          likes: 12,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _servicePageController.dispose();
    _categoryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroSection(),
                _buildSalonInfo(),
                _buildContactActions(),
                const SizedBox(height: AppSpacing.space24),
                _buildServicesSection(),
                _buildReviewsSection(),
                _buildGallerySection(),
                _buildAboutSection(),
                const SizedBox(height: 100), // Space for bottom button
              ],
            ),
          ),
          // Sticky header - always rendered but animated
          _buildStickyHeader(),
          // Bottom book button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomBookButton(),
          ),
        ],
      ),
    );
  }

  void _onScroll() {
    final scrollOffset = _scrollController.offset;
    
    // Show sticky header almost immediately when scrolling starts
    final shouldShowHeader = scrollOffset > 5;
    if (shouldShowHeader != _showStickyHeader) {
      setState(() {
        _showStickyHeader = shouldShowHeader;
      });
    }

    // Detect current section
    String newSection = _detectCurrentSection();
    if (newSection != _currentSection) {
      setState(() {
        _currentSection = newSection;
      });
    }
  }

  String _detectCurrentSection() {
    if (!mounted || !_scrollController.hasClients) return 'Services';
    
    final scrollOffset = _scrollController.offset;
    String newSection = 'Services';

    // Get the render objects to calculate precise positions
    try {
      final servicesContext = _servicesKey.currentContext;
      final galleryContext = _galleryKey.currentContext;
      final reviewsContext = _reviewsKey.currentContext;
      final aboutContext = _aboutKey.currentContext;

      if (servicesContext != null && galleryContext != null && reviewsContext != null && aboutContext != null) {
        final servicesBox = servicesContext.findRenderObject() as RenderBox?;
        final galleryBox = galleryContext.findRenderObject() as RenderBox?;
        final reviewsBox = reviewsContext.findRenderObject() as RenderBox?;
        final aboutBox = aboutContext.findRenderObject() as RenderBox?;

        if (servicesBox != null && galleryBox != null && reviewsBox != null && aboutBox != null) {
          final servicesOffset = servicesBox.localToGlobal(Offset.zero).dy + scrollOffset;
          final galleryOffset = galleryBox.localToGlobal(Offset.zero).dy + scrollOffset;
          final reviewsOffset = reviewsBox.localToGlobal(Offset.zero).dy + scrollOffset;
          final aboutOffset = aboutBox.localToGlobal(Offset.zero).dy + scrollOffset;

          // Determine current section based on which section is closest to the top
          final screenCenter = MediaQuery.of(context).size.height / 3;
          
          if (scrollOffset + screenCenter >= aboutOffset) {
            newSection = 'About';
          } else if (scrollOffset + screenCenter >= galleryOffset) {
            newSection = 'Gallery';
          } else if (scrollOffset + screenCenter >= reviewsOffset) {
            newSection = 'Reviews';
          } else if (scrollOffset + screenCenter >= servicesOffset) {
            newSection = 'Services';
          } else {
            newSection = 'Services';
          }
        }
      } else {
        // Fallback to approximate positions if render boxes aren't available
        if (scrollOffset > 1400) {
          newSection = 'About';
        } else if (scrollOffset > 1200) {
          newSection = 'Gallery';
        } else if (scrollOffset > 1000) {
          newSection = 'Reviews';
        } else if (scrollOffset > 600) {
          newSection = 'Services';
        } else {
          newSection = 'Services';
        }
      }
    } catch (e) {
      // Fallback to approximate positions if there's any error
      if (scrollOffset > 1400) {
        newSection = 'About';
      } else if (scrollOffset > 1200) {
        newSection = 'Gallery';
      } else if (scrollOffset > 1000) {
        newSection = 'Reviews';
      } else if (scrollOffset > 600) {
        newSection = 'Services';
      } else {
        newSection = 'Services';
      }
    }

    return newSection;
  }

  void _scrollToSection(String section) {
    // Simple method stub - scrolling functionality removed
    print('Scroll to section: $section');
  }

  void _scrollCategoryToIndex(int index) {
    if (!_categoryScrollController.hasClients) return;
    
    // Calculate the approximate position of the category button
    const double buttonWidth = 120; // Approximate width of category button
    const double spacing = 8; // Margin between buttons
    const double padding = 24; // Screen padding
    
    final double targetPosition = (buttonWidth + spacing) * index - padding;
    final double maxScroll = _categoryScrollController.position.maxScrollExtent;
    final double screenWidth = MediaQuery.of(context).size.width;
    
    // Center the selected category on screen
    final double centeredPosition = targetPosition - (screenWidth / 2) + (buttonWidth / 2);
    final double clampedPosition = centeredPosition.clamp(0.0, maxScroll);
    
    _categoryScrollController.animateTo(
      clampedPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _addServiceToSelection(Map<String, String> service) {
    setState(() {
      // Create a copy with unique ID to allow multiple instances of same service
      final selectedService = Map<String, dynamic>.from(service);
      selectedService['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      _selectedServices.add(selectedService);
    });
  }

  void _removeServiceFromSelection(String serviceId) {
    setState(() {
      _selectedServices.removeWhere((service) => service['id'] == serviceId);
    });
  }

  double _calculateTotalPrice() {
    double total = 0.0;
    for (var service in _selectedServices) {
      String priceString = service['price'] as String;
      // Extract numeric value from "from $XX" format
      RegExp regex = RegExp(r'\$(\d+)');
      Match? match = regex.firstMatch(priceString);
      if (match != null) {
        total += double.parse(match.group(1)!);
      }
    }
    return total;
  }

  String _calculateTotalDuration() {
    int totalMinutes = 0;
    
    for (var service in _selectedServices) {
      String duration = service['duration'] as String;
      
      // Parse different duration formats
      if (duration.contains('hr')) {
        // Extract hours and minutes from formats like "1hr - 1hr 45min", "1hr 15min", "45min"
        RegExp hourRegex = RegExp(r'(\d+)hr');
        RegExp minRegex = RegExp(r'(\d+)min');
        
        Match? hourMatch = hourRegex.firstMatch(duration);
        Match? minMatch = minRegex.firstMatch(duration);
        
        int hours = 0;
        int minutes = 0;
        
        if (hourMatch != null) {
          hours = int.parse(hourMatch.group(1)!);
        }
        if (minMatch != null) {
          minutes = int.parse(minMatch.group(1)!);
        }
        
        // For ranges like "1hr - 1hr 45min", take the average
        if (duration.contains(' - ')) {
          List<String> parts = duration.split(' - ');
          if (parts.length == 2) {
            // Parse second part for range
            Match? hourMatch2 = hourRegex.allMatches(parts[1]).lastOrNull;
            Match? minMatch2 = minRegex.allMatches(parts[1]).lastOrNull;
            
            int hours2 = hourMatch2 != null ? int.parse(hourMatch2.group(1)!) : hours;
            int minutes2 = minMatch2 != null ? int.parse(minMatch2.group(1)!) : minutes;
            
            // Take average of the range
            hours = ((hours + hours2) / 2).round();
            minutes = ((minutes + minutes2) / 2).round();
          }
        }
        
        totalMinutes += (hours * 60) + minutes;
      }
    }
    
    // Convert back to hours and minutes
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;
    
    if (hours > 0 && minutes > 0) {
      return '${hours} hr${hours > 1 ? 's' : ''}, ${minutes} min${minutes > 1 ? 's' : ''}';
    } else if (hours > 0) {
      return '${hours} hr${hours > 1 ? 's' : ''}';
    } else {
      return '${minutes} min${minutes > 1 ? 's' : ''}';
    }
  }

  bool _isServiceSelected(Map<String, String> service) {
    return _selectedServices.any((selectedService) => 
        selectedService['name'] == service['name'] && 
        selectedService['duration'] == service['duration'] &&
        selectedService['price'] == service['price']);
  }

  Widget _buildServiceButton(Map<String, String> service) {
    final isSelected = _isServiceSelected(service);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isSelected 
            ? Colors.green.shade500
            : AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            if (isSelected) {
              // Find and remove the selected service
              final selectedService = _selectedServices.firstWhere(
                (Map<String, dynamic> selectedService) => 
                    selectedService['name'] == service['name'] && 
                    selectedService['duration'] == service['duration'] &&
                    selectedService['price'] == service['price'],
                orElse: () => <String, dynamic>{},
              );
              if (selectedService.isNotEmpty && selectedService['id'] != null) {
                _removeServiceFromSelection(selectedService['id']);
              }
            } else {
              _addServiceToSelection(service);
            }
          },
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: Icon(
                isSelected ? Icons.check : Icons.add,
                key: ValueKey(isSelected),
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAppointmentTypeOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Title
                  Text(
                    'Choose Appointment Type',
                    style: AppTypography.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select how you\'d like to book your appointment',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                                     // Single-click appointment option
                   _buildAppointmentOption(
                     icon: Icons.flash_on,
                     title: 'Single-click Appointment',
                     subtitle: 'Quick booking with automatic scheduling',
                     color: AppColors.primary,
                     onTap: () {
                       Navigator.pop(context);
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                           builder: (context) => SelectedServicesScreen(
                             selectedServices: _selectedServices,
                             salonName: salonDetail.name,
                             salonAddress: salonDetail.address,
                             salonImageUrl: widget.salon.imageUrl,
                             isGroupAppointment: false,
                           ),
                         ),
                       );
                     },
                   ),
                   
                   const SizedBox(height: 16),
                   
                   // Group appointment option
                   _buildAppointmentOption(
                     icon: Icons.group,
                     title: 'Group Appointment',
                     subtitle: 'Book for multiple people together',
                     color: Colors.purple,
                     onTap: () {
                       Navigator.pop(context);
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                           builder: (context) => SelectedServicesScreen(
                             selectedServices: _selectedServices,
                             salonName: salonDetail.name,
                             salonAddress: salonDetail.address,
                             salonImageUrl: widget.salon.imageUrl,
                             isGroupAppointment: true,
                           ),
                         ),
                       );
                     },
                   ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppointmentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.border.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyHeader() {
    return Positioned(
      top: _showStickyHeader ? 0 : -140, // Adjusted for new height
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: _showStickyHeader ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ] : [],
          ),
          child: SafeArea(
            bottom: false,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: _showStickyHeader ? 1.0 : 0.0,
              child: Column(
                children: [
                  // Top section: Back button + Business name + action buttons
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        // Back button
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            iconSize: 20,
                            color: AppColors.textPrimary,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Business name
                        Expanded(
                          child: Text(
                            salonDetail.name,
                            style: AppTypography.titleLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Action buttons
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.share_outlined),
                                iconSize: 20,
                                color: AppColors.textPrimary,
                                onPressed: () {
                                  // Share functionality
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.bookmark_outline),
                                iconSize: 20,
                                color: AppColors.textPrimary,
                                onPressed: () {
                                  // Save/bookmark functionality
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Bottom section: Navigation tabs
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _buildCompactTab('Services'),
                        _buildCompactTab('Reviews'),
                        _buildCompactTab('Gallery'),
                        _buildCompactTab('About'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactTab(String section) {
    final isActive = _currentSection == section;
    return Expanded(
      child: GestureDetector(
        onTap: () => _scrollToSection(section),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: isActive
                ? Border(
                    bottom: BorderSide(
                      color: AppColors.textPrimary,
                      width: 2,
                    ),
                  )
                : null,
          ),
          child: Text(
            section,
            style: AppTypography.bodyMedium.copyWith(
              color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
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

  Widget _buildSpecialists() {
    return Column(
      children: [
        Padding(
          padding: AppSpacing.screenPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Our Specialist',
                style: AppTypography.titleLarge,
              ),
              Text(
                'See All',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.space16),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: AppSpacing.screenPaddingHorizontal,
            itemCount: salonDetail.specialists.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: index < salonDetail.specialists.length - 1 
                      ? AppSpacing.space16 
                      : 0,
                ),
                child: SpecialistCard(
                  specialist: salonDetail.specialists[index],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServicesSection() {
    return Container(
      padding: AppSpacing.all24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Services',
            key: _servicesKey,
            style: AppTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.space20),
          
          // Compact service categories like home page
          SizedBox(
            height: 40,
            child: ListView.builder(
              controller: _categoryScrollController,
              scrollDirection: Axis.horizontal,
              itemCount: serviceCategories.length,
              itemBuilder: (context, index) {
                final category = serviceCategories[index];
                final isSelected = index == _selectedServiceIndex;
                
                return GestureDetector(
                  onTap: () {
                    // Calculate distance to determine animation approach
                    final currentIndex = _selectedServiceIndex;
                    final targetIndex = index;
                    final distance = (targetIndex - currentIndex).abs();
                    
                    if (distance <= 1) {
                      // Small jump - use smooth animation
                      setState(() {
                        _selectedServiceIndex = index;
                      });
                      _servicePageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      // Large jump - use instant jump to prevent animation issues
                      setState(() {
                        _selectedServiceIndex = index;
                      });
                      _servicePageController.jumpToPage(index);
                      _scrollCategoryToIndex(index);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.only(right: AppSpacing.space8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.space20,
                      vertical: AppSpacing.space12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.border.withOpacity(0.3),
                        width: isSelected ? 0 : 1,
                      ),
                      boxShadow: isSelected 
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.1),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                    ),
                    child: Text(
                      category,
                      style: AppTypography.labelMedium.copyWith(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.space24),
          
          // Swipeable services list with page indicators
          SizedBox(
            height: 400,
            child: Column(
              children: [
                // Enhanced page indicator dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    serviceCategories.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: index == _selectedServiceIndex ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: index == _selectedServiceIndex 
                            ? LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.primary.withOpacity(0.7),
                                ],
                              )
                            : null,
                        color: index == _selectedServiceIndex 
                            ? null 
                            : AppColors.border.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: index == _selectedServiceIndex ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ] : [],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Swipeable PageView
                Expanded(
                  child: PageView.builder(
                    controller: _servicePageController,
                    itemCount: serviceCategories.length,
                    onPageChanged: (index) {
                      setState(() {
                        _selectedServiceIndex = index;
                      });
                      // Scroll category buttons to show the selected category
                      _scrollCategoryToIndex(index);
                    },
                    itemBuilder: (context, index) {
                      return _buildServicesList(serviceCategories[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList(String category) {
    // Mock services data based on category
    final services = _getServicesForCategory(category);
    
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: AppSpacing.all16,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['name'] as String,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service['duration'] as String,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      service['description'] as String,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      service['price'] as String,
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _buildServiceButton(service),
            ],
          ),
        );
      },
    );
  }

  List<Map<String, String>> _getServicesForCategory(String category) {
    switch (category) {
      case 'Featured':
        return [
          {
            'name': 'Gel Manicure',
            'duration': '1hr - 1hr 45min',
            'description': 'Included nail cutting, shaping, cuticle cleaning and massage',
            'price': 'from \$40'
          },
          {
            'name': 'Russian Volume Lashes',
            'duration': '1hr - 2hr',
            'description': '1:4 ratio or 1:9 ratio (depending on client\'s natural lashes)',
            'price': 'from \$109'
          },
          {
            'name': 'Classic Lashes',
            'duration': '1hr - 1hr 15min',
            'description': '1:1 ratio. Our classic lash service creates a beautiful natural look',
            'price': 'from \$79'
          },
        ];
      case 'Nails':
        return [
          {
            'name': 'Gel Manicure',
            'duration': '1hr - 1hr 45min',
            'description': 'Long-lasting gel polish with professional finish',
            'price': 'from \$40'
          },
          {
            'name': 'French Manicure',
            'duration': '1hr 15min',
            'description': 'Classic elegant French tips with gel polish',
            'price': 'from \$50'
          },
          {
            'name': 'Nail Art Design',
            'duration': '1hr 30min - 2hr',
            'description': 'Custom nail art and decorative designs',
            'price': 'from \$65'
          },
        ];
      case 'Facial':
        return [
          {
            'name': 'Deep Cleansing Facial',
            'duration': '1hr',
            'description': 'Complete deep cleansing and hydrating treatment',
            'price': 'from \$85'
          },
          {
            'name': 'Anti-Aging Facial',
            'duration': '1hr 15min',
            'description': 'Rejuvenating treatment for mature skin',
            'price': 'from \$120'
          },
          {
            'name': 'Hydrating Facial',
            'duration': '45min',
            'description': 'Moisture-boosting treatment for dry skin',
            'price': 'from \$70'
          },
        ];
      case 'Lash extensions':
        return [
          {
            'name': 'Classic Lashes',
            'duration': '1hr - 1hr 15min',
            'description': '1:1 ratio natural lash extension',
            'price': 'from \$79'
          },
          {
            'name': 'Russian Volume Lashes',
            'duration': '1hr - 2hr',
            'description': 'Multiple extensions per natural lash',
            'price': 'from \$109'
          },
          {
            'name': 'Hybrid Lashes',
            'duration': '1hr 30min',
            'description': 'Mix of classic and volume techniques',
            'price': 'from \$95'
          },
        ];
      default:
        return [
          {
            'name': 'Service Coming Soon',
            'duration': '30min - 1hr',
            'description': 'More services in this category will be available soon',
            'price': 'from \$50'
          },
        ];
    }
  }

  Widget _buildGallerySection() {
    // Show only first 6 images in the preview
    final limitedImages = salonDetail.galleryImages.take(6).toList();
    
    return Container(
      key: _galleryKey,
      padding: AppSpacing.all24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with See All button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gallery',
                style: AppTypography.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullGalleryScreen(
                        images: salonDetail.galleryImages,
                        salonName: salonDetail.name,
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
          ),
          const SizedBox(height: AppSpacing.space16),
          // Grid of limited images
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: limitedImages.length,
            itemBuilder: (context, index) {
              return _buildGalleryItem(context, limitedImages[index], index, salonDetail.galleryImages);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryItem(BuildContext context, String imageUrl, int index, List<String> allImages) {
    return GestureDetector(
      onTap: () {
        _showImageViewer(context, allImages, index);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.surface,
            child: Center(
              child: Icon(
                Icons.image_outlined,
                color: AppColors.textSecondary,
                size: 32,
              ),
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

  Widget _buildReviewsSection() {
    return Container(
      padding: AppSpacing.all24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reviews',
            key: _reviewsKey,
            style: AppTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.space20),
          ReviewsTab(
            reviews: salonDetail.reviews,
            overallRating: salonDetail.rating,
            salonName: widget.salon.name,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: AppSpacing.all24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Us',
            key: _aboutKey,
            style: AppTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.space20),
          AboutTab(salonDetail: salonDetail),
        ],
      ),
    );
  }

  Widget _buildBottomBookButton() {
    if (_selectedServices.isEmpty) {
      // Show default state when no services selected
      int totalServices = 0;
      for (String category in serviceCategories) {
        totalServices += _getServicesForCategory(category).length;
      }

      return Container(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(context).padding.bottom + 1,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$totalServices services available',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: null, // Disabled when no services selected
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textSecondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Select services',
                  style: AppTypography.labelMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show selected services when services are selected
    final totalPrice = _calculateTotalPrice();
    final totalDuration = _calculateTotalDuration();
    
    return Container(
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: MediaQuery.of(context).padding.bottom + 12,
        ),
        child: 
            // Price and summary layout matching the provided image
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Total price prominently displayed at top left (like "RON 600")
                      Text(
                        '\$${totalPrice.toStringAsFixed(0)}',
                        style: AppTypography.headlineMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Service count and total duration (like "2 services • 2 hrs, 30 mins")
                      Text(
                        '${_selectedServices.length} service${_selectedServices.length > 1 ? 's' : ''} • $totalDuration',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    _showAppointmentTypeOptions();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Continue',
                    style: AppTypography.labelMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
        ),
      );
  }
} 