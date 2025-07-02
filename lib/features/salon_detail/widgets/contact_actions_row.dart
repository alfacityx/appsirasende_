import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

class ContactActionsRow extends StatelessWidget {
  final VoidCallback onPhoneTap;
  final VoidCallback onWebsiteTap;
  final VoidCallback onInstagramTap;
  final VoidCallback onDirectionTap;
  final VoidCallback onShareTap;

  const ContactActionsRow({
    super.key,
    required this.onPhoneTap,
    required this.onWebsiteTap,
    required this.onInstagramTap,
    required this.onDirectionTap,
    required this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          icon: Icons.phone_rounded,
          label: 'Phone',
          onTap: onPhoneTap,
          gradient: const LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        _buildActionButton(
          icon: Icons.language_rounded,
          label: 'Website',
          onTap: onWebsiteTap,
          gradient: const LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        _buildActionButton(
          icon: Icons.photo_camera_rounded,
          label: 'Instagram',
          onTap: onInstagramTap,
          gradient: const LinearGradient(
            colors: [Color(0xFFE91E63), Color(0xFF9C27B0), Color(0xFF673AB7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        _buildActionButton(
          icon: Icons.navigation_rounded,
          label: 'Direction',
          onTap: onDirectionTap,
          gradient: const LinearGradient(
            colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        _buildActionButton(
          icon: Icons.share_rounded,
          label: 'Share',
          onTap: onShareTap,
          gradient: const LinearGradient(
            colors: [Color(0xFF9E9E9E), Color(0xFF757575)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required LinearGradient gradient,
  }) {
    return Column(
      children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: gradient.colors.first.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                  spreadRadius: 0,
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(28),
                onTap: onTap,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.transparent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.space8),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      );
  }
} 