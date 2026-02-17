import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/constants/app_constants.dart';
import '../core/navigation/app_navigator.dart';
import '../core/navigation/app_route.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/data/sources/auth_local_source.dart';
import '../features/auth/data/sources/auth_remote_source.dart';
import '../features/auth/domain/usecases/get_profile_usecase.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/logout_usecase.dart';
import '../features/auth/domain/usecases/register_usecase.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/cart/data/repositories/cart_repository_impl.dart';
import '../features/cart/data/sources/cart_remote_source.dart';
import '../features/cart/domain/usecases/add_to_cart_usecase.dart';
import '../features/cart/domain/usecases/get_cart_usecase.dart';
import '../features/cart/presentation/cubit/cart_cubit.dart';
import '../features/checkout/data/repositories/checkout_repository_impl.dart';
import '../features/checkout/data/sources/checkout_remote_source.dart';
import '../features/checkout/domain/usecases/get_orders_usecase.dart';
import '../features/checkout/domain/usecases/place_order_usecase.dart';
import '../features/checkout/presentation/cubit/checkout_cubit.dart';
import '../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../features/favorites/data/sources/favorites_remote_source.dart';
import '../features/favorites/domain/usecases/get_favorites_usecase.dart';
import '../features/favorites/domain/usecases/toggle_favorite_usecase.dart';
import '../features/favorites/presentation/cubit/favorites_cubit.dart';
import '../features/profile/data/repositories/profile_repository_impl.dart';
import '../features/profile/data/sources/profile_remote_source.dart';
import '../features/profile/domain/usecases/get_order_history_usecase.dart';
import '../features/profile/domain/usecases/get_user_profile_usecase.dart';
import '../features/profile/presentation/cubit/profile_cubit.dart';
import '../features/home/data/repositories/home_repository_impl.dart';
import '../features/home/data/sources/home_remote_source.dart';
import '../features/home/domain/usecases/get_home_data_usecase.dart';
import '../features/home/presentation/cubit/home_cubit.dart';
import '../features/product/data/repositories/product_repository_impl.dart';
import '../features/product/data/sources/product_remote_source.dart';
import '../features/product/domain/usecases/get_product_detail_usecase.dart';
import '../features/product/domain/usecases/get_products_usecase.dart';
import '../features/product/presentation/cubit/product_detail_cubit.dart';
import '../features/product/presentation/cubit/products_cubit.dart';
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
        BlocProvider(create: (_) {
          final authRepo = AuthRepositoryImpl(
            remoteSource: AuthRemoteSource(),
            localSource: AuthLocalSource(),
          );
          return AuthCubit(
            authRepository: authRepo,
            loginUseCase: LoginUseCase(authRepo),
            registerUseCase: RegisterUseCase(authRepo),
            logoutUseCase: LogoutUseCase(authRepo),
            getProfileUseCase: GetProfileUseCase(authRepo),
          );
        }),
        BlocProvider(create: (_) {
          final homeRepo = HomeRepositoryImpl(
            dataSource: HomeDataSource(),
          );
          return HomeCubit(
            homeRepository: homeRepo,
            getHomeDataUseCase: GetHomeDataUseCase(homeRepo),
          );
        }),
        BlocProvider(create: (_) {
          final productRepo = ProductFeatureRepositoryImpl(
            dataSource: ProductDataSource(),
          );
          return ProductsCubit(
            getProductsUseCase: GetProductsUseCase(productRepo),
            productRepository: productRepo,
          );
        }),
        BlocProvider(create: (_) {
          final productRepo = ProductFeatureRepositoryImpl(
            dataSource: ProductDataSource(),
          );
          return ProductDetailCubit(
            getProductDetailUseCase: GetProductDetailUseCase(productRepo),
          );
        }),
        BlocProvider(create: (_) {
          final cartRepo = CartRepositoryImpl(
            dataSource: CartDataSource(),
          );
          return CartCubit(
            cartRepository: cartRepo,
            getCartUseCase: GetCartUseCase(cartRepo),
            addToCartUseCase: AddToCartUseCase(cartRepo),
          );
        }),
        BlocProvider(create: (_) {
          final favoritesRepo = FavoritesRepositoryImpl(
            dataSource: FavoritesDataSource(),
          );
          return FavoritesCubit(
            favoritesRepository: favoritesRepo,
            getFavoritesUseCase: GetFavoritesUseCase(favoritesRepo),
            toggleFavoriteUseCase: ToggleFavoriteUseCase(favoritesRepo),
          );
        }),
        BlocProvider(create: (_) {
          final checkoutRepo = CheckoutRepositoryImpl(
            dataSource: CheckoutDataSource(),
          );
          return CheckoutCubit(
            placeOrderUseCase: PlaceOrderUseCase(checkoutRepo),
            getOrdersUseCase: GetOrdersUseCase(checkoutRepo),
          );
        }),
        BlocProvider(create: (_) {
          final profileRepo = ProfileRepositoryImpl(
            dataSource: ProfileDataSource(),
          );
          return ProfileCubit(
            getUserProfileUseCase: GetUserProfileUseCase(profileRepo),
            getOrderHistoryUseCase: GetOrderHistoryUseCase(profileRepo),
          );
        }),
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
