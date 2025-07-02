class Service {
  final String id;
  final String name;
  final String description;
  final Duration duration;
  final double price;
  final String category;
  final bool isPopular;
  final List<String> requiredStaffSkills;

  const Service({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.price,
    required this.category,
    this.isPopular = false,
    this.requiredStaffSkills = const [],
  });

  Service copyWith({
    String? id,
    String? name,
    String? description,
    Duration? duration,
    double? price,
    String? category,
    bool? isPopular,
    List<String>? requiredStaffSkills,
  }) {
    return Service(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      category: category ?? this.category,
      isPopular: isPopular ?? this.isPopular,
      requiredStaffSkills: requiredStaffSkills ?? this.requiredStaffSkills,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'duration': duration.inMinutes,
      'price': price,
      'category': category,
      'isPopular': isPopular,
      'requiredStaffSkills': requiredStaffSkills,
    };
  }

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      duration: Duration(minutes: json['duration'] ?? 0),
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      isPopular: json['isPopular'] ?? false,
      requiredStaffSkills: List<String>.from(json['requiredStaffSkills'] ?? []),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Service && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Service(id: $id, name: $name, price: \$${price.toStringAsFixed(2)})';
  }
} 