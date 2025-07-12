import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  List<Enquiry> _enquiries = [];
  List<OrderItem> _cartItems = [];
  bool _isLoading = false;
  String? _error;

  List<Order> get orders => _orders;
  List<Enquiry> get enquiries => _enquiries;
  List<OrderItem> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  double get cartTotal => _cartItems.fold(0.0, (sum, item) => sum + item.total);
  int get cartItemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  OrderProvider() {
    loadOrders();
    loadEnquiries();
  }

  Future<void> loadOrders() async {
    _setLoading(true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      _orders = _generateDemoOrders();
      _setLoading(false);
    } catch (e) {
      _error = 'Failed to load orders';
      _setLoading(false);
    }
  }

  Future<void> loadEnquiries() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      _enquiries = _generateDemoEnquiries();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load enquiries';
      notifyListeners();
    }
  }

  void addToCart(String productId, String productName, String productCode, 
                 int quantity, double rate) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.productId == productId
    );

    if (existingIndex >= 0) {
      // Update existing item
      final existingItem = _cartItems[existingIndex];
      final newQuantity = existingItem.quantity + quantity;
      _cartItems[existingIndex] = OrderItem(
        productId: productId,
        productName: productName,
        productCode: productCode,
        quantity: newQuantity,
        rate: rate,
        total: newQuantity * rate,
      );
    } else {
      // Add new item
      _cartItems.add(OrderItem(
        productId: productId,
        productName: productName,
        productCode: productCode,
        quantity: quantity,
        rate: rate,
        total: quantity * rate,
      ));
    }
    notifyListeners();
  }

  void updateCartItem(String productId, int quantity) {
    final index = _cartItems.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        final item = _cartItems[index];
        _cartItems[index] = OrderItem(
          productId: item.productId,
          productName: item.productName,
          productCode: item.productCode,
          quantity: quantity,
          rate: item.rate,
          total: quantity * item.rate,
        );
      }
      notifyListeners();
    }
  }

  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  Future<bool> placeOrder(String dealerId, String? notes) async {
    if (_cartItems.isEmpty) return false;

    _setLoading(true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      final order = Order(
        id: 'ORD${DateTime.now().millisecondsSinceEpoch}',
        dealerId: dealerId,
        items: List.from(_cartItems),
        totalAmount: cartTotal,
        status: OrderStatus.pending,
        orderDate: DateTime.now(),
        notes: notes,
        paymentStatus: PaymentStatus.pending,
      );

      _orders.insert(0, order);
      clearCart();
      _setLoading(false);
      return true;
    } catch (e) {
      _error = 'Failed to place order';
      _setLoading(false);
      return false;
    }
  }

  Future<bool> submitEnquiry(String customerId, String customerName, 
                           String customerPhone, String productId, 
                           String productName, String message) async {
    _setLoading(true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final enquiry = Enquiry(
        id: 'ENQ${DateTime.now().millisecondsSinceEpoch}',
        customerId: customerId,
        customerName: customerName,
        customerPhone: customerPhone,
        productId: productId,
        productName: productName,
        message: message,
        status: EnquiryStatus.pending,
        createdAt: DateTime.now(),
      );

      _enquiries.insert(0, enquiry);
      _setLoading(false);
      return true;
    } catch (e) {
      _error = 'Failed to submit enquiry';
      _setLoading(false);
      return false;
    }
  }

  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  List<Order> getOrdersByStatus(OrderStatus status) {
    return _orders.where((order) => order.status == status).toList();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  List<Order> _generateDemoOrders() {
    return [
      Order(
        id: 'ORD001',
        dealerId: 'D001',
        items: [
          OrderItem(
            productId: '1',
            productName: 'Premium Oak Laminate',
            productCode: 'POL001',
            quantity: 50,
            rate: 450.0,
            total: 22500.0,
          ),
          OrderItem(
            productId: '2',
            productName: 'Classic Walnut Laminate',
            productCode: 'CWL002',
            quantity: 30,
            rate: 380.0,
            total: 11400.0,
          ),
        ],
        totalAmount: 33900.0,
        status: OrderStatus.delivered,
        orderDate: DateTime.now().subtract(const Duration(days: 15)),
        deliveryDate: DateTime.now().subtract(const Duration(days: 5)),
        paymentStatus: PaymentStatus.paid,
        paidAmount: 33900.0,
        invoiceUrl: 'https://example.com/invoice/ORD001.pdf',
      ),
      Order(
        id: 'ORD002',
        dealerId: 'D001',
        items: [
          OrderItem(
            productId: '3',
            productName: 'Modern White Laminate',
            productCode: 'MWL003',
            quantity: 100,
            rate: 320.0,
            total: 32000.0,
          ),
        ],
        totalAmount: 32000.0,
        status: OrderStatus.shipped,
        orderDate: DateTime.now().subtract(const Duration(days: 3)),
        paymentStatus: PaymentStatus.partial,
        paidAmount: 16000.0,
      ),
      Order(
        id: 'ORD003',
        dealerId: 'D001',
        items: [
          OrderItem(
            productId: '4',
            productName: 'Marble Finish Laminate',
            productCode: 'MFL004',
            quantity: 25,
            rate: 520.0,
            total: 13000.0,
          ),
        ],
        totalAmount: 13000.0,
        status: OrderStatus.pending,
        orderDate: DateTime.now().subtract(const Duration(days: 1)),
        paymentStatus: PaymentStatus.pending,
      ),
    ];
  }

  List<Enquiry> _generateDemoEnquiries() {
    return [
      Enquiry(
        id: 'ENQ001',
        customerId: 'C001',
        customerName: 'Rajesh Kumar',
        customerPhone: '+91 9876543210',
        productId: '1',
        productName: 'Premium Oak Laminate',
        message: 'I need 200 sq ft of this laminate for my kitchen renovation. What would be the best price?',
        status: EnquiryStatus.responded,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        response: 'Thank you for your enquiry. For 200 sq ft, we can offer a special rate of ₹420 per sq ft. Please contact our dealer for more details.',
        responseDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Enquiry(
        id: 'ENQ002',
        customerId: 'C002',
        customerName: 'Priya Sharma',
        customerPhone: '+91 9876543211',
        productId: '4',
        productName: 'Marble Finish Laminate',
        message: 'Is this suitable for bathroom countertops? What is the water resistance?',
        status: EnquiryStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ];
  }
}