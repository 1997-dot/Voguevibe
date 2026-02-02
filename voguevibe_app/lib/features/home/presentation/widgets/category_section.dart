import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'product_card.dart';

class ProductCardData {
  final String imagePath;
  final String imageTooltip;
  final String productName;
  final String productPrice;
  final bool isFavorite;

  const ProductCardData({
    required this.imagePath,
    required this.imageTooltip,
    required this.productName,
    required this.productPrice,
    required this.isFavorite,
  });
}

class ProductCategorySection extends StatelessWidget {
  final String title;
  final List<ProductCardData> products;
  final Function(int index) onFavoriteToggle;
  final Function(int index) onAddTap;

  const ProductCategorySection({
    super.key,
    required this.title,
    required this.products,
    required this.onFavoriteToggle,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate 35% of screen width for the title constraint
    final double screenWidth = MediaQuery.of(context).size.width;
    final double titleWidth = screenWidth * 0.35;

    const double horizontalPadding = 16.0;
    const double verticalSpacing = 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Title Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: SizedBox(
            width: titleWidth,
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.alabasterGrey,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        const SizedBox(height: verticalSpacing),

        // Product Grid Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: GridView.builder(
            // Key settings for use inside other scrollable views
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),

            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              // Adjusting ratio to accommodate the image and text vertically
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, index) {
              final product = products[index];

              return ProductCardWidget(
                imagePath: product.imagePath,
                imageTooltip: product.imageTooltip,
                productName: product.productName,
                productPrice: product.productPrice,
                isFavorite: product.isFavorite,
                onFavoriteToggle: () => onFavoriteToggle(index),
                onAddTap: () => onAddTap(index),
              );
            },
          ),
        ),
      ],
    );
  }
}
