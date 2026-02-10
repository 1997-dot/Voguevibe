import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ProductCardWidget extends StatefulWidget {
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
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  late bool _isFavorite;
  late bool _isAdded;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
    _isAdded = widget.isAdded;
  }

  @override
  void didUpdateWidget(covariant ProductCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite) {
      _isFavorite = widget.isFavorite;
    }
    if (oldWidget.isAdded != widget.isAdded) {
      _isAdded = widget.isAdded;
    }
  }

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
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(double radius) {
    return Tooltip(
      message: widget.imageTooltip,
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius - 4),
          child: Image.asset(
            widget.imagePath,
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
      widget.productName,
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
          widget.productPrice,
          style: const TextStyle(
            color: AppColors.raspberryPlum,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _isFavorite = !_isFavorite;
                });
                widget.onFavoriteToggle();
              },
              borderRadius: BorderRadius.circular(8),
              child: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? AppColors.raspberryPlum : AppColors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () {
                setState(() {
                  _isAdded = !_isAdded;
                });
                widget.onAddTap();
              },
              borderRadius: BorderRadius.circular(8),
              child: Icon(
                Icons.add_circle_outline,
                color: _isAdded ? AppColors.raspberryPlum : AppColors.white,
                size: 28,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
