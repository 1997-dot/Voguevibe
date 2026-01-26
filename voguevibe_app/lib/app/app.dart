import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/navigation/app_navigator.dart';
import '../core/navigation/app_route.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import 'app_shell.dart';
import 'di.dart';

class VogueVibeApp extends StatefulWidget {
  const VogueVibeApp({super.key});

  @override
  State<VogueVibeApp> createState() => _VogueVibeAppState();
}

class _VogueVibeAppState extends State<VogueVibeApp> {
  final AppNavigator _navigator = getIt<AppNavigator>();

  @override
  void initState() {
    super.initState();
    _navigator.addListener(_onNavigationChanged);
  }

  @override
  void dispose() {
    _navigator.removeListener(_onNavigationChanged);
    super.dispose();
  }

  void _onNavigationChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      // TODO: Theme will be provided externally
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: _buildCurrentPage(),
    );
  }

  Widget _buildCurrentPage() {
    switch (_navigator.currentRoute) {
      case AppRoute.splash:
        return const SplashPage();

      case AppRoute.login:
        // TODO: Return LoginPage when UI is ready
        return const _PlaceholderPage(title: 'Login');

      case AppRoute.register:
        // TODO: Return RegisterPage when UI is ready
        return const _PlaceholderPage(title: 'Register');

      case AppRoute.home:
      case AppRoute.categories:
      case AppRoute.cart:
      case AppRoute.favorites:
      case AppRoute.profile:
        return const AppShell();

      case AppRoute.products:
        // TODO: Return ProductsPage when UI is ready
        return const _PlaceholderPage(title: 'Products');

      case AppRoute.productDetail:
        // TODO: Return ProductDetailPage when UI is ready
        return const _PlaceholderPage(title: 'Product Detail');

      case AppRoute.checkout:
        // TODO: Return CheckoutPage when UI is ready
        return const _PlaceholderPage(title: 'Checkout');

      case AppRoute.orderSuccess:
        // TODO: Return OrderSuccessPage when UI is ready
        return const _PlaceholderPage(title: 'Order Success');

      case AppRoute.ordersHistory:
        // TODO: Return OrdersHistoryPage when UI is ready
        return const _PlaceholderPage(title: 'Orders History');
    }
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String title;

  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
