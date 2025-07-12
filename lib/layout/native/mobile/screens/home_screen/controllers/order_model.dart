class OrderModel {
  final String userId;
  final String address;
  final String item;
  final String contact;
  final int quantity;
  final int price;
  final String method;
  final String status;
  final String? createdAt;

  OrderModel({
    required this.userId,
    required this.address,
    required this.item,
    required this.contact,
    required this.quantity,
    required this.price,
    required this.method,
    required this.status,
    this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      userId: json['user_id'].toString(),
      address: json['address'].toString(),
      item: json['item'].toString(),
      contact: json['phone'] ?? json['contact'] ?? '',
      quantity: json['quantity'] is int ? json['quantity'] : int.tryParse(json['quantity'].toString()) ?? 0,
      price: json['price'] is int ? json['price'] : int.tryParse(json['price'].toString()) ?? 0,
      method: json['method'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'address': address,
      'item': item,
      'contact': contact,
      'quantity': quantity,
      'price': price,
      'method': method,
      'status': status,
      'created_at': createdAt,
    };
  }
}
