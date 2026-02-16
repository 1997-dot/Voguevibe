import '../../../../core/utils/result.dart';
import '../../domain/entities/home_section.dart';
import '../../domain/repositories/home_repository.dart';
import '../sources/home_remote_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource _dataSource;

  HomeRepositoryImpl({required HomeDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<Result<List<Product>>> getProducts() async {
    final result = _dataSource.getProducts();
    switch (result) {
      case Success(data: final products):
        // HomeProductModel extends Product, so this is a safe upcast.
        // The proxy objects delegate mutable fields to the underlying
        // ProductModel singleton instances, preserving shared state.
        return Success(List<Product>.from(products));
      case Failure(message: final msg):
        return Failure(msg);
    }
  }

  @override
  Future<Result<List<String>>> getCategories() async {
    return _dataSource.getCategories();
  }

  @override
  Future<Result<void>> loadUserData(String userId) async {
    return _dataSource.loadUserData(userId);
  }

  @override
  void clearUserContext() {
    _dataSource.clearUserContext();
  }
}
