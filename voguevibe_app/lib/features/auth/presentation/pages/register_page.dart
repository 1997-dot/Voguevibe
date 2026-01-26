import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../widgets/auth_form_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // Logo
                Image.asset(
                  'assets/images/logo/logo.png',
                  width: screenWidth * 0.3,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 48),

                // Title Text
                Center(
                  child: SizedBox(
                    width: screenWidth * 0.65,
                    child: const Text(
                      'Start your own journey',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Username Field
                AuthTextField(
                  controller: _usernameController,
                  hintText: 'Username',
                  keyboardType: TextInputType.text,
                ),

                const SizedBox(height: 16),

                // Email Field
                AuthTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),

                // Phone Number Field
                AuthTextField(
                  controller: _phoneController,
                  hintText: 'Phone Number',
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 16),

                // Password Field
                AuthTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  isPassword: true,
                ),

                const SizedBox(height: 16),

                // Confirm Password Field
                AuthTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  isPassword: true,
                ),

                const SizedBox(height: 40),

                // Sign Up Button
                PrimaryActionButton(
                  text: 'Sign Up',
                  onPressed: () {
                    // TODO: Handle sign up logic
                  },
                ),

                const SizedBox(height: 20),

                // Login Link
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'You already have an account?',
                    style: TextStyle(
                      color: AppColors.alabasterGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.alabasterGrey,
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
