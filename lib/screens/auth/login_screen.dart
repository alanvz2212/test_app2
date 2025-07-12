import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_theme.dart';
import '../home/main_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _dealerIdController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isOtpSent = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    _dealerIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              
              // Logo and Title
              _buildHeader(),
              
              const SizedBox(height: 40),
              
              // Tab Bar
              _buildTabBar(),
              
              const SizedBox(height: 24),
              
              // Tab Views
              SizedBox(
                height: 400,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildCustomerLogin(),
                    _buildDealerLogin(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.layers,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Welcome to ABM4 Laminate',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Sign in to continue',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppTheme.textSecondary,
        tabs: const [
          Tab(text: 'Customer'),
          Tab(text: 'Dealer'),
        ],
      ),
    );
  }

  Widget _buildCustomerLogin() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_isOtpSent) ...[
              // Phone Number Input
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '+91 9876543210',
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Send OTP Button
              ElevatedButton(
                onPressed: authProvider.isLoading ? null : _sendOtp,
                child: authProvider.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Send OTP'),
              ),
            ] else ...[
              // OTP Input
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: 'Enter OTP',
                  hintText: '1234',
                  prefixIcon: Icon(Icons.security),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Verify OTP Button
              ElevatedButton(
                onPressed: authProvider.isLoading ? null : _verifyOtp,
                child: authProvider.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Verify OTP'),
              ),
              
              const SizedBox(height: 16),
              
              // Resend OTP
              TextButton(
                onPressed: _sendOtp,
                child: const Text('Resend OTP'),
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Guest Login
            OutlinedButton(
              onPressed: _continueAsGuest,
              child: const Text('Continue as Guest'),
            ),
            
            // Error Message
            if (authProvider.error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.errorColor),
                ),
                child: Text(
                  authProvider.error!,
                  style: const TextStyle(color: AppTheme.errorColor),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildDealerLogin() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dealer ID Input
            TextFormField(
              controller: _dealerIdController,
              decoration: const InputDecoration(
                labelText: 'Dealer ID',
                hintText: 'Enter your dealer ID',
                prefixIcon: Icon(Icons.business),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Password Input
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Login Button
            ElevatedButton(
              onPressed: authProvider.isLoading ? null : _dealerLogin,
              child: authProvider.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Login'),
            ),
            
            const SizedBox(height: 16),
            
            // Forgot Password
            TextButton(
              onPressed: () {
                // TODO: Implement forgot password
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Contact admin for password reset')),
                );
              },
              child: const Text('Forgot Password?'),
            ),
            
            // Error Message
            if (authProvider.error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.errorColor),
                ),
                child: Text(
                  authProvider.error!,
                  style: const TextStyle(color: AppTheme.errorColor),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  void _sendOtp() async {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter phone number')),
      );
      return;
    }

    // Simulate OTP sending
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isOtpSent = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP sent successfully! Use any 4-digit code for demo.')),
    );
  }

  void _verifyOtp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final success = await authProvider.loginWithPhone(
      _phoneController.text,
      _otpController.text,
    );
    
    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    }
  }

  void _dealerLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final success = await authProvider.loginWithDealerId(
      _dealerIdController.text,
      _passwordController.text,
    );
    
    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    }
  }

  void _continueAsGuest() {
    // For demo purposes, create a guest user
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainNavigation()),
    );
  }
}