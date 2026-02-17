import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/result.dart';
import '../../domain/usecases/get_order_history_usecase.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final GetOrderHistoryUseCase _getOrderHistoryUseCase;

  String? _currentUserId;

  ProfileCubit({
    required GetUserProfileUseCase getUserProfileUseCase,
    required GetOrderHistoryUseCase getOrderHistoryUseCase,
  })  : _getUserProfileUseCase = getUserProfileUseCase,
        _getOrderHistoryUseCase = getOrderHistoryUseCase,
        super(ProfileInitial());

  /// Set current user
  void setUser(String? userId) {
    _currentUserId = userId;
  }

  /// Load user profile, then load orders
  Future<void> loadProfile() async {
    if (_currentUserId == null) return;

    final result = await _getUserProfileUseCase();
    switch (result) {
      case Success(data: final userProfile):
        emit(ProfileLoaded(
          userProfile: userProfile,
          isOrdersLoading: true,
        ));
        // Now load orders
        await _loadOrders();
      case Failure(message: final msg):
        emit(ProfileError(msg));
    }
  }

  /// Load order history (internal, updates existing ProfileLoaded state)
  Future<void> _loadOrders() async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    final result =
        await _getOrderHistoryUseCase(userId: _currentUserId!);
    switch (result) {
      case Success(data: final orders):
        emit(currentState.copyWith(
          orders: orders,
          isOrdersLoading: false,
        ));
      case Failure():
        emit(currentState.copyWith(
          orders: [],
          isOrdersLoading: false,
        ));
    }
  }
}
