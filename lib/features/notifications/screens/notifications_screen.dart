import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../providers/notifications_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsProvider>(
      builder: (context, notificationsProvider, child) {
        final notifications = notificationsProvider.notifications;
        final unreadCount = notificationsProvider.unreadCount;
        
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              children: [
                Text(
                  'Bildirimler',
                  style: AppTypography.appBarTitle,
                ),
                if (unreadCount > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$unreadCount',
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              if (unreadCount > 0)
                TextButton(
                  onPressed: () {
                    final count = unreadCount;
                    notificationsProvider.markAllAsRead();
                    _showCustomSnackBar(
                      context,
                      message: '$count notifications marked as read',
                      icon: Icons.done_all,
                      backgroundColor: AppColors.success,
                    );
                  },
                  child: Text(
                    'Tümünü\nOkundu',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.more_horiz, color: AppColors.textPrimary),
                onPressed: () {},
              ),
            ],
          ),
          body: notifications.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: AppSpacing.screenPadding,
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    final isFirstInGroup = index == 0 || 
                        notifications[index - 1]['time'] != notification['time'];
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isFirstInGroup) ...[
                          if (index > 0) const SizedBox(height: AppSpacing.space24),
                          Text(
                            notification['time'] as String,
                            style: AppTypography.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.space16),
                        ],
                        _buildNotificationItem(notification, notificationsProvider),
                      ],
                    );
                  },
                ),
        );
      },
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification, NotificationsProvider notificationsProvider) {
    final isRead = notification['isRead'] as bool;
    
    return Dismissible(
      key: Key(notification['id']),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        color: AppColors.primary,
        child: const Icon(Icons.mark_email_read, color: Colors.white),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Mark as read but don't dismiss from the tree
          notificationsProvider.markAsRead(notification['id']);
          _showCustomSnackBar(
            context,
            message: 'Notification marked as read',
            icon: Icons.mark_email_read,
            backgroundColor: AppColors.success,
          );
          return false; // Don't dismiss the widget
        } else {
          // Delete action - confirm dismissal
          return true;
        }
      },
      onDismissed: (direction) {
        // This will only be called for delete action now
        final deletedNotification = Map<String, dynamic>.from(notification);
        notificationsProvider.deleteNotification(notification['id']);
        
        _showCustomSnackBar(
          context,
          message: 'Notification deleted',
          icon: Icons.delete_outline,
          backgroundColor: AppColors.error,
          showUndo: true,
          onUndo: () {
            // Re-add the notification
            notificationsProvider.addNotificationFromData(deletedNotification);
          },
        );
      },
      child: GestureDetector(
        onTap: () {
          if (!isRead) {
            notificationsProvider.markAsRead(notification['id']);
            _showCustomSnackBar(
              context,
              message: 'Notification marked as read',
              icon: Icons.mark_email_read,
              backgroundColor: AppColors.success,
            );
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.space16),
          padding: AppSpacing.all16,
          decoration: BoxDecoration(
            color: isRead ? AppColors.cardBackground : AppColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isRead ? AppColors.border : AppColors.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: (notification['color'] as Color).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: notification['color'] as Color,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          notification['icon'] as IconData,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    if (!isRead)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.space16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification['title'] as String,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
                        color: isRead ? AppColors.textPrimary : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space4),
                    Text(
                      notification['subtitle'] as String,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: AppSpacing.space16),
          Text(
            'Hiç bildirim yok',
            style: AppTypography.titleLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.space8),
          Text(
            'Yeni bildirimler burada görünecek',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomSnackBar(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color backgroundColor,
    bool showUndo = false,
    VoidCallback? onUndo,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: AppSpacing.space12),
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (showUndo && onUndo != null) ...[
              const SizedBox(width: AppSpacing.space8),
              TextButton(
                onPressed: onUndo,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space12,
                    vertical: AppSpacing.space4,
                  ),
                ),
                child: Text(
                  'UNDO',
                  style: AppTypography.labelMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.space16,
          left: AppSpacing.space16,
          right: AppSpacing.space16,
        ),
        duration: const Duration(seconds: 4),
        action: showUndo 
            ? null 
            : SnackBarAction(
                label: '',
                onPressed: () {},
                backgroundColor: Colors.transparent,
              ),
      ),
    );
  }
} 