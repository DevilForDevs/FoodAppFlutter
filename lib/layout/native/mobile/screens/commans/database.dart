import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../address_model.dart';
import '../product_model.dart';

class DatabaseHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  static Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE items (
            id INTEGER PRIMARY KEY,
            name TEXT,
            thumbnail TEXT,
            price INTEGER,
            isFavourite INTEGER,
            about TEXT,
            unit TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE cart (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT,
            item_id INTEGER,
            quantity INTEGER,
            price INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT,
            address TEXT,
            item_id INTEGER,
            phone TEXT,
            quantity INTEGER,
            price INTEGER,
            method TEXT,
            status TEXT,
            created_at TEXT
          )
        ''');

        await db.execute('''
       CREATE TABLE addresses (
       address_id INTEGER PRIMARY KEY,
       user_id INTEGER,
       city TEXT,
       street TEXT,
       pincode TEXT,
       building TEXT,
       longAddress TEXT,
       addressType TEXT
       )
        ''');
      },
    );
  }

  // ---------- ITEM TABLE ----------

  static Future<void> insertProduct(ProductModel product) async {
    final db = await database;
    await db.insert(
      'items',
      product.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<ProductModel?> getItemById(int id) async {
    final db = await database;
    final result = await db.query('items', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return ProductModel.fromJson(result.first);
    }
    return null;
  }

  static Future<List<ProductModel>> getAllItems() async {
    final db = await database;
    final result = await db.query('items');
    return result.map((e) => ProductModel.fromJson(e)).toList();
  }

  // ---------- CART TABLE ----------

  static Future<void> insertCartItem({
    required String userId,
    required int itemId,
    required int quantity,
    required int price,
  }) async {
    final db = await database;
    await db.insert('cart', {
      'user_id': userId,
      'item_id': itemId,
      'quantity': quantity,
      'price': price,
    });
  }

  static Future<List<Map<String, dynamic>>> getCartWithProduct() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT cart.*, items.name, items.thumbnail, items.unit
      FROM cart
      JOIN items ON cart.item_id = items.id
    ''');
  }

  static Future<void> clearCart() async {
    final db = await database;
    await db.delete('cart');
  }

  // ---------- ORDER TABLE ----------

  static Future<void> insertOrderItem({
    required String userId,
    required String address,
    required int itemId,
    required String phone,
    required int quantity,
    required int price,
    required String method,
    required String status,
    required String createdAt,
  }) async {
    final db = await database;
    final inserted=await db.insert('orders', {
      'user_id': userId,
      'address': address,
      'item_id': itemId,
      'phone': phone,
      'quantity': quantity,
      'price': price,
      'method': method,
      'status': status,
      'created_at': createdAt,
    });
    if(inserted==0){
      print("failed to inset");
    }
  }

  static Future<List<Map<String, dynamic>>> getOrdersWithProduct() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT orders.*, items.name, items.thumbnail, items.unit
      FROM orders
      JOIN items ON orders.item_id = items.id
    ''');
  }
  static Future<void> insertAddress(AddressModel address) async {
    final db = await database;
    await db.insert('addresses', {
      'address_id': address.addressId.value,
      'user_id': address.userId.value,
      'city': address.city.value,
      'street': address.street.value,
      'pincode': address.pincode.value,
      'building': address.building.value,
      'longAddress': address.longAddress.value,
      'addressType': address.addressType.value,
    });
  }
  static Future<List<AddressModel>> getAllAddresses() async {
    final db = await database;
    final result = await db.query('addresses');
    return result.map((json) => AddressModel.fromJson(json)).toList();
  }

  static Future<void> clearOrders() async {
    final db = await database;
    await db.delete('orders');
  }
}
