import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

class NotificationsProvider with ChangeNotifier {
  List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Payment Successful!',
      'subtitle': 'You have made a salon payment',
      'time': 'Today',
      'icon': Icons.credit_card,
      'color': AppColors.primary,
      'isRead': false,
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'id': '2',
      'title': 'New Services Available!',
      'subtitle': 'Now you can search the nearest salon',
      'time': 'Today',
      'icon': Icons.add_box,
      'color': const Color(0xFFFF6B9D),
      'isRead': false,
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
    },
    {
      'id': '3',
      'title': 'Today\'s Special Offers',
      'subtitle': 'You get a special promo today!',
      'time': 'Yesterday',
      'icon': Icons.local_offer,
      'color': const Color(0xFFFECA57),
      'isRead': true,
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': '4',
      'title': 'Credit Card Connected!',
      'subtitle': 'Credit Card has been linked!',
      'time': 'December 11, 2024',
      'icon': Icons.credit_card,
      'color': const Color(0xFF4834D4),
      'isRead': true,
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': '5',
      'title': 'Account Setup Successful!',
      'subtitle': 'Your account has been created!',
      'time': 'December 11, 2024',
      'icon': Icons.person,
      'color': const Color(0xFF6AB04C),
      'isRead': true,
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
    },
  ];

  List<Map<String, dynamic>> get notifications => List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n['isRead']).length;

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n['id'] == id);
    if (index != -1) {
      _notifications[index]['isRead'] = true;
      notifyListeners();
    }
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n['id'] == id);
    notifyListeners();
  }

  void markAllAsRead() {
    for (var notification in _notifications) {
      notification['isRead'] = true;
    }
    notifyListeners();
  }

  void addNotification({
    required String title,
    required String subtitle,
    required IconData icon,
    Color? color,
  }) {
    final newNotification = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title,
      'subtitle': subtitle,
      'time': 'Today',
      'icon': icon,
      'color': color ?? AppColors.primary,
      'isRead': false,
      'timestamp': DateTime.now(),
    };
    _notifications.insert(0, newNotification);
    notifyListeners();
  }

  void addNotificationFromData(Map<String, dynamic> notificationData) {
    // Find the correct position to insert based on timestamp
    final timestamp = notificationData['timestamp'] as DateTime;
    int insertIndex = 0;
    
    for (int i = 0; i < _notifications.length; i++) {
      final existingTimestamp = _notifications[i]['timestamp'] as DateTime;
      if (timestamp.isAfter(existingTimestamp)) {
        insertIndex = i;
        break;
      }
      insertIndex = i + 1;
    }
    
    _notifications.insert(insertIndex, notificationData);
    notifyListeners();
  }
} 