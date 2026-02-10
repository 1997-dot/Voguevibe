import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/appbar.dart';
import '../../../../core/widgets/bottom_navigation_bar.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';
import '../../../favorites/presentation/cubit/favorites_cubit.dart';
import '../../../favorites/presentation/cubit/favorites_state.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/category_selector.dart';
import '../widgets/offer_widget.dart';
import '../widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load products when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().loadProducts();
      context.read<CartCubit>().loadCart();
      context.read<FavoritesCubit>().loadFavorites();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Column(
        children: [
          // Fixed AppBar at top
          _buildAppBar(),

          // Scrollable content
          Expanded(
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.raspberryPlum,
                    ),
                  );
                }

                if (state is HomeError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: AppColors.white),
                    ),
                  );
                }

                if (state is HomeLoaded) {
                  return _buildHomeContent(state);
                }

                return const SizedBox();
              },
            ),
          ),

          // Fixed Bottom Navigation Bar
          CustomBottomNavBar(
            initialIndex: 0,
            onItemSelected: (index) {
              // Handle navigation
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return CustomFlexibleAppBar(
      height: 90,
      leadingIcon: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Image.asset(
          'assets/images/logo/logo.png',
          fit: BoxFit.contain,
        ),
      ),
      actionImage: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            color: AppColors.white,
            onPressed: () {
              // Handle notifications
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.logout),
            color: AppColors.white,
            onPressed: () {
              // Handle logout
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent(HomeLoaded state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Search Widget
            _buildSearchWidget(),
            const SizedBox(height: 20),

            // Category Selector
            CategorySelector(
              methods: const ['Future Vision', 'New Drops', 'Trending Now'],
              selectedIndex: _selectedCategoryIndex,
              onChanged: (index) {
                setState(() {
                  _selectedCategoryIndex = index;
                });
              },
            ),
            const SizedBox(height: 24),

            // Future Vision Section
            _buildSectionTitle('Future Vision'),
            const SizedBox(height: 16),
            _buildProductGrid(state, 'Future', 5),
            const SizedBox(height: 24),

            // Promotional Card
            Center(
              child: PromotionalCard(
                imageName: 'offer/offer.jpg',
                smallText: 'Enjoy Your Style',
                mainText: 'Anything 30\$',
                buttonText: 'Shop Now',
                onButtonTap: () {
                  // Handle shop now action
                },
              ),
            ),
            const SizedBox(height: 24),

            // New Drops Section
            _buildSectionTitle('New Drops'),
            const SizedBox(height: 16),
            _buildProductGrid(state, 'New', 5),
            const SizedBox(height: 24),

            // Trending Now Section
            _buildSectionTitle('Trending Now'),
            const SizedBox(height: 16),
            _buildProductGrid(state, 'Trending', 7),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchWidget() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.blackberryCream,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: AppColors.carbonBlack,
            width: 1.5,
          ),
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: AppColors.alabasterGrey),
          decoration: const InputDecoration(
            hintText: 'Search products...',
            hintStyle: TextStyle(color: AppColors.alabasterGrey),
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.alabasterGrey,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildProductGrid(HomeLoaded state, String category, int itemCount) {
    final products = state.getProductsByCategory(category).take(itemCount).toList();

    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, favoritesState) {
        return BlocBuilder<CartCubit, CartState>(
          builder: (context, cartState) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCardWidget(
                  imagePath: product.thumbnail,
                  imageTooltip: product.title,
                  productName: product.title,
                  productPrice: '\$${product.price.toStringAsFixed(0)}',
                  isFavorite: product.isFavorite,
                  isAdded: product.isInCart,
                  onFavoriteToggle: () {
                    context.read<FavoritesCubit>().toggleFavorite(product.id);
                  },
                  onAddTap: () {
                    context.read<CartCubit>().addToCart(product.id);
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
