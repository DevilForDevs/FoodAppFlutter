import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../chat_screen/chat_controller.dart';

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
        // Create cart table
        await db.execute('''
          CREATE TABLE cart (
            id INTEGER PRIMARY KEY,
            name TEXT,
            image TEXT,
            price REAL,
            qty INTEGER
          )
        ''');

        // Create favourites table
        await db.execute('''
          CREATE TABLE favourites (
            id INTEGER PRIMARY KEY,
            name TEXT,
            image TEXT,
            price REAL,
            about TEXT
          )
        ''');

        await db.execute('''
         CREATE TABLE chat (
            chat_id INTEGER PRIMARY KEY AUTOINCREMENT,
            text TEXT,
            is_user INTEGER,
            is_seen INTEGER,
            timestamp TEXT
           )
         ''');
      },
    );

    return _db!;
  }

  // ----------------- CART METHODS -----------------

  static Future<void> insertOrUpdateCartItem({
    required int id,
    required String name,
    required String image,
    required double price,
    required int quantity,
  }) async {
    final db = await database;

    final existing = await db.query('cart', where: 'id = ?', whereArgs: [id]);

    if (existing.isNotEmpty) {
      final currentQty = existing.first['qty'] as int;
      await db.update(
        'cart',
        {'qty': currentQty + quantity},
        where: 'id = ?',
        whereArgs: [id],
      );
    } else {
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

  // ----------------- FAVOURITE METHODS -----------------

  static Future<void> addToFavourites({
    required int id,
    required String name,
    required String image,
    required double price,
    required String about,
  }) async {
    final db = await database;

    await db.insert(
      'favourites',
      {'id': id, 'name': name, 'image': image, 'price': price, 'about': about},
      conflictAlgorithm:
          ConflictAlgorithm.replace, // replaces if already exists
    );
  }

  static Future<void> removeFromFavourites(int id) async {
    final db = await database;
    await db.delete('favourites', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getFavourites() async {
    final db = await database;
    return await db.query('favourites');
  }

  static Future<bool> isFavourite(int id) async {
    final db = await database;
    final result = await db.query(
      'favourites',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }
  static Future<void> insertMessage(ChatMessage msg) async {
    final db = await database;

    await db.insert(
      'chat',
      {
        'chat_id':msg.chatId,
        'text': msg.text,
        'is_user': msg.isUser ? 1 : 0,
        'is_seen':0,
        'timestamp': msg.timestamp, // already formatted
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  static Future<List<ChatMessage>> fetchMessages() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'chat',
      orderBy: 'chat_id ASC', // Or DESC for latest first
    );

    return maps.map((map) {
      return ChatMessage(
        text: map['text'],
        chatId: map['chat_id'],
        isUser: map['is_user'] == 1,
        isSeen: map['is_seen'],
        timestamp: map['timestamp'], // already stored as string
      );
    }).toList();
  }
  static Future<void> updateSeenStatus({
    required int messageId,
    required int isSeen,
  }) async {
    final db = await database;

    await db.update(
      'chat',
      {'is_seen': isSeen},
      where: 'chat_id = ?',
      whereArgs: [messageId],
    );
  }

}
