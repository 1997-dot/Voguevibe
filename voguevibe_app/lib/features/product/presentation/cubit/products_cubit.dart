import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsUseCase _getProductsUseCase;
  final ProductFeatureRepository _productRepository;

  ProductsCubit({
    required GetProductsUseCase getProductsUseCase,
    required ProductFeatureRepository productRepository,
  })  : _getProductsUseCase = getProductsUseCase,
        _productRepository = productRepository,
        super(ProductsInitial());

  /// Load products, optionally filtered by category
  Future<void> loadProducts({String? category}) async {
    emit(ProductsLoading());

    final result = await _getProductsUseCase(category: category);
    switch (result) {
      case Success(data: final products):
        final categoriesResult = await _productRepository.getCategories();
        switch (categoriesResult) {
          case Success(data: final categories):
            emit(ProductsLoaded(
              products: products,
              categories: categories,
              selectedCategory: category,
            ));
          case Failure(message: final msg):
            emit(ProductsError('Failed to load categories: $msg'));
        }
      case Failure(message: final msg):
        emit(ProductsError('Failed to load products: $msg'));
    }
  }

  /// Filter by category (null = show all)
  Future<void> filterByCategory(String? category) async {
    await loadProducts(category: category);
  }
}
