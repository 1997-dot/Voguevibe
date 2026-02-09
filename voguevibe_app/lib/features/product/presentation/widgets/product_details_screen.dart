import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ProductDetailsBottomSheet extends StatelessWidget {
  final String imageUrl;
  final String productTitle;
  final String description;
  final List<String> specifications;
  final VoidCallback onClosePressed;
  final VoidCallback onPrimaryButtonPressed;
  final VoidCallback onSecondaryButtonPressed;
  final String primaryButtonText;
  final String secondaryButtonText;

  const ProductDetailsBottomSheet({
    super.key,
    required this.imageUrl,
    required this.productTitle,
    required this.description,
    required this.specifications,
    required this.onClosePressed,
    required this.onPrimaryButtonPressed,
    required this.onSecondaryButtonPressed,
    required this.primaryButtonText,
    required this.secondaryButtonText,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenHeight * 0.7,
      decoration: BoxDecoration(
        color: AppColors.blackberryCream.withValues(alpha: 0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
        border: Border.all(color: AppColors.carbonBlack, width: 1.0),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Stack(
            children: [
              Column(
                children: [
                  // 1) EXPANDED SCROLLABLE CONTENT
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.asset(
                                  imageUrl,
                                  width: screenWidth * 0.4,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Featured Item",
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: AppColors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      "Premium Quality",
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.raspberryPlum,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            productTitle,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            "Description",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            description,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            "Specifications",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: specifications.map((spec) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  "• $spec",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 2) FIXED ACTION BUTTONS SECTION
                  Container(
                    height: screenHeight * 0.2,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildActionButton(
                          context,
                          text: primaryButtonText,
                          onPressed: onPrimaryButtonPressed,
                          width: screenWidth * 0.7,
                        ),
                        const SizedBox(height: 12.0),
                        _buildActionButton(
                          context,
                          text: secondaryButtonText,
                          onPressed: onSecondaryButtonPressed,
                          width: screenWidth * 0.7,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // CLOSE BUTTON (Top Right)
              Positioned(
                top: 16,
                right: 16,
                child: GestureDetector(
                  onTap: onClosePressed,
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context,
      {required String text, required VoidCallback onPressed, required double width}) {
    return SizedBox(
      width: width,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.blackberryCream,
          side: const BorderSide(color: AppColors.raspberryPlum, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.raspberryPlum,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}
