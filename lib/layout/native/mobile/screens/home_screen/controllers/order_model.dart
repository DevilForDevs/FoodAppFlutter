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
  final String image_url;
  final String name;
  final int orderId;
  final String unit;

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
    required this.image_url,
    required this.name,
    required this.orderId,
    required this.unit


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
      image_url: json['image_url'],
      name: json['name'],
      orderId: json["order_id"],
      unit: json["unit"]
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

/*{order_id: 4, user_id: 7, address: 1, item: 1, phone: 7632975366, quantity: 1, price: 15.00, method: cod, status: confirmed, created_at: 2025-07-11 10:22:54, updated_at: 2025-07-11 10:22:54, name: Samosa, image_url: https://jalebi.shop/public/productImages/samose.jpg}*/
