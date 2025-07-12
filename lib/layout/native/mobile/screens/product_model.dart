class ProductModel {
  final String name;
  final String thumbnail;
  final int price;
  final bool isFavourite;
  final String about;
  final String unit;
  final int item_id;

  ProductModel({
    required this.name,
    required this.thumbnail,
    required this.price,
    required this.isFavourite,
    required this.about,
    required this.unit,
    required this.item_id
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      price: (json['price'] ?? 0),
      isFavourite: json['isFavourite'] ?? false,
      about: json['about'] ?? '',
      unit: json["unit"]??"pcs",
      item_id: json["id"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': item_id,
      'name': name,
      'thumbnail': thumbnail,
      'price': price,
      'isFavourite': isFavourite ? 1 : 0, // ✅ Convert bool to int
      'about': about,
      'unit': unit,
    };
  }
}
