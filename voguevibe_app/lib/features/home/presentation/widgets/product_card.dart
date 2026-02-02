import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ProductCardWidget extends StatelessWidget {
  final String imagePath;
  final String imageTooltip;
  final String productName;
  final String productPrice;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onAddTap;
  final bool isAdded;

  const ProductCardWidget({
    super.key,
    required this.imagePath,
    required this.imageTooltip,
    required this.productName,
    required this.productPrice,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onAddTap,
    this.isAdded = false,
  });

  @override
  Widget build(BuildContext context) {
    const double borderRadius = 20.0;
    const double spacing = 12.0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.carbonBlack, width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            // Glassmorphism Background
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: AppColors.blackberryCream.withValues(alpha: 0.2),
                ),
              ),
            ),

            // Content Layout
            Padding(
              padding: const EdgeInsets.all(spacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildProductImage(borderRadius),
                  const SizedBox(height: spacing),
                  _buildProductName(),
                  const Spacer(),
                  _buildBottomRow(),
                ],
              ),
            ),

            // Floating Favorite Icon
            Positioned(
              top: spacing,
              right: spacing,
              child: _FavoriteButton(
                isFavorite: isFavorite,
                onToggle: onFavoriteToggle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(double radius) {
    return Tooltip(
      message: imageTooltip,
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius - 4),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: AppColors.carbonBlack,
              child: const Icon(Icons.broken_image, color: AppColors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductName() {
    return Text(
      productName,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          productPrice,
          style: const TextStyle(
            color: AppColors.raspberryPlum,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        InkWell(
          onTap: onAddTap,
          borderRadius: BorderRadius.circular(8),
          child: Icon(
            Icons.add_circle_outline,
            color: isAdded ? AppColors.raspberryPlum : AppColors.white,
            size: 28,
          ),
        ),
      ],
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onToggle;

  const _FavoriteButton({required this.isFavorite, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isFavorite ? AppColors.raspberryPlum : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.raspberryPlum,
            width: 2,
          ),
        ),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          size: 18,
          color: isFavorite ? AppColors.white : AppColors.raspberryPlum,
        ),
      ),
    );
  }
}
