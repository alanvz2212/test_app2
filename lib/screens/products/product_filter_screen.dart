import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../utils/app_theme.dart';
import '../../models/product.dart';

class ProductFilterScreen extends StatefulWidget {
  const ProductFilterScreen({super.key});

  @override
  State<ProductFilterScreen> createState() => _ProductFilterScreenState();
}

class _ProductFilterScreenState extends State<ProductFilterScreen> {
  late ProductFilter _filter;
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    _filter = productProvider.currentFilter;
    
    if (_filter.minPrice != null) {
      _minPriceController.text = _filter.minPrice!.toStringAsFixed(0);
    }
    if (_filter.maxPrice != null) {
      _maxPriceController.text = _filter.maxPrice!.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Products'),
        actions: [
          TextButton(
            onPressed: _clearFilters,
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFilterSection(
                  'Collection',
                  productProvider.collections,
                  _filter.collection,
                  (value) => setState(() => _filter = _filter.copyWith(collection: value)),
                ),
                const SizedBox(height: 24),
                _buildFilterSection(
                  'Color',
                  productProvider.colors,
                  _filter.color,
                  (value) => setState(() => _filter = _filter.copyWith(color: value)),
                ),
                const SizedBox(height: 24),
                _buildFilterSection(
                  'Texture',
                  productProvider.textures,
                  _filter.texture,
                  (value) => setState(() => _filter = _filter.copyWith(texture: value)),
                ),
                const SizedBox(height: 24),
                _buildFilterSection(
                  'Thickness',
                  productProvider.thicknesses,
                  _filter.thickness,
                  (value) => setState(() => _filter = _filter.copyWith(thickness: value)),
                ),
                const SizedBox(height: 24),
                _buildPriceRangeSection(),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _clearFilters,
                child: const Text('Clear'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _applyFilters,
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> options,
    String? selectedValue,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // "All" option
            FilterChip(
              label: const Text('All'),
              selected: selectedValue == null,
              onSelected: (selected) {
                if (selected) {
                  onChanged(null);
                }
              },
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
            ),
            // Individual options
            ...options.map((option) => FilterChip(
              label: Text(option),
              selected: selectedValue == option,
              onSelected: (selected) {
                onChanged(selected ? option : null);
              },
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Price Range (₹)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _minPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Min Price',
                  hintText: '0',
                  prefixText: '₹',
                ),
                onChanged: (value) {
                  final price = double.tryParse(value);
                  setState(() {
                    _filter = _filter.copyWith(minPrice: price);
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _maxPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Max Price',
                  hintText: '1000',
                  prefixText: '₹',
                ),
                onChanged: (value) {
                  final price = double.tryParse(value);
                  setState(() {
                    _filter = _filter.copyWith(maxPrice: price);
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Quick price range buttons
        Wrap(
          spacing: 8,
          children: [
            _buildPriceRangeChip('Under ₹300', null, 300),
            _buildPriceRangeChip('₹300-₹500', 300, 500),
            _buildPriceRangeChip('₹500-₹700', 500, 700),
            _buildPriceRangeChip('Above ₹700', 700, null),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceRangeChip(String label, double? min, double? max) {
    final isSelected = _filter.minPrice == min && _filter.maxPrice == max;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _filter = _filter.copyWith(minPrice: min, maxPrice: max);
            _minPriceController.text = min?.toStringAsFixed(0) ?? '';
            _maxPriceController.text = max?.toStringAsFixed(0) ?? '';
          });
        }
      },
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryColor,
    );
  }

  void _clearFilters() {
    setState(() {
      _filter = ProductFilter();
      _minPriceController.clear();
      _maxPriceController.clear();
    });
  }

  void _applyFilters() {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.applyFilter(_filter);
    Navigator.pop(context);
  }
}