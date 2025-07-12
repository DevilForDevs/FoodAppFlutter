import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class CartDatabase {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;

    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'cart.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cart (
            id INTEGER PRIMARY KEY,
            name TEXT,
            image TEXT,
            price REAL,
            qty INTEGER
          )
        ''');
      },
    );

    return _db!;
  }

  static Future<void> insertOrUpdateCartItem({
    required int id,
    required String name,
    required String image,
    required double price,
    required int quantity,
  }) async {
    final db = await database;

    // Check if item exists
    final existing = await db.query(
      'cart',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (existing.isNotEmpty) {
      // Update qty
      final currentQty = existing.first['qty'] as int;
      await db.update(
        'cart',
        {'qty': currentQty + quantity},
        where: 'id = ?',
        whereArgs: [id],
      );
    } else {
      // Insert new
      await db.insert('cart', {
        'id': id,
        'name': name,
        'image': image,
        'price': price,
        'qty': quantity,
      });
    }
  }

  static Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await database;
    return await db.query('cart');
  }

  static Future<void> clearCart() async {
    final db = await database;
    await db.delete('cart');
  }
}

