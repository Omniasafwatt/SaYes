import 'package:flutter/widgets.dart';

/// A service category as the backend would return it — id + display name +
/// a cover image + an icon. Real categories are entirely admin-managed; the
/// app never hard-codes which categories exist (per the project brief),
/// only how to render one once it arrives. [icon] is a presentation
/// fallback for the rare spot (Home's small category row) too cramped for
/// [imageAsset].
class CategoryModel {
  const CategoryModel({required this.id, required this.name, required this.icon, required this.imageAsset});

  final String id;
  final String name;
  final IconData icon;
  final String imageAsset;
}

class CityModel {
  const CityModel({required this.id, required this.name, required this.vendorCount});

  final String id;
  final String name;
  final int vendorCount;
}
