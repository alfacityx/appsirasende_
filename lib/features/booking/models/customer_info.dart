class CustomerInfo {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String? email;
  final String? specialInstructions;
  final bool saveForFuture;

  const CustomerInfo({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.email,
    this.specialInstructions,
    this.saveForFuture = false,
  });

  String get fullName => '$firstName $lastName'.trim();

  bool get isComplete {
    return firstName.isNotEmpty && 
           lastName.isNotEmpty && 
           phoneNumber.isNotEmpty;
  }

  bool get hasValidEmail {
    if (email == null || email!.isEmpty) return true; // Email is optional
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email!);
  }

  bool get hasValidPhone {
    if (phoneNumber.isEmpty) return false;
    // Remove all non-digit characters
    final digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');
    // US phone numbers should have 10 digits
    return digitsOnly.length == 10;
  }

  String get formattedPhoneNumber {
    final digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length == 10) {
      return '(${digitsOnly.substring(0, 3)}) ${digitsOnly.substring(3, 6)}-${digitsOnly.substring(6)}';
    }
    return phoneNumber;
  }

  CustomerInfo copyWith({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
    String? specialInstructions,
    bool? saveForFuture,
  }) {
    return CustomerInfo(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      saveForFuture: saveForFuture ?? this.saveForFuture,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'specialInstructions': specialInstructions,
      'saveForFuture': saveForFuture,
    };
  }

  factory CustomerInfo.fromJson(Map<String, dynamic> json) {
    return CustomerInfo(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'],
      specialInstructions: json['specialInstructions'],
      saveForFuture: json['saveForFuture'] ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CustomerInfo &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.phoneNumber == phoneNumber &&
        other.email == email;
  }

  @override
  int get hashCode {
    return Object.hash(firstName, lastName, phoneNumber, email);
  }

  @override
  String toString() {
    return 'CustomerInfo(name: $fullName, phone: $phoneNumber)';
  }
} 