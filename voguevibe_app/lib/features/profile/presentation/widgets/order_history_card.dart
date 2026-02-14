import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class OrderProduct {
  final String name;
  final int quantity;

  OrderProduct({required this.name, required this.quantity});
}

class OrderData {
  final int orderNumber;
  final List<OrderProduct> products;
  final double totalPrice;

  OrderData({
    required this.orderNumber,
    required this.products,
    required this.totalPrice,
  });
}

class OrderHistorySection extends StatelessWidget {
  final List<OrderData> orders;

  const OrderHistorySection({
    super.key,
    required this.orders,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.55,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order History',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView.separated(
              itemCount: orders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8.0),
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderHistoryItem(
                  orderNumber: order.orderNumber,
                  products: order.products,
                  totalPrice: order.totalPrice,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OrderHistoryItem extends StatelessWidget {
  final int orderNumber;
  final List<OrderProduct> products;
  final double totalPrice;

  const OrderHistoryItem({
    super.key,
    required this.orderNumber,
    required this.products,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.blackberryCream,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Order',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(width: 4.0),
              Text(
                '#$orderNumber',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Column(
            children: products.map((product) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  children: [
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const Spacer(),
                    Text(
                      'x${product.quantity}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Text(
                'Total',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
              ),
              const SizedBox(width: 8.0),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
