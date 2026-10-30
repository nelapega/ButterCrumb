
class CategoryModel {
  final String id;
  final String name;
  final String? image;
  final String? icon;

  const CategoryModel({
    required this.id,
    required this.name,
    this.image,
    this.icon,
  });

  static const List<CategoryModel> samples = [
    CategoryModel(id: '1', name: 'All'),
    CategoryModel(id: '2', name: 'Cake'),
    CategoryModel(id: '3', name: 'Pastry'),
    CategoryModel(id: '4', name: 'Cookies'),
    CategoryModel(id: '5', name: 'Cupcake'),
  ];
}
