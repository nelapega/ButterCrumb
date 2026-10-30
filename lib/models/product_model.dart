
class ProductModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final String image;
  final double price;
  final double rating;
  final bool isPopular;
  final int stock;

  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.image,
    required this.price,
    this.rating = 4.8,
    this.isPopular = false,
    this.stock = 15,
  });

  ProductModel copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    String? image,
    double? price,
    double? rating,
    bool? isPopular,
    int? stock,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      isPopular: isPopular ?? this.isPopular,
      stock: stock ?? this.stock,
    );
  }

  static const List<ProductModel> samples = [
    ProductModel(
      id: '1',
      name: 'Chocolate Cake',
      category: 'Cake',
      description: 'Rich chocolate cake with creamy ganache.',
      image:
          'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600',
      price: 85000,
      rating: 4.9,
      isPopular: true,
      stock: 12,
    ),
    ProductModel(
      id: '2',
      name: 'Strawberry Cake',
      category: 'Cake',
      description: 'Soft cake with fresh strawberry topping.',
      image:
          'https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=600',
      price: 95000,
      rating: 4.8,
      isPopular: true,
      stock: 8,
    ),
    ProductModel(
      id: '3',
      name: 'Butter Croissant',
      category: 'Pastry',
      description: 'Flaky, buttery, freshly baked croissant.',
      image:
          'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=600',
      price: 18000,
      rating: 4.7,
      isPopular: true,
      stock: 20,
    ),
    ProductModel(
      id: '4',
      name: 'Chocolate Cookies',
      category: 'Cookies',
      description: 'Crunchy cookies with chocolate chips.',
      image:
          'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=600',
      price: 25000,
      rating: 4.8,
      stock: 15,
    ),
    ProductModel(
      id: '5',
      name: 'Cinnamon Roll',
      category: 'Pastry',
      description: 'Soft cinnamon roll with sweet glaze.',
      image:
          'https://images.unsplash.com/photo-1509365465985-25d11c17e812?w=600',
      price: 22000,
      rating: 4.7,
      stock: 10,
    ),
    ProductModel(
      id: '6',
      name: 'Vanilla Cupcake',
      category: 'Cupcake',
      description: 'Vanilla cupcake with smooth buttercream.',
      image:
          'https://images.unsplash.com/photo-1486427944299-d1955d23e34d?w=600',
      price: 15000,
      rating: 4.9,
      stock: 18,
    ),
  ];
}
