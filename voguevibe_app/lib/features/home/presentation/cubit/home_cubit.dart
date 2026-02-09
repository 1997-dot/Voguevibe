import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/repositories/product_repository.dart';
import '../../../../data/managers/user_data_manager.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ProductRepository _repository = ProductRepository();
  final UserDataManager _userDataManager = UserDataManager();

  String? _currentUserId;

  HomeCubit() : super(HomeInitial());

  /// Load products and set user context
  Future<void> loadProducts({String? userId}) async {
    emit(HomeLoading());

    try {
      _currentUserId = userId;

      // Load user-specific data if userId is provided
      if (userId != null) {
        await _loadUserData(userId);
      }

      final products = _repository.getAllProducts();
      final categories = _repository.getCategories();

      emit(HomeLoaded(
        allProducts: products,
        categories: categories,
      ));
    } catch (e) {
      emit(HomeError('Failed to load products: ${e.toString()}'));
    }
  }

  /// Load user-specific data (favorites and cart)
  Future<void> _loadUserData(String userId) async {
    try {
      // Load favorites
      final favorites = await _userDataManager.getUserFavorites(userId);
      for (var product in _repository.getAllProducts()) {
        product.isFavorite = favorites.contains(product.id);
      }

      // Load cart
      final cart = await _userDataManager.getUserCart(userId);
      for (var product in _repository.getAllProducts()) {
        if (cart.containsKey(product.id)) {
          product.isInCart = true;
          product.cartQuantity = cart[product.id]!;
        } else {
          product.isInCart = false;
          product.cartQuantity = 0;
        }
      }
    } catch (e) {
      // Continue loading even if user data fails
      print('Failed to load user data: $e');
    }
  }

  /// Refresh products (useful after auth changes)
  Future<void> refresh() async {
    await loadProducts(userId: _currentUserId);
  }

  /// Clear user context (on logout)
  void clearUserContext() {
    _currentUserId = null;
    for (var product in _repository.getAllProducts()) {
      product.isFavorite = false;
      product.isInCart = false;
      product.cartQuantity = 0;
    }
    // Re-emit current state with cleared data
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(HomeLoaded(
        allProducts: _repository.getAllProducts(),
        categories: currentState.categories,
      ));
    }
  }
}
