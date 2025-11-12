import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:votopia/core/ui/styles/app_colors.dart';

class AppTopBar extends StatelessWidget {
  final String title;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onAvatarTap;

  const AppTopBar({
    super.key,
    required this.title,
    this.onNotificationTap,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              letterSpacing: -0.5,
            ),
          ),
          Row(
            children: [
              Container(
                width: 280,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cerca',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    prefixIcon: Icon(LucideIcons.search, size: 20, color: Colors.grey.shade600),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(LucideIcons.bell, size: 24),
                onPressed: onNotificationTap ?? () {},
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                  padding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: onAvatarTap,
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.secondary,
                  child: const Text(
                    'GF',
                    style: TextStyle(
                      color: Color(0xFF285300),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
