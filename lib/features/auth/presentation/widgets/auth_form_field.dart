import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// A custom, responsive styled TextField for authentication forms.
///
/// Designed for Sign In and Sign Up flows with support for password masking
/// and responsive width constraints.
class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final TextInputType? keyboardType;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate 70% of screen width for responsiveness
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fieldWidth = screenWidth * 0.7;

    return Center(
      child: SizedBox(
        width: fieldWidth,
        child: TextField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          cursorColor: AppColors.royalPlum,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: AppColors.alabasterGrey,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: AppColors.carbonBlack,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: AppColors.royalPlum),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: AppColors.royalPlum),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: AppColors.royalPlum, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}
