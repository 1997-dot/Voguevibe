import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/result.dart';
import '../../domain/usecases/get_product_detail_usecase.dart';
import 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final GetProductDetailUseCase _getProductDetailUseCase;

  ProductDetailCubit({
    required GetProductDetailUseCase getProductDetailUseCase,
  })  : _getProductDetailUseCase = getProductDetailUseCase,
        super(ProductDetailInitial());

  /// Load product detail by ID
  Future<void> loadProductDetail(String productId) async {
    emit(ProductDetailLoading());

    final result = await _getProductDetailUseCase(productId: productId);
    switch (result) {
      case Success(data: final product):
        emit(ProductDetailLoaded(product: product));
      case Failure(message: final msg):
        emit(ProductDetailError('Failed to load product: $msg'));
    }
  }
}
