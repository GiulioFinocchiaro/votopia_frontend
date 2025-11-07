import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:votopia/core/ui/styles/app_colors.dart';

class AppSidebar extends StatelessWidget {
  final String organizationName;
  final int selectedIndex;
  final Function(int) onMenuItemTap;

  const AppSidebar({
    super.key,
    required this.organizationName,
    required this.selectedIndex,
    required this.onMenuItemTap,
  });

  static const List<String> menuItems = [
    "Dashboard",
    "Utenti",
    "Eventi",
    "Impostazioni",
  ];

  static const List<IconData> menuIcons = [
    LucideIcons.layoutDashboard,
    LucideIcons.users,
    LucideIcons.calendar,
    LucideIcons.settings,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary,
            const Color(0xFF0F2557),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Logo
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Image.asset(
              'assets/images/icon.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            organizationName.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          // Menu items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final isSelected = selectedIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => onMenuItemTap(index),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          ),
                        ] : [],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            menuIcons[index],
                            color: Colors.white,
                            size: 22,
                          ),
                          const SizedBox(width: 14),
                          Text(
                            menuItems[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
