class ApiConstants {
  ApiConstants._();

  // Base URL
  static const String baseUrl = 'https://mock.clothing.api';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Header Keys
  static const String authorizationHeader = 'Authorization';
  static const String contentTypeHeader = 'Content-Type';
  static const String contentTypeJson = 'application/json';

  // Auth Endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String profile = '/auth/profile';

  // Home Endpoint
  static const String home = '/home';

  // Categories Endpoint
  static const String categories = '/categories';

  // Products Endpoints
  static const String products = '/products';
  static String productDetail(int id) => '/products/$id';

  // Favorites Endpoints
  static const String favorites = '/favorites';
  static const String favoritesToggle = '/favorites/toggle';

  // Cart Endpoints
  static const String cart = '/cart';
  static const String cartAdd = '/cart/add';

  // Checkout & Orders Endpoints
  static const String checkout = '/checkout';
  static const String orders = '/orders';
}
