class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String userType; // 'dealer' or 'customer'
  final String? dealerId;
  final String? businessName;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final bool isActive;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    this.dealerId,
    this.businessName,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.isActive = true,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      userType: json['userType'] ?? 'customer',
      dealerId: json['dealerId'],
      businessName: json['businessName'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'userType': userType,
      'dealerId': dealerId,
      'businessName': businessName,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? userType,
    String? dealerId,
    String? businessName,
    String? address,
    String? city,
    String? state,
    String? pincode,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      userType: userType ?? this.userType,
      dealerId: dealerId ?? this.dealerId,
      businessName: businessName ?? this.businessName,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}