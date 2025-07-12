class Product {
  final String id;
  final String name;
  final String code;
  final String description;
  final String collection;
  final String color;
  final String texture;
  final String thickness;
  final double price;
  final List<String> images;
  final Map<String, dynamic> specifications;
  final bool isActive;
  final DateTime createdAt;
  final List<String> relatedProducts;

  Product({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.collection,
    required this.color,
    required this.texture,
    required this.thickness,
    required this.price,
    required this.images,
    required this.specifications,
    this.isActive = true,
    required this.createdAt,
    this.relatedProducts = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      collection: json['collection'] ?? '',
      color: json['color'] ?? '',
      texture: json['texture'] ?? '',
      thickness: json['thickness'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      specifications: Map<String, dynamic>.from(json['specifications'] ?? {}),
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      relatedProducts: List<String>.from(json['relatedProducts'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'collection': collection,
      'color': color,
      'texture': texture,
      'thickness': thickness,
      'price': price,
      'images': images,
      'specifications': specifications,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'relatedProducts': relatedProducts,
    };
  }
}

class ProductFilter {
  final String? collection;
  final String? color;
  final String? texture;
  final String? thickness;
  final double? minPrice;
  final double? maxPrice;
  final String? searchQuery;

  ProductFilter({
    this.collection,
    this.color,
    this.texture,
    this.thickness,
    this.minPrice,
    this.maxPrice,
    this.searchQuery,
  });

  ProductFilter copyWith({
    String? collection,
    String? color,
    String? texture,
    String? thickness,
    double? minPrice,
    double? maxPrice,
    String? searchQuery,
  }) {
    return ProductFilter(
      collection: collection ?? this.collection,
      color: color ?? this.color,
      texture: texture ?? this.texture,
      thickness: thickness ?? this.thickness,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}