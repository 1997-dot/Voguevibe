import 'package:equatable/equatable.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/user_profile.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ProfileInitial extends ProfileState {}

/// Profile loaded with user info, orders loading separately
class ProfileLoaded extends ProfileState {
  final UserProfile userProfile;
  final List<Order> orders;
  final bool isOrdersLoading;

  const ProfileLoaded({
    required this.userProfile,
    this.orders = const [],
    this.isOrdersLoading = false,
  });

  @override
  List<Object?> get props => [userProfile, orders, isOrdersLoading];

  bool get hasOrders => orders.isNotEmpty;

  ProfileLoaded copyWith({
    UserProfile? userProfile,
    List<Order>? orders,
    bool? isOrdersLoading,
  }) {
    return ProfileLoaded(
      userProfile: userProfile ?? this.userProfile,
      orders: orders ?? this.orders,
      isOrdersLoading: isOrdersLoading ?? this.isOrdersLoading,
    );
  }
}

/// Error state
class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
