import 'package:flutter/foundation.dart';

import 'app_route.dart';

class TabNavigator extends ChangeNotifier {
  AppTab _currentTab = AppTab.home;

  AppTab get currentTab => _currentTab;
  int get currentIndex => _currentTab.index;

  void setTab(AppTab tab) {
    if (_currentTab != tab) {
      _currentTab = tab;
      notifyListeners();
    }
  }

  void setTabByIndex(int index) {
    if (index >= 0 && index < AppTab.values.length) {
      setTab(AppTab.values[index]);
    }
  }

  void goToHome() => setTab(AppTab.home);
  void goToCategories() => setTab(AppTab.categories);
  void goToCart() => setTab(AppTab.cart);
  void goToFavorites() => setTab(AppTab.favorites);
  void goToProfile() => setTab(AppTab.profile);
}
