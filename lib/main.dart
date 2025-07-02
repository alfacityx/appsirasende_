import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/booking/providers/booking_provider.dart';
import 'features/bookmarks/providers/bookmarks_provider.dart';
import 'features/search/providers/search_history_provider.dart';
import 'features/notifications/providers/notifications_provider.dart';
import 'features/navigation/screens/main_navigation_screen.dart';

void main() {
  runApp(const AppointmentApp());
}

class AppointmentApp extends StatelessWidget {
  const AppointmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BookingProvider()),
        ChangeNotifierProvider(create: (context) => BookmarksProvider()),
        ChangeNotifierProvider(create: (context) => SearchHistoryProvider()),
        ChangeNotifierProvider(create: (context) => NotificationsProvider()),
      ],
      child: MaterialApp(
        title: 'Appointment Booking',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainNavigationScreen(),
      ),
    );
  }
}
