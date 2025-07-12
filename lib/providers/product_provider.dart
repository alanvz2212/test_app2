import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  ProductFilter _currentFilter = ProductFilter();
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _filteredProducts;
  List<Product> get allProducts => _products;
  ProductFilter get currentFilter => _currentFilter;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get unique filter options
  List<String> get collections => 
      _products.map((p) => p.collection).toSet().toList()..sort();
  List<String> get colors => 
      _products.map((p) => p.color).toSet().toList()..sort();
  List<String> get textures => 
      _products.map((p) => p.texture).toSet().toList()..sort();
  List<String> get thicknesses => 
      _products.map((p) => p.thickness).toSet().toList()..sort();

  ProductProvider() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    _setLoading(true);
    try {
      // Simulate API call with demo data
      await Future.delayed(const Duration(seconds: 1));
      _products = _generateDemoProducts();
      _applyFilter();
      _setLoading(false);
    } catch (e) {
      _error = 'Failed to load products';
      _setLoading(false);
    }
  }

  void applyFilter(ProductFilter filter) {
    _currentFilter = filter;
    _applyFilter();
  }

  void clearFilter() {
    _currentFilter = ProductFilter();
    _applyFilter();
  }

  void _applyFilter() {
    _filteredProducts = _products.where((product) {
      // Search query filter
      if (_currentFilter.searchQuery != null && 
          _currentFilter.searchQuery!.isNotEmpty) {
        final query = _currentFilter.searchQuery!.toLowerCase();
        if (!product.name.toLowerCase().contains(query) &&
            !product.code.toLowerCase().contains(query) &&
            !product.description.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Collection filter
      if (_currentFilter.collection != null && 
          _currentFilter.collection!.isNotEmpty &&
          product.collection != _currentFilter.collection) {
        return false;
      }

      // Color filter
      if (_currentFilter.color != null && 
          _currentFilter.color!.isNotEmpty &&
          product.color != _currentFilter.color) {
        return false;
      }

      // Texture filter
      if (_currentFilter.texture != null && 
          _currentFilter.texture!.isNotEmpty &&
          product.texture != _currentFilter.texture) {
        return false;
      }

      // Thickness filter
      if (_currentFilter.thickness != null && 
          _currentFilter.thickness!.isNotEmpty &&
          product.thickness != _currentFilter.thickness) {
        return false;
      }

      // Price range filter
      if (_currentFilter.minPrice != null && 
          product.price < _currentFilter.minPrice!) {
        return false;
      }

      if (_currentFilter.maxPrice != null && 
          product.price > _currentFilter.maxPrice!) {
        return false;
      }

      return true;
    }).toList();

    notifyListeners();
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Product> getRelatedProducts(String productId) {
    final product = getProductById(productId);
    if (product == null) return [];

    return _products.where((p) => 
        p.id != productId && 
        (p.collection == product.collection || 
         p.color == product.color ||
         product.relatedProducts.contains(p.id))
    ).take(4).toList();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  List<Product> _generateDemoProducts() {
    return [
      Product(
        id: '1',
        name: 'Premium Oak Laminate',
        code: 'POL001',
        description: 'High-quality oak finish laminate with natural wood texture',
        collection: 'Premium Wood',
        color: 'Natural Oak',
        texture: 'Wood Grain',
        thickness: '1mm',
        price: 450.0,
        images: [
          'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400',
          'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400',
        ],
        specifications: {
          'Material': 'High Pressure Laminate',
          'Finish': 'Matt',
          'Application': 'Furniture, Interiors',
          'Brand': 'ABM4 Premium',
        },
        createdAt: DateTime.now(),
        relatedProducts: ['2', '3'],
      ),
      Product(
        id: '2',
        name: 'Classic Walnut Laminate',
        code: 'CWL002',
        description: 'Rich walnut finish with deep brown tones',
        collection: 'Classic Wood',
        color: 'Dark Walnut',
        texture: 'Wood Grain',
        thickness: '0.8mm',
        price: 380.0,
        images: [
          'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400',
        ],
        specifications: {
          'Material': 'High Pressure Laminate',
          'Finish': 'Gloss',
          'Application': 'Kitchen, Furniture',
          'Brand': 'ABM4 Classic',
        },
        createdAt: DateTime.now(),
        relatedProducts: ['1', '4'],
      ),
      Product(
        id: '3',
        name: 'Modern White Laminate',
        code: 'MWL003',
        description: 'Clean white finish perfect for modern interiors',
        collection: 'Modern Collection',
        color: 'Pure White',
        texture: 'Smooth',
        thickness: '1mm',
        price: 320.0,
        images: [
          'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400',
        ],
        specifications: {
          'Material': 'High Pressure Laminate',
          'Finish': 'Matt',
          'Application': 'Kitchen, Bathroom',
          'Brand': 'ABM4 Modern',
        },
        createdAt: DateTime.now(),
        relatedProducts: ['5', '6'],
      ),
      Product(
        id: '4',
        name: 'Marble Finish Laminate',
        code: 'MFL004',
        description: 'Elegant marble pattern with realistic texture',
        collection: 'Stone Collection',
        color: 'Carrara White',
        texture: 'Stone',
        thickness: '1.2mm',
        price: 520.0,
        images: [
          'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400',
        ],
        specifications: {
          'Material': 'High Pressure Laminate',
          'Finish': 'Gloss',
          'Application': 'Kitchen, Countertops',
          'Brand': 'ABM4 Stone',
        },
        createdAt: DateTime.now(),
        relatedProducts: ['2', '5'],
      ),
      Product(
        id: '5',
        name: 'Black Granite Laminate',
        code: 'BGL005',
        description: 'Deep black granite finish with speckled pattern',
        collection: 'Stone Collection',
        color: 'Black Granite',
        texture: 'Stone',
        thickness: '1.2mm',
        price: 480.0,
        images: [
          'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400',
        ],
        specifications: {
          'Material': 'High Pressure Laminate',
          'Finish': 'Matt',
          'Application': 'Kitchen, Countertops',
          'Brand': 'ABM4 Stone',
        },
        createdAt: DateTime.now(),
        relatedProducts: ['3', '4'],
      ),
      Product(
        id: '6',
        name: 'Teak Wood Laminate',
        code: 'TWL006',
        description: 'Traditional teak wood finish with natural grain',
        collection: 'Traditional Wood',
        color: 'Golden Teak',
        texture: 'Wood Grain',
        thickness: '0.8mm',
        price: 420.0,
        images: [
          'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400',
        ],
        specifications: {
          'Material': 'High Pressure Laminate',
          'Finish': 'Satin',
          'Application': 'Furniture, Doors',
          'Brand': 'ABM4 Traditional',
        },
        createdAt: DateTime.now(),
        relatedProducts: ['1', '2'],
      ),
    ];
  }
}