import 'package:get/get.dart';

class CartItemModel {
  final RxInt id;
  final RxString name;
  final RxDouble price;
  final RxString image;
  final RxInt qty;

  CartItemModel({
    required int id,
    required String name,
    required double price,
    required String image,
    int qty = 1,
  })  : id = id.obs,
        name = name.obs,
        price = price.obs,
        image = image.obs,
        qty = qty.obs;

  // Convert to Map for DB storage
  Map<String, dynamic> toJson() => {
    'id': id.value,
    'name': name.value,
    'price': price.value,
    'image': image.value,
    'qty': qty.value,
  };

  // Create from DB record or JSON
  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
    id: json['id'],
    name: json['name'],
    price: json['price'].toDouble(),
    image: json['image'],
    qty: json['qty'],
  );
}

