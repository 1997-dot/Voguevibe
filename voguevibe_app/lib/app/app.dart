import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/constants/app_constants.dart';
import '../core/navigation/app_navigator.dart';
import '../core/navigation/app_route.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/cart/presentation/cubit/cart_cubit.dart';
import '../features/checkout/presentation/cubit/checkout_cubit.dart';
import '../features/favorites/presentation/cubit/favorites_cubit.dart';
import '../features/home/presentation/cubit/home_cubit.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => FavoritesCubit()),
        BlocProvider(create: (_) => CheckoutCubit()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        home: _buildCurrentPage(),
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_navigator.currentRoute) {
      case AppRoute.splash:
        return const SplashPage();

      case AppRoute.login:
        return const LoginPage();

      case AppRoute.register:
        return const RegisterPage();

      case AppRoute.home:
      case AppRoute.categories:
      case AppRoute.cart:
      case AppRoute.favorites:
      case AppRoute.profile:
        return const AppShell();

      case AppRoute.products:
        return const _PlaceholderPage(title: 'Products');

      case AppRoute.productDetail:
        return const _PlaceholderPage(title: 'Product Detail');

      case AppRoute.checkout:
        return const _PlaceholderPage(title: 'Checkout');

      case AppRoute.orderSuccess:
        return const _PlaceholderPage(title: 'Order Success');

      case AppRoute.ordersHistory:
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
