import 'service.dart';
import 'staff_member.dart';
import 'customer_info.dart';

enum BookingStatus {
  draft,
  confirmed,
  inProgress,
  completed,
  cancelled,
}

class Booking {
  final String? id;
  final String providerId;
  final String providerName;
  final String providerAddress;
  final String? providerImageUrl;
  final List<Service> selectedServices;
  final Service? selectedService; // For backward compatibility
  final StaffMember? selectedStaff;
  final DateTime? selectedDate;
  final String? selectedTimeSlot;
  final CustomerInfo? customerInfo;
  final double totalAmount;
  final double taxAmount;
  final double serviceAmount;
  final BookingStatus status;
  final String? paymentMethod;
  final String? paymentTransactionId;
  final String? specialInstructions;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Booking({
    this.id,
    required this.providerId,
    required this.providerName,
    required this.providerAddress,
    this.providerImageUrl,
    this.selectedServices = const [],
    this.selectedService,
    this.selectedStaff,
    this.selectedDate,
    this.selectedTimeSlot,
    this.customerInfo,
    this.totalAmount = 0.0,
    this.taxAmount = 0.0,
    this.serviceAmount = 0.0,
    this.status = BookingStatus.draft,
    this.paymentMethod,
    this.paymentTransactionId,
    this.specialInstructions,
    this.createdAt,
    this.updatedAt,
  });

  bool get isComplete {
    final services = allSelectedServices;
    return services.isNotEmpty &&
        selectedStaff != null &&
        selectedDate != null &&
        selectedTimeSlot != null &&
        customerInfo != null &&
        customerInfo!.isComplete;
  }

  bool get isConfirmed => status == BookingStatus.confirmed;

  // Helper method to get all services (both single and multiple)
  List<Service> get allSelectedServices {
    final services = <Service>[];
    if (selectedServices.isNotEmpty) {
      services.addAll(selectedServices);
    } else if (selectedService != null) {
      services.add(selectedService!);
    }
    return services;
  }

  // Helper method to get total duration of all services
  Duration get totalServiceDuration {
    Duration total = Duration.zero;
    for (final service in allSelectedServices) {
      total += service.duration;
    }
    return total;
  }

  // Helper method to get total price of all services
  double get totalServicePrice {
    double total = 0.0;
    for (final service in allSelectedServices) {
      total += service.price;
    }
    return total;
  }

