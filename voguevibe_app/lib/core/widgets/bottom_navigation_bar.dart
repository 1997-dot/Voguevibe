import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A custom, responsive Bottom Navigation Bar with a modern floating style.
/// This widget follows a centralized color system and handles its own selection state
/// while notifying the parent via [onItemSelected].
class CustomBottomNavBar extends StatefulWidget {
  final Function(int index) onItemSelected;
  final int initialIndex;

  const CustomBottomNavBar({
    super.key,
    required this.onItemSelected,
    this.initialIndex = 0,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late int _activeIndex;

  @override
  void initState() {
    super.initState();
    _activeIndex = widget.initialIndex;
  }

  void _handleTap(int index) {
    setState(() {
      _activeIndex = index;
    });
    widget.onItemSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    // Ensuring responsiveness by using MediaQuery for padding and constraints
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Adaptive width: Take full width on phones, but limit width on large tablets for better UX
    final double barWidth = screenWidth > 600 ? 500 : screenWidth;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: barWidth,
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
          border: const Border(
            top: BorderSide(
              color: AppColors.raspberryPlum,
              width: 1.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, bottomPadding > 0 ? 0 : 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_rounded, "Home"),
                _buildNavItem(1, Icons.shopping_cart_rounded, "Cart"),
                _buildNavItem(2, Icons.favorite_rounded, "Favorites"),
                _buildNavItem(3, Icons.person_rounded, "Profile"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isSelected = _activeIndex == index;

    final Color iconColor = isSelected
        ? AppColors.raspberryPlum
        : AppColors.alabasterGrey;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _handleTap(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 26,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: iconColor,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
