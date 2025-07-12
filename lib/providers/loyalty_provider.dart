import 'package:flutter/material.dart';
import '../models/promotion.dart';

class LoyaltyProvider with ChangeNotifier {
  int _loyaltyPoints = 0;
  List<LoyaltyReward> _rewards = [];
  List<LoyaltyTransaction> _transactions = [];
  List<Promotion> _promotions = [];
  bool _isLoading = false;
  String? _error;

  int get loyaltyPoints => _loyaltyPoints;
  List<LoyaltyReward> get rewards => _rewards;
  List<LoyaltyTransaction> get transactions => _transactions;
  List<Promotion> get promotions => _promotions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<LoyaltyReward> get availableRewards => 
      _rewards.where((reward) => 
          reward.isActive && reward.pointsRequired <= _loyaltyPoints
      ).toList();

  LoyaltyProvider() {
    loadLoyaltyData();
    loadPromotions();
  }

  Future<void> loadLoyaltyData() async {
    _setLoading(true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      _loyaltyPoints = 2500; // Demo points
      _rewards = _generateDemoRewards();
      _transactions = _generateDemoTransactions();
      
      _setLoading(false);
    } catch (e) {
      _error = 'Failed to load loyalty data';
      _setLoading(false);
    }
  }

  Future<void> loadPromotions() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      _promotions = _generateDemoPromotions();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load promotions';
      notifyListeners();
    }
  }

  Future<bool> redeemReward(String rewardId) async {
    final reward = _rewards.firstWhere((r) => r.id == rewardId);
    
    if (_loyaltyPoints < reward.pointsRequired) {
      _error = 'Insufficient points';
      notifyListeners();
      return false;
    }

    _setLoading(true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      _loyaltyPoints -= reward.pointsRequired;
      
      // Add redemption transaction
      final transaction = LoyaltyTransaction(
        id: 'TXN${DateTime.now().millisecondsSinceEpoch}',
        dealerId: 'D001',
        points: -reward.pointsRequired,
        type: TransactionType.redeemed,
        description: 'Redeemed: ${reward.title}',
        date: DateTime.now(),
        rewardId: rewardId,
      );
      
      _transactions.insert(0, transaction);
      _setLoading(false);
      return true;
    } catch (e) {
      _error = 'Failed to redeem reward';
      _setLoading(false);
      return false;
    }
  }

  void addPoints(int points, String description, {String? orderId}) {
    _loyaltyPoints += points;
    
    final transaction = LoyaltyTransaction(
      id: 'TXN${DateTime.now().millisecondsSinceEpoch}',
      dealerId: 'D001',
      points: points,
      type: TransactionType.earned,
      description: description,
      date: DateTime.now(),
      orderId: orderId,
    );
    
    _transactions.insert(0, transaction);
    notifyListeners();
  }

  List<Promotion> getActivePromotions({String? userType}) {
    return _promotions.where((promotion) {
      if (!promotion.isValid) return false;
      if (userType != null && promotion.targetUserType != null && 
          promotion.targetUserType != userType) return false;
      return true;
    }).toList();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  List<LoyaltyReward> _generateDemoRewards() {
    return [
      LoyaltyReward(
        id: 'R001',
        title: '10% Discount Voucher',
        description: 'Get 10% off on your next order',
        imageUrl: 'https://images.unsplash.com/photo-1607083206869-4c7672e72a8a?w=400',
        pointsRequired: 1000,
        type: RewardType.discount,
        discountPercentage: 10.0,
      ),
      LoyaltyReward(
        id: 'R002',
        title: 'Free Sample Kit',
        description: 'Get a free sample kit of premium laminates',
        imageUrl: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400',
        pointsRequired: 500,
        type: RewardType.product,
      ),
      LoyaltyReward(
        id: 'R003',
        title: '₹500 Cashback',
        description: 'Get ₹500 cashback on orders above ₹10,000',
        imageUrl: 'https://images.unsplash.com/photo-1607083206869-4c7672e72a8a?w=400',
        pointsRequired: 2000,
        type: RewardType.cashback,
        cashValue: 500.0,
      ),
      LoyaltyReward(
        id: 'R004',
        title: 'Premium Laminate Sheet',
        description: 'Free premium laminate sheet (4x8 ft)',
        imageUrl: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400',
        pointsRequired: 3000,
        type: RewardType.product,
        productId: '1',
      ),
      LoyaltyReward(
        id: 'R005',
        title: '15% Discount Voucher',
        description: 'Get 15% off on orders above ₹25,000',
        imageUrl: 'https://images.unsplash.com/photo-1607083206869-4c7672e72a8a?w=400',
        pointsRequired: 2500,
        type: RewardType.discount,
        discountPercentage: 15.0,
      ),
    ];
  }

  List<LoyaltyTransaction> _generateDemoTransactions() {
    return [
      LoyaltyTransaction(
        id: 'TXN001',
        dealerId: 'D001',
        points: 339,
        type: TransactionType.earned,
        description: 'Points earned from order ORD001',
        date: DateTime.now().subtract(const Duration(days: 15)),
        orderId: 'ORD001',
      ),
      LoyaltyTransaction(
        id: 'TXN002',
        dealerId: 'D001',
        points: 320,
        type: TransactionType.earned,
        description: 'Points earned from order ORD002',
        date: DateTime.now().subtract(const Duration(days: 3)),
        orderId: 'ORD002',
      ),
      LoyaltyTransaction(
        id: 'TXN003',
        dealerId: 'D001',
        points: -500,
        type: TransactionType.redeemed,
        description: 'Redeemed: Free Sample Kit',
        date: DateTime.now().subtract(const Duration(days: 10)),
        rewardId: 'R002',
      ),
      LoyaltyTransaction(
        id: 'TXN004',
        dealerId: 'D001',
        points: 130,
        type: TransactionType.earned,
        description: 'Points earned from order ORD003',
        date: DateTime.now().subtract(const Duration(days: 1)),
        orderId: 'ORD003',
      ),
      LoyaltyTransaction(
        id: 'TXN005',
        dealerId: 'D001',
        points: 500,
        type: TransactionType.earned,
        description: 'Bonus points for app registration',
        date: DateTime.now().subtract(const Duration(days: 30)),
      ),
    ];
  }

  List<Promotion> _generateDemoPromotions() {
    final now = DateTime.now();
    return [
      Promotion(
        id: 'P001',
        title: 'New Year Special Offer',
        description: 'Get up to 25% off on all premium laminates. Limited time offer!',
        imageUrl: 'https://images.unsplash.com/photo-1607083206869-4c7672e72a8a?w=400',
        startDate: now.subtract(const Duration(days: 5)),
        endDate: now.add(const Duration(days: 25)),
        type: PromotionType.discount,
        targetUserType: 'dealer',
      ),
      Promotion(
        id: 'P002',
        title: 'New Collection Launch',
        description: 'Introducing our latest Stone Collection with realistic marble and granite finishes.',
        imageUrl: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400',
        startDate: now.subtract(const Duration(days: 2)),
        endDate: now.add(const Duration(days: 30)),
        type: PromotionType.newLaunch,
      ),
      Promotion(
        id: 'P003',
        title: 'Bulk Order Scheme',
        description: 'Order 1000+ sq ft and get additional 5% discount + free delivery.',
        imageUrl: 'https://images.unsplash.com/photo-1607083206869-4c7672e72a8a?w=400',
        startDate: now.subtract(const Duration(days: 10)),
        endDate: now.add(const Duration(days: 20)),
        type: PromotionType.scheme,
        targetUserType: 'dealer',
      ),
      Promotion(
        id: 'P004',
        title: 'Free Home Consultation',
        description: 'Book a free consultation with our design experts for your home renovation.',
        imageUrl: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400',
        startDate: now.subtract(const Duration(days: 1)),
        endDate: now.add(const Duration(days: 45)),
        type: PromotionType.general,
        targetUserType: 'customer',
      ),
    ];
  }
}