import 'package:flutter/material.dart';

import '../core/navigation/app_route.dart';
import '../core/navigation/tab_navigator.dart';
import 'di.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final TabNavigator _tabNavigator = getIt<TabNavigator>();

  @override
  void initState() {
    super.initState();
    _tabNavigator.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabNavigator.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildTabContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabNavigator.currentIndex,
        onTap: _tabNavigator.setTabByIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_tabNavigator.currentTab) {
      case AppTab.home:
        // TODO: Return HomePage when UI is ready
        return const _PlaceholderTab(title: 'Home');

      case AppTab.categories:
        // TODO: Return CategoriesPage when UI is ready
        return const _PlaceholderTab(title: 'Categories');

      case AppTab.cart:
        // TODO: Return CartPage when UI is ready
        return const _PlaceholderTab(title: 'Cart');

      case AppTab.favorites:
        // TODO: Return FavoritesPage when UI is ready
        return const _PlaceholderTab(title: 'Favorites');

      case AppTab.profile:
        // TODO: Return ProfilePage when UI is ready
        return const _PlaceholderTab(title: 'Profile');
    }
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String title;

  const _PlaceholderTab({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}
