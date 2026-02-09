import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ProfileHeaderSection extends StatelessWidget {
  final String userName;
  final String userEmail;
  final VoidCallback onEditPressed;

  const ProfileHeaderSection({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            userName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8.0),
          Text(
            userEmail,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.raspberryPlum,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: onEditPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blackberryCream,
              foregroundColor: AppColors.raspberryPlum,
              elevation: 0,
              minimumSize: const Size(120, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
                side: const BorderSide(
                  color: AppColors.raspberryPlum,
                ),
              ),
            ),
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }
}
