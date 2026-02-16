import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_home_data_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;
  final GetHomeDataUseCase _getHomeDataUseCase;

  String? _currentUserId;

  HomeCubit({
    required HomeRepository homeRepository,
    required GetHomeDataUseCase getHomeDataUseCase,
  })  : _homeRepository = homeRepository,
        _getHomeDataUseCase = getHomeDataUseCase,
        super(HomeInitial());

  /// Load products and set user context
  Future<void> loadProducts({String? userId}) async {
    emit(HomeLoading());

    _currentUserId = userId;

    final result = await _getHomeDataUseCase(userId: userId);
    switch (result) {
      case Success(data: final homeData):
        emit(HomeLoaded(
          allProducts: homeData.products,
          categories: homeData.categories,
        ));
      case Failure(message: final msg):
        emit(HomeError('Failed to load products: $msg'));
    }
  }

  /// Refresh products (useful after auth changes)
  Future<void> refresh() async {
    await loadProducts(userId: _currentUserId);
  }

  /// Clear user context (on logout)
  void clearUserContext() {
    _currentUserId = null;
    _homeRepository.clearUserContext();

    // Re-emit current state with cleared data
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(HomeLoaded(
        allProducts: currentState.allProducts,
        categories: currentState.categories,
      ));
    }
  }
}
