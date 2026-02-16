import '../../../../core/utils/result.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_detail.dart';
import '../../domain/repositories/product_repository.dart';
import '../sources/product_remote_source.dart';

class ProductFeatureRepositoryImpl implements ProductFeatureRepository {
  final ProductDataSource _dataSource;

  ProductFeatureRepositoryImpl({required ProductDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<Result<List<ProductEntity>>> getAllProducts() async {
    final result = _dataSource.getProducts();
    switch (result) {
      case Success(data: final products):
        return Success(List<ProductEntity>.from(products));
      case Failure(message: final msg):
        return Failure(msg);
    }
  }

  @override
  Future<Result<List<ProductEntity>>> getProductsByCategory(
      String category) async {
    final result = _dataSource.getProductsByCategory(category);
    switch (result) {
      case Success(data: final products):
        return Success(List<ProductEntity>.from(products));
      case Failure(message: final msg):
        return Failure(msg);
    }
  }

  @override
  Future<Result<ProductDetailEntity>> getProductById(String id) async {
    final result = _dataSource.getProductById(id);
    switch (result) {
      case Success(data: final product):
        return Success(product);
      case Failure(message: final msg):
        return Failure(msg);
    }
  }

  @override
  Future<Result<List<String>>> getCategories() async {
    return _dataSource.getCategories();
  }
}
