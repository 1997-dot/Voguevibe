import 'home_section_model.dart';

/// DTO wrapping products and categories for the home feature.
class HomeDataModel {
  final List<HomeProductModel> products;
  final List<String> categories;

  const HomeDataModel({
    required this.products,
    required this.categories,
  });
}
