import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CustomFlexibleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leadingIcon;
  final Widget? actionImage;
  final double height;

  const CustomFlexibleAppBar({
    super.key,
    this.title,
    this.leadingIcon,
    this.actionImage,
    this.height = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        color: AppColors.black,
        border: Border(
          bottom: BorderSide(
            color: AppColors.raspberryPlum,
            width: 2.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Leading Icon Slot
            leadingIcon ?? const SizedBox(width: 24),

            // Title Text Slot
            Expanded(
              child: Center(
                child: Text(
                  title ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Image Slot
            actionImage ?? const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
