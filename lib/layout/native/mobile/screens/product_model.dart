class ProductModel {
  final String name;
  final String thumbnail;
  final int price;
  final bool isFavourite;
  final String about;
  final String unit;

  ProductModel({
    required this.name,
    required this.thumbnail,
    required this.price,
    required this.isFavourite,
    required this.about,
    required this.unit
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      price: (json['price'] ?? 0),
      isFavourite: json['isFavourite'] ?? false,
      about: json['about'] ?? '',
      unit: json["unit"]??"pcs",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'thumbnail': thumbnail,
      'price': price,
      'isFavourite': isFavourite,
      'about': about,
    };
  }
}
