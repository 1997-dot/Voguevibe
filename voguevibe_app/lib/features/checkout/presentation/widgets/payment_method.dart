import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';

/// Define the payment options
enum PaymentMethod { cashOnDelivery, card }

class PaymentMethodSelector extends StatefulWidget {
  final ValueChanged<PaymentMethod>? onMethodChanged;

  const PaymentMethodSelector({super.key, this.onMethodChanged});

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  PaymentMethod _selectedMethod = PaymentMethod.cashOnDelivery;

  // Form Controllers
  final _nameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _handleSelection(PaymentMethod method) {
    setState(() {
      _selectedMethod = method;
    });
    widget.onMethodChanged?.call(method);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Option 1: Cash on Delivery
        _PaymentOptionCard(
          title: "Cash on Delivery",
          isSelected: _selectedMethod == PaymentMethod.cashOnDelivery,
          onTap: () => _handleSelection(PaymentMethod.cashOnDelivery),
        ),

        const SizedBox(height: 16),

        // Option 2: Credit / Debit Card
        _PaymentOptionCard(
          title: "Credit / Debit Card",
          isSelected: _selectedMethod == PaymentMethod.card,
          onTap: () => _handleSelection(PaymentMethod.card),
        ),

        // Animated Form Section
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _selectedMethod == PaymentMethod.card
              ? Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: _buildCardDetailsForm(),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }

  Widget _buildCardDetailsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CustomTextField(
          label: "Cardholder Name",
          hint: "John Doe",
          controller: _nameController,
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: 16),
        _CustomTextField(
          label: "Card Number",
          hint: "0000 0000 0000 0000",
          controller: _cardNumberController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _CustomTextField(
                label: "Expiry Date",
                hint: "MM/YY",
                controller: _expiryController,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _CustomTextField(
                label: "CVV",
                hint: "123",
                controller: _cvvController,
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PaymentOptionCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOptionCard({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.blackberryCream,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.royalPlum : AppColors.carbonBlack,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            _SelectionIndicator(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

class _SelectionIndicator extends StatelessWidget {
  final bool isSelected;

  const _SelectionIndicator({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.raspberryPlum : Colors.transparent,
        border: Border.all(
          color: isSelected ? AppColors.raspberryPlum : AppColors.alabasterGrey,
          width: 2,
        ),
      ),
      child: isSelected
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : null,
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;

  const _CustomTextField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.alabasterGrey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          style: const TextStyle(color: AppColors.alabasterGrey),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.alabasterGrey, fontSize: 14),
            filled: true,
            fillColor: AppColors.carbonBlack,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.blackberryCream),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.raspberryPlum),
            ),
          ),
        ),
      ],
    );
  }
}
