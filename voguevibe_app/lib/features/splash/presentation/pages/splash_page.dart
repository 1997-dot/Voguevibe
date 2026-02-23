import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../home/presentation/pages/home_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // Logo
                Flexible(
                  flex: 3,
                  child: Image.asset(
                    'assets/images/splash/splash.png',
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 32),

                // Tagline Text
                const Text(
                  'Make Your Own Style',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.raspberryPlum,
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                const Spacer(flex: 2),

                // Start Button
                AppButton(
                  text: 'Start Your Journey',
                  width: screenWidth * 0.7,
                  icon: Icons.arrow_forward,
                  onPressed: () async {
                    final authCubit = context.read<AuthCubit>();

                    // Wait for initialization if still loading
                    if (authCubit.state is AuthLoading ||
                        authCubit.state is AuthInitial) {
                      await authCubit.stream.firstWhere(
                        (state) =>
                            state is! AuthLoading && state is! AuthInitial,
                      );
                    }

                    if (!context.mounted) return;

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => authCubit.isAuthenticated
                            ? const HomePage()
                            : const LoginPage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
