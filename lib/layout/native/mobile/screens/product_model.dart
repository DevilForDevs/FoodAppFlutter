import 'package:get/get.dart';

class ProductModel {
  final String name;
  final String thumbnail;
  final int price;
  final String about;
  final String unit;
  final int item_id;

  // 👇 Observable field
  final RxBool isFavourite;

  ProductModel({
    required this.name,
    required this.thumbnail,
    required this.price,
    required bool isFavourite, // Accepts normal bool
    required this.about,
    required this.unit,
    required this.item_id,
  }) : isFavourite = isFavourite.obs; // Converts to observable

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      price: json['price'] ?? 0,
      isFavourite: (json['isFavourite'] ?? 0) == 1,
      about: json['about'] ?? '',
      unit: json['unit'] ?? 'pcs',
      item_id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': item_id,
      'name': name,
      'thumbnail': thumbnail,
      'price': price,
      'isFavourite': isFavourite.value ? 1 : 0,
      'about': about,
      'unit': unit,
    };
  }
}