  DateTime? get appointmentDateTime {
    if (selectedDate == null || selectedTimeSlot == null) return null;
    
    try {
      // Parse time slot (e.g., "2:00 PM")
      final timeStr = selectedTimeSlot!.trim().replaceAll(' ', '');
      final isPM = timeStr.toLowerCase().contains('pm');
      final cleanTime = timeStr.replaceAll(RegExp(r'[apm]', caseSensitive: false), '');
      final parts = cleanTime.split(':');
      
      if (parts.length != 2) return null;
      
      int hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;
      
      // Handle 12-hour to 24-hour conversion
      if (isPM && hour != 12) {
        hour += 12;
      } else if (!isPM && hour == 12) {
        hour = 0;
      }
      
      // Validate hour and minute ranges
      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        return null;
      }
      
      return DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        hour,
        minute,
      );
    } catch (e) {
      // Return null if parsing fails
      return null;
    }
  }

  String get bookingReference {
    final now = DateTime.now();
    final dateStr = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    
    if (id != null && id!.isNotEmpty) {
      // Use first 6 characters of ID if available
      final idPart = id!.length >= 6 ? id!.substring(0, 6).toUpperCase() : id!.toUpperCase().padRight(6, '0');
      return 'BC$dateStr$idPart';
    } else {
      // Generate a temporary reference based on timestamp
      final timeStr = '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
      return 'BC$dateStr$timeStr';
    }
  }

  String getFormattedEndTime() {
    final services = allSelectedServices;
    if (selectedTimeSlot == null || services.isEmpty) {
      return '';
    }
    
    final startTime = appointmentDateTime;
    if (startTime == null) return '';
    
    final endTime = startTime.add(totalServiceDuration);
    
    final endHour = endTime.hour;
    final endMinute = endTime.minute;
    final endPeriod = endHour >= 12 ? 'PM' : 'AM';
    final displayEndHour = endHour > 12 ? endHour - 12 : (endHour == 0 ? 12 : endHour);
    
    if (endMinute == 0) {
      return '$displayEndHour:00 $endPeriod';
    } else {
      return '$displayEndHour:${endMinute.toString().padLeft(2, '0')} $endPeriod';
    }
  }

  String getFormattedDuration() {
    final duration = totalServiceDuration;
    if (duration == Duration.zero) return '';
    
    if (duration.inHours > 0) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      if (minutes > 0) {
        return '${hours}h ${minutes}min';
      } else {
        return '${hours}h';
      }
    } else {
      return '${duration.inMinutes} minutes';
    }
  }

  String getFormattedDate() {
    if (selectedDate == null) return '';
    
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    final date = selectedDate!;
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Booking copyWith({
    String? id,
    String? providerId,
    String? providerName,
    String? providerAddress,
    String? providerImageUrl,
    List<Service>? selectedServices,
    Service? selectedService,
    StaffMember? selectedStaff,
    DateTime? selectedDate,
    String? selectedTimeSlot,
    CustomerInfo? customerInfo,
    double? totalAmount,
    double? taxAmount,
    double? serviceAmount,
    BookingStatus? status,
    String? paymentMethod,
    String? paymentTransactionId,
    String? specialInstructions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Booking(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      providerAddress: providerAddress ?? this.providerAddress,
      providerImageUrl: providerImageUrl ?? this.providerImageUrl,
      selectedServices: selectedServices ?? this.selectedServices,
      selectedService: selectedService ?? this.selectedService,
      selectedStaff: selectedStaff ?? this.selectedStaff,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
      customerInfo: customerInfo ?? this.customerInfo,
      totalAmount: totalAmount ?? this.totalAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      serviceAmount: serviceAmount ?? this.serviceAmount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentTransactionId: paymentTransactionId ?? this.paymentTransactionId,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'providerId': providerId,
      'providerName': providerName,
      'providerAddress': providerAddress,
      'providerImageUrl': providerImageUrl,
      'selectedServices': selectedServices.map((service) => service.toJson()).toList(),
      'selectedService': selectedService?.toJson(),
      'selectedStaff': selectedStaff?.toJson(),
      'selectedDate': selectedDate?.toIso8601String(),
      'selectedTimeSlot': selectedTimeSlot,
      'customerInfo': customerInfo?.toJson(),
      'totalAmount': totalAmount,
      'taxAmount': taxAmount,
      'serviceAmount': serviceAmount,
      'status': status.name,
      'paymentMethod': paymentMethod,
      'paymentTransactionId': paymentTransactionId,
      'specialInstructions': specialInstructions,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String?,
      providerId: json['providerId'] as String,
      providerName: json['providerName'] as String,
      providerAddress: json['providerAddress'] as String,
      providerImageUrl: json['providerImageUrl'] as String?,
      selectedServices: (json['selectedServices'] as List<dynamic>?)
          ?.map((serviceJson) => Service.fromJson(serviceJson as Map<String, dynamic>))
          .toList() ?? [],
      selectedService: json['selectedService'] != null 
          ? Service.fromJson(json['selectedService'] as Map<String, dynamic>)
          : null,
      selectedStaff: json['selectedStaff'] != null 
          ? StaffMember.fromJson(json['selectedStaff'] as Map<String, dynamic>)
          : null,
      selectedDate: json['selectedDate'] != null 
          ? DateTime.parse(json['selectedDate'] as String)
          : null,
      selectedTimeSlot: json['selectedTimeSlot'] as String?,
      customerInfo: json['customerInfo'] != null 
          ? CustomerInfo.fromJson(json['customerInfo'] as Map<String, dynamic>)
          : null,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (json['taxAmount'] as num?)?.toDouble() ?? 0.0,
      serviceAmount: (json['serviceAmount'] as num?)?.toDouble() ?? 0.0,
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.draft,
      ),
      paymentMethod: json['paymentMethod'] as String?,
      paymentTransactionId: json['paymentTransactionId'] as String?,
      specialInstructions: json['specialInstructions'] as String?,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  @override
  String toString() {
    return 'Booking(id: $id, services: ${allSelectedServices.length})';
  }

  bool isValidBooking() {
    return allSelectedServices.isNotEmpty &&
        selectedStaff != null &&
        selectedDate != null &&
        selectedTimeSlot != null &&
        customerInfo != null &&
        customerInfo!.isComplete;
  }
} 
