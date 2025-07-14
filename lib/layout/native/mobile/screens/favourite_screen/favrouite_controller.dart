import 'package:get/get.dart';

import '../commans/database.dart';
import '../product_model.dart';


class FavouriteScreenController extends GetxController {
  // Observable list of favourite products
  final favourites = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavourites();
  }

  /// Load all favourite items from the database
  Future<void> loadFavourites() async {
    final favList = await CartDatabase.getFavourites();

    final products = favList.map((item) => ProductModel(
      name: item["name"],
      thumbnail: item["image"],
      price: item["price"].toInt(),
      isFavourite: true, // always true for favourites
      about: item["about"] ?? '', // fallback if column missing
      unit: item["unit"] ?? 'pcs',
      item_id: item["id"],
    )).toList();

    favourites.assignAll(products);
  }

  /// Remove an item from favourites
  Future<void> removeFromFavourites(int itemId) async {
    await CartDatabase.removeFromFavourites(itemId);
    favourites.removeWhere((p) => p.item_id == itemId);
  }
}
