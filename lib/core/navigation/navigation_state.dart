import 'app_route.dart';

class NavigationState {
  final AppRoute route;
  final Map<String, dynamic> params;

  const NavigationState({
    required this.route,
    this.params = const {},
  });

  NavigationState copyWith({
    AppRoute? route,
    Map<String, dynamic>? params,
  }) {
    return NavigationState(
      route: route ?? this.route,
      params: params ?? this.params,
    );
  }

  // Helper getters for common params
  int? get productId => params['productId'] as int?;
  int? get categoryId => params['categoryId'] as int?;
  int? get orderId => params['orderId'] as int?;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NavigationState &&
        other.route == route &&
        _mapsEqual(other.params, params);
  }

  @override
  int get hashCode => route.hashCode ^ params.hashCode;

  bool _mapsEqual(Map<String, dynamic> a, Map<String, dynamic> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (a[key] != b[key]) return false;
    }
    return true;
  }
}
