import '../../../../core/utils/result.dart';
import '../entities/home_section.dart';
import '../repositories/home_repository.dart';

/// Data class returned by the use case
class HomeData {
  final List<Product> products;
  final List<String> categories;

  const HomeData({
    required this.products,
    required this.categories,
  });
}

class GetHomeDataUseCase {
  final HomeRepository _repository;

  GetHomeDataUseCase(this._repository);

  Future<Result<HomeData>> call({String? userId}) async {
    // Load user data first if userId provided
    if (userId != null) {
      await _repository.loadUserData(userId);
    }

    // Get products
    final productsResult = await _repository.getProducts();
    switch (productsResult) {
      case Success(data: final products):
        // Get categories
        final categoriesResult = await _repository.getCategories();
        switch (categoriesResult) {
          case Success(data: final categories):
            return Success(HomeData(
              products: products,
              categories: categories,
            ));
          case Failure(message: final msg):
            return Failure(msg);
        }
      case Failure(message: final msg):
        return Failure(msg);
    }
  }
}
