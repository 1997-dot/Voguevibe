import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ProductModel {
  final String image;
  final String name;
  final int quantity;
  final double price;

  const ProductModel({
    required this.image,
    required this.name,
    required this.quantity,
    required this.price,
  });
}

class OrderSummarySection extends StatelessWidget {
  final List<ProductModel> products;
  final double subtotal;
  final String shippingText;
  final double total;
  final Color backgroundColor;
  final Color borderColor;

  const OrderSummarySection({
    super.key,
    required this.products,
    required this.subtotal,
    required this.total,
    this.shippingText = "FREE",
    required this.backgroundColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // PART 1: DYNAMIC PRODUCTS SECTION
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                separatorBuilder: (context, index) => Divider(
                  color: borderColor,
                  height: 32,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return _buildProductRow(product);
                },
              ),

              // SECTION DIVIDER
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: AppColors.alabasterGrey, thickness: 1),
              ),

              // PART 2: PRICE SUMMARY SECTION
              _buildSummaryRow("Subtotal", "\$${subtotal.toStringAsFixed(2)}", AppColors.white),
              const SizedBox(height: 12),
              _buildSummaryRow("Shipping", shippingText, AppColors.royalPlum, isBoldValue: true),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: AppColors.alabasterGrey, thickness: 1),
              ),

              // FINAL TOTAL ROW
              _buildSummaryRow(
                "Total",
                "\$${total.toStringAsFixed(2)}",
                AppColors.white,
                isLarge: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductRow(ProductModel product) {
    return Row(
      children: [
        // Product Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            product.image,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: Colors.grey, width: 70, height: 70),
          ),
        ),
        const SizedBox(width: 16),

        // Product Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                "Qty: ${product.quantity}",
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.alabasterGrey,
                ),
              ),
            ],
          ),
        ),

        // Product Price
        Text(
          "\$${product.price.toStringAsFixed(2)}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.raspberryPlum,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, Color valueColor, {bool isLarge = false, bool isBoldValue = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isLarge ? 20 : 16,
            fontWeight: isLarge ? FontWeight.bold : FontWeight.normal,
            color: AppColors.white,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isLarge ? 20 : 16,
            fontWeight: (isLarge || isBoldValue) ? FontWeight.bold : FontWeight.normal,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
