import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/appbar.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/favorites_state.dart';
import '../widgets/favorite_item_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesCubit>().loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Column(
        children: [
          // Fixed AppBar
          CustomFlexibleAppBar(
            height: 90,
            leadingIcon: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.alabasterGrey,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: 'My Favourites',
            actionImage: const SizedBox(width: 24),
          ),

          // Scrollable favorites list
          Expanded(
            child: BlocBuilder<FavoritesCubit, FavoritesState>(
              builder: (context, state) {
                if (state is FavoritesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.raspberryPlum,
                    ),
                  );
                }

                if (state is FavoritesError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: AppColors.white),
                    ),
                  );
                }

                if (state is FavoritesLoaded) {
                  if (state.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            color: AppColors.alabasterGrey,
                            size: 64,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No favourites yet',
                            style: TextStyle(
                              color: AppColors.alabasterGrey,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return BlocBuilder<CartCubit, CartState>(
                    builder: (context, cartState) {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        itemCount: state.favoriteProducts.length,
                        itemBuilder: (context, index) {
                          final product = state.favoriteProducts[index];
                          final isInCart =
                              context.read<CartCubit>().isInCart(product.id);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: FavoriteProductHighlightCard(
                              imageUrl: product.thumbnail,
                              productName: product.title,
                              productPrice:
                                  '\$${product.price.toStringAsFixed(0)}',
                              isInCart: isInCart,
                              onButtonPressed: () {
                                final cartCubit = context.read<CartCubit>();
                                if (isInCart) {
                                  cartCubit.removeFromCart(product.id);
                                } else {
                                  cartCubit.addToCart(product.id);
                                }
                              },
                              onRemoveFromFavorites: () {
                                context
                                    .read<FavoritesCubit>()
                                    .toggleFavorite(product.id);
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
