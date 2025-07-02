class StaffMember {
  final String id;
  final String firstName;
  final String lastName;
  final String title;
  final String bio;
  final String profileImageUrl;
  final double rating;
  final int reviewCount;
  final List<String> specialties;
  final List<String> skills;
  final bool isAvailable;
  final Map<String, List<String>> availability; // day -> time slots

  const StaffMember({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.title,
    this.bio = '',
    this.profileImageUrl = '',
    this.rating = 0.0,
    this.reviewCount = 0,
    this.specialties = const [],
    this.skills = const [],
    this.isAvailable = true,
    this.availability = const {},
  });

  String get fullName => '$firstName $lastName';

  String get displayTitle => title.isNotEmpty ? title : 'Specialist';

  StaffMember copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? title,
    String? bio,
    String? profileImageUrl,
    double? rating,
    int? reviewCount,
    List<String>? specialties,
    List<String>? skills,
    bool? isAvailable,
    Map<String, List<String>>? availability,
  }) {
    return StaffMember(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      title: title ?? this.title,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      specialties: specialties ?? this.specialties,
      skills: skills ?? this.skills,
      isAvailable: isAvailable ?? this.isAvailable,
      availability: availability ?? this.availability,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'title': title,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'specialties': specialties,
      'skills': skills,
      'isAvailable': isAvailable,
      'availability': availability,
    };
  }

  factory StaffMember.fromJson(Map<String, dynamic> json) {
    return StaffMember(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      title: json['title'] ?? '',
      bio: json['bio'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      specialties: List<String>.from(json['specialties'] ?? []),
      skills: List<String>.from(json['skills'] ?? []),
      isAvailable: json['isAvailable'] ?? true,
      availability: Map<String, List<String>>.from(
        json['availability']?.map((key, value) => 
          MapEntry(key, List<String>.from(value))) ?? {}
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StaffMember && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'StaffMember(id: $id, name: $fullName, title: $title)';
  }
} 