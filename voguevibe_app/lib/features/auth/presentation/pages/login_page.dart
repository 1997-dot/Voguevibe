import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../widgets/auth_form_field.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameOrEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameOrEmailController.dispose();
    _passwordController.dispose();
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
                      'Welcome back',
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

                // Username or Email Field
                AuthTextField(
                  controller: _usernameOrEmailController,
                  hintText: 'Username or Email',
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),

                // Password Field
                AuthTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  isPassword: true,
                ),

                const SizedBox(height: 32),

                // Sign In Button
                PrimaryActionButton(
                  text: 'Sign In',
                  onPressed: () {
                    // TODO: Handle sign in logic
                  },
                ),

                const SizedBox(height: 20),

                // Create Account Link
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Create a new story',
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
