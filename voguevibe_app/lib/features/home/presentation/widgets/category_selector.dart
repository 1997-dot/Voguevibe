import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class CategorySelector extends StatelessWidget {
  final List<String> methods;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const CategorySelector({
    super.key,
    required this.methods,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double borderRadius = 30.0;

    return Center(
      child: Container(
        // Constrain width to 85% of the screen
        width: screenWidth * 0.85,
        height: 50, // Standard height for touch targets
        decoration: BoxDecoration(
          color: AppColors.blackberryCream,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: AppColors.blackberryCream, width: 1),
        ),
        // ClipRRect ensures child selection colors don't bleed outside the pill shape
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius - 1),
          child: Row(
            children: List.generate(methods.length, (index) {
              final bool isSelected = selectedIndex == index;

              return Expanded(
                child: _CategorySegment(
                  label: methods[index],
                  isSelected: isSelected,
                  isFirst: index == 0,
                  isLast: index == methods.length - 1,
                  onTap: () => onChanged(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _CategorySegment extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  const _CategorySegment({
    required this.label,
    required this.isSelected,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const double outerRadius = 30.0;

    // Logic for rounded corners based on position
    BorderRadius segmentRadius = BorderRadius.zero;
    if (isFirst) {
      segmentRadius = const BorderRadius.only(
        topLeft: Radius.circular(outerRadius),
        bottomLeft: Radius.circular(outerRadius),
      );
    } else if (isLast) {
      segmentRadius = const BorderRadius.only(
        topRight: Radius.circular(outerRadius),
        bottomRight: Radius.circular(outerRadius),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.raspberryPlum : AppColors.carbonBlack,
          borderRadius: segmentRadius,
        ),
        child: Text(
          label.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.alabasterGrey,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 13,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
