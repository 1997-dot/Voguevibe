import 'package:flutter/foundation.dart';

import 'app_route.dart';
import 'navigation_state.dart';

class AppNavigator extends ChangeNotifier {
  final List<NavigationState> _stack = [
    const NavigationState(route: AppRoute.splash),
  ];

  NavigationState get currentState => _stack.last;
  AppRoute get currentRoute => currentState.route;
  Map<String, dynamic> get currentParams => currentState.params;

  bool get canGoBack => _stack.length > 1;

  void goTo(AppRoute route, {Map<String, dynamic> params = const {}}) {
    _stack.add(NavigationState(route: route, params: params));
    notifyListeners();
  }

  void goBack() {
    if (canGoBack) {
      _stack.removeLast();
      notifyListeners();
    }
  }

  void resetTo(AppRoute route, {Map<String, dynamic> params = const {}}) {
    _stack.clear();
    _stack.add(NavigationState(route: route, params: params));
    notifyListeners();
  }

  void replaceWith(AppRoute route, {Map<String, dynamic> params = const {}}) {
    if (_stack.isNotEmpty) {
      _stack.removeLast();
    }
    _stack.add(NavigationState(route: route, params: params));
    notifyListeners();
  }

  void popUntil(AppRoute route) {
    while (_stack.length > 1 && _stack.last.route != route) {
      _stack.removeLast();
    }
    notifyListeners();
  }
}
