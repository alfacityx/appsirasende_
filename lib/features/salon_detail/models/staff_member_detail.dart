class StaffMemberDetail {
  final String id;
  final String name;
  final String title;
  final String imageUrl;
  final double rating;
  final bool isAvailable;
  final List<String> specialties;
  final int experienceYears;

  const StaffMemberDetail({
    required this.id,
    required this.name,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.isAvailable,
    this.specialties = const [],
    this.experienceYears = 5,
  });
} 