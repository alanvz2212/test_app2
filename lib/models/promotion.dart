class Promotion {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final String? targetUserType; // 'dealer', 'customer', or null for both
  final String? actionUrl;
  final PromotionType type;

  Promotion({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
    this.targetUserType,
    this.actionUrl,
    this.type = PromotionType.general,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(json['endDate'] ?? DateTime.now().toIso8601String()),
      isActive: json['isActive'] ?? true,
      targetUserType: json['targetUserType'],
      actionUrl: json['actionUrl'],
      type: PromotionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => PromotionType.general,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
      'targetUserType': targetUserType,
      'actionUrl': actionUrl,
      'type': type.toString().split('.').last,
    };
  }

  bool get isValid {
    final now = DateTime.now();
    return isActive && now.isAfter(startDate) && now.isBefore(endDate);
  }
}

enum PromotionType {
  general,
  discount,
  newLaunch,
  scheme,
  seasonal
}

class LoyaltyReward {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int pointsRequired;
  final bool isActive;
  final RewardType type;
  final String? productId;
  final double? discountPercentage;
  final double? cashValue;

  LoyaltyReward({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.pointsRequired,
    this.isActive = true,
    this.type = RewardType.product,
    this.productId,
    this.discountPercentage,
    this.cashValue,
  });

  factory LoyaltyReward.fromJson(Map<String, dynamic> json) {
    return LoyaltyReward(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      pointsRequired: json['pointsRequired'] ?? 0,
      isActive: json['isActive'] ?? true,
      type: RewardType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => RewardType.product,
      ),
      productId: json['productId'],
      discountPercentage: json['discountPercentage']?.toDouble(),
      cashValue: json['cashValue']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'pointsRequired': pointsRequired,
      'isActive': isActive,
      'type': type.toString().split('.').last,
      'productId': productId,
      'discountPercentage': discountPercentage,
      'cashValue': cashValue,
    };
  }
}

enum RewardType {
  product,
  discount,
  cashback,
  voucher
}

class LoyaltyTransaction {
  final String id;
  final String dealerId;
  final int points;
  final TransactionType type;
  final String description;
  final DateTime date;
  final String? orderId;
  final String? rewardId;

  LoyaltyTransaction({
    required this.id,
    required this.dealerId,
    required this.points,
    required this.type,
    required this.description,
    required this.date,
    this.orderId,
    this.rewardId,
  });

  factory LoyaltyTransaction.fromJson(Map<String, dynamic> json) {
    return LoyaltyTransaction(
      id: json['id'] ?? '',
      dealerId: json['dealerId'] ?? '',
      points: json['points'] ?? 0,
      type: TransactionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => TransactionType.earned,
      ),
      description: json['description'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      orderId: json['orderId'],
      rewardId: json['rewardId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dealerId': dealerId,
      'points': points,
      'type': type.toString().split('.').last,
      'description': description,
      'date': date.toIso8601String(),
      'orderId': orderId,
      'rewardId': rewardId,
    };
  }
}

enum TransactionType {
  earned,
  redeemed,
  expired
}