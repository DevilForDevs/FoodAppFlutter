import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Address {
  final int addressId;
  final int userId;
  final String city;
  final String street;
  final String pincode;
  final String longAddress;
  final String addressType;

  Address({
    required this.addressId,
    required this.userId,
    required this.city,
    required this.street,
    required this.pincode,
    required this.longAddress,
    required this.addressType,
  });

  Map<String, dynamic> toMap() {
    return {
      'address_id': addressId,
      'user_id': userId,
      'city': city,
      'street': street,
      'pincode': pincode,
      'longAddress': longAddress,
      'addressType': addressType,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      addressId: map['address_id'],
      userId: map['user_id'],
      city: map['city'],
      street: map['street'],
      pincode: map['pincode'],
      longAddress: map['longAddress'],
      addressType: map['addressType'],
    );
  }
}

class AddressDbHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'address.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
         CREATE TABLE addresses (
            address_id  INTEGER PRIMARY KEY,
            user_id INTEGER,
            city TEXT,
            street TEXT,
            pincode TEXT,
            longAddress TEXT,
            addressType TEXT
         )
         ''');
      },
    );
    return _db!;
  }

  // 🔹 Insert Address
  static Future<int> insertAddress(Address address) async {
    final db = await database;
    return await db.insert('addresses', address.toMap(),conflictAlgorithm:
    ConflictAlgorithm.replace, );
  }

  // 🔹 Update Address
  static Future<int> updateAddress(Address address) async {
    final db = await database;
    return await db.update(
      'addresses',
      address.toMap(),
      where: 'address_id = ?',
      whereArgs: [address.addressId],
    );
  }

  // 🔹 Get All Addresses
  static Future<List<Address>> getAllAddresses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('addresses');
    return maps.map((map) => Address.fromMap(map)).toList();
  }

  // 🔹 Get Last Inserted Address
  static Future<Address?> getLastAddress() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'addresses',
      orderBy: 'address_id DESC',
      limit: 1,
    );
    if (result.isNotEmpty) {
      return Address.fromMap(result.first);
    }
    return null;
  }
  static Future<bool> addressIdExists(int addressId) async {
    final db = await database;
    final result = await db.query(
      'addresses',
      where: 'address_id = ?',
      whereArgs: [addressId],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}
