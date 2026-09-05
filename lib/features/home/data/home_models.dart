import 'package:flutter/widgets.dart';

/// A service category as the backend would return it — id + display name +
/// an icon. Real categories are entirely admin-managed; the app never
/// hard-codes which categories exist (per the project brief), only how to
/// render one once it arrives. [icon] is a presentation fallback for
/// categories that don't ship an image from the backend.
class CategoryModel {
  const CategoryModel({required this.id, required this.name, required this.icon});

  final String id;
  final String name;
  final IconData icon;
}

class CityModel {
  const CityModel({required this.id, required this.name, required this.vendorCount});

  final String id;
  final String name;
  final int vendorCount;
}
