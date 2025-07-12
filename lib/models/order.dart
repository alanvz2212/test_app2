class Order {
  final String id;
  final String dealerId;
  final List<OrderItem> items;
  final double totalAmount;
  final OrderStatus status;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String? notes;
  final String? invoiceUrl;
  final PaymentStatus paymentStatus;
  final double? paidAmount;

  Order({
    required this.id,
    required this.dealerId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    this.deliveryDate,
    this.notes,
    this.invoiceUrl,
    this.paymentStatus = PaymentStatus.pending,
    this.paidAmount,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      dealerId: json['dealerId'] ?? '',
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => OrderItem.fromJson(item))
          .toList() ?? [],
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      orderDate: DateTime.parse(json['orderDate'] ?? DateTime.now().toIso8601String()),
      deliveryDate: json['deliveryDate'] != null 
          ? DateTime.parse(json['deliveryDate']) 
          : null,
      notes: json['notes'],
      invoiceUrl: json['invoiceUrl'],
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['paymentStatus'],
        orElse: () => PaymentStatus.pending,
      ),
      paidAmount: json['paidAmount']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dealerId': dealerId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status.toString().split('.').last,
      'orderDate': orderDate.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
      'notes': notes,
      'invoiceUrl': invoiceUrl,
      'paymentStatus': paymentStatus.toString().split('.').last,
      'paidAmount': paidAmount,
    };
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final String productCode;
  final int quantity;
  final double rate;
  final double total;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.productCode,
    required this.quantity,
    required this.rate,
    required this.total,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      productCode: json['productCode'] ?? '',
      quantity: json['quantity'] ?? 0,
      rate: (json['rate'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productCode': productCode,
      'quantity': quantity,
      'rate': rate,
      'total': total,
    };
  }
}

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled
}

enum PaymentStatus {
  pending,
  partial,
  paid,
  overdue
}

class Enquiry {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String productId;
  final String productName;
  final String message;
  final EnquiryStatus status;
  final DateTime createdAt;
  final String? response;
  final DateTime? responseDate;

  Enquiry({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.productId,
    required this.productName,
    required this.message,
    required this.status,
    required this.createdAt,
    this.response,
    this.responseDate,
  });

  factory Enquiry.fromJson(Map<String, dynamic> json) {
    return Enquiry(
      id: json['id'] ?? '',
      customerId: json['customerId'] ?? '',
      customerName: json['customerName'] ?? '',
      customerPhone: json['customerPhone'] ?? '',
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      message: json['message'] ?? '',
      status: EnquiryStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => EnquiryStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      response: json['response'],
      responseDate: json['responseDate'] != null 
          ? DateTime.parse(json['responseDate']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'productId': productId,
      'productName': productName,
      'message': message,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'response': response,
      'responseDate': responseDate?.toIso8601String(),
    };
  }
}

enum EnquiryStatus {
  pending,
  responded,
  closed
}