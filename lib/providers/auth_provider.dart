import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  bool get isDealer => _user?.userType == 'dealer';
  bool get isCustomer => _user?.userType == 'customer';

  AuthProvider() {
    _loadUserFromStorage();
  }

  Future<void> _loadUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson != null) {
        // In a real app, you would parse the JSON and create a User object
        // For now, we'll create a dummy user
        _user = User(
          id: 'demo_user',
          name: 'Demo User',
          email: 'demo@example.com',
          phone: '+91 9876543210',
          userType: 'dealer',
          dealerId: 'D001',
          businessName: 'Demo Laminate Store',
          createdAt: DateTime.now(),
        );
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to load user data';
      notifyListeners();
    }
  }

  Future<bool> loginWithPhone(String phone, String otp) async {
    _setLoading(true);
    _error = null;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // For demo purposes, accept any 4-digit OTP
      if (otp.length == 4) {
        _user = User(
          id: 'demo_user_${phone.substring(phone.length - 4)}',
          name: phone.startsWith('+91 98765') ? 'Demo Dealer' : 'Demo Customer',
          email: 'demo@example.com',
          phone: phone,
          userType: phone.startsWith('+91 98765') ? 'dealer' : 'customer',
          dealerId: phone.startsWith('+91 98765') ? 'D001' : null,
          businessName: phone.startsWith('+91 98765') ? 'Demo Laminate Store' : null,
          createdAt: DateTime.now(),
        );

        await _saveUserToStorage();
        _setLoading(false);
        return true;
      } else {
        _error = 'Invalid OTP';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _error = 'Login failed: ${e.toString()}';
      _setLoading(false);
      return false;
    }
  }

  Future<bool> loginWithDealerId(String dealerId, String password) async {
    _setLoading(true);
    _error = null;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // For demo purposes, accept specific dealer ID and password
      if (dealerId.toLowerCase() == 'demo' && password == 'password') {
        _user = User(
          id: 'demo_dealer',
          name: 'Demo Dealer',
          email: 'dealer@example.com',
          phone: '+91 9876543210',
          userType: 'dealer',
          dealerId: dealerId.toUpperCase(),
          businessName: 'Demo Laminate Store',
          address: '123 Business Street',
          city: 'Mumbai',
          state: 'Maharashtra',
          pincode: '400001',
          createdAt: DateTime.now(),
        );

        await _saveUserToStorage();
        _setLoading(false);
        return true;
      } else {
        _error = 'Invalid dealer ID or password';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _error = 'Login failed: ${e.toString()}';
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    notifyListeners();
  }

  Future<void> updateProfile(User updatedUser) async {
    _setLoading(true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      _user = updatedUser;
      await _saveUserToStorage();
      _setLoading(false);
    } catch (e) {
      _error = 'Failed to update profile';
      _setLoading(false);
    }
  }

  Future<void> _saveUserToStorage() async {
    if (_user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', _user!.toJson().toString());
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}