import 'staff_member_detail.dart';

class SalonDetail {
  final String id;
  final String name;
  final String address;
  final double rating;
  final int reviewCount;
  final bool isOpen;
  final List<String> heroImages;
  final List<StaffMemberDetail> specialists;
  final String description;
  final String phone;
  final String website;
  final WorkingHours workingHours;
  final List<SalonService> services;
  final List<SalonPackage> packages;
  final List<String> galleryImages;
  final List<SalonReview> reviews;

  const SalonDetail({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.reviewCount,
    required this.isOpen,
    required this.heroImages,
    required this.specialists,
    this.description = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip.',
    this.phone = '(406) 555-0120',
    this.website = 'www.barbarella.com',
    this.workingHours = const WorkingHours(),
    this.services = const [],
    this.packages = const [],
    this.galleryImages = const [],
    this.reviews = const [],
  });

  SalonDetail copyWith({
    String? id,
    String? name,
    String? address,
    double? rating,
    int? reviewCount,
    bool? isOpen,
    List<String>? heroImages,
    List<StaffMemberDetail>? specialists,
    String? description,
    String? phone,
    String? website,
    WorkingHours? workingHours,
    List<SalonService>? services,
    List<SalonPackage>? packages,
    List<String>? galleryImages,
    List<SalonReview>? reviews,
  }) {
    return SalonDetail(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isOpen: isOpen ?? this.isOpen,
      heroImages: heroImages ?? this.heroImages,
      specialists: specialists ?? this.specialists,
      description: description ?? this.description,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      workingHours: workingHours ?? this.workingHours,
      services: services ?? this.services,
      packages: packages ?? this.packages,
      galleryImages: galleryImages ?? this.galleryImages,
      reviews: reviews ?? this.reviews,
    );
  }
}

class WorkingHours {
  final String mondayToFriday;
  final String weekends;
  final DailySchedule? dailySchedule;

  const WorkingHours({
    this.mondayToFriday = '08:00 AM - 21:00 PM',
    this.weekends = '10:00 AM - 20:00 PM',
    this.dailySchedule,
  });
}

class DailySchedule {
  final DaySchedule monday;
  final DaySchedule tuesday;
  final DaySchedule wednesday;
  final DaySchedule thursday;
  final DaySchedule friday;
  final DaySchedule saturday;
  final DaySchedule sunday;

  const DailySchedule({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  List<DaySchedule> get allDays => [monday, tuesday, wednesday, thursday, friday, saturday, sunday];
}

class DaySchedule {
  final String dayName;
  final bool isOpen;
  final String? openTime;
  final String? closeTime;

  const DaySchedule({
    required this.dayName,
    required this.isOpen,
    this.openTime,
    this.closeTime,
  });

  String get displayTime {
    if (!isOpen) return 'Closed';
    if (openTime != null && closeTime != null) {
      return '$openTime - $closeTime';
    }
    return 'Closed';
  }
}

class SalonService {
  final String name;
  final int typeCount;

  const SalonService({
    required this.name,
    required this.typeCount,
  });
}

class SalonPackage {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final DateTime validUntil;

  const SalonPackage({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.validUntil,
  });
}

class SalonReview {
  final String id;
  final String userName;
  final String userImageUrl;
  final double rating;
  final String comment;
  final DateTime date;
  final int likes;

  const SalonReview({
    required this.id,
    required this.userName,
    required this.userImageUrl,
    required this.rating,
    required this.comment,
    required this.date,
    required this.likes,
  });
} 