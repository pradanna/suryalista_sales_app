import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../model/Cart.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() => _instance;

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), 'suryalita_sales.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE carts (
            id TEXT PRIMARY KEY,
            transaction_id TEXT NULL,
            item_id TEXT,
            item_name TEXT,
            unit TEXT,
            qty INTEGER,
            request_qty INTEGER,
            price INTEGER,
            total INTEGER,
            status TEXT,
            user_id TEXT NULL,
            image TEXT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertCart(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('carts', data);
  }

  // Fetch cart items from the database
  Future<List<Cart>> getCartItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("carts");

    print(maps.toString());
    // Mapping hasil query ke daftar Cart
    return maps.map((map) => Cart.fromMap(map)).toList();
  }

  Future<void> updateCartQuantity(String id, int newQty, int price) async {
    try {
      final db = await database;
      await db.update(
        'carts',
        {'qty': newQty, 'request_qty': newQty, 'total': newQty * price}, // Update qty and total
        where: 'id = ?',
        whereArgs: [id],
      );

      print("$id $newQty");
      print("update succeess");
    }catch(e){
      print("update error $e");
    }
  }

  Future<void> deleteCartItem(String id) async {
    final Database db = await openDatabase('suryalita_sales.db');
    try {
      await db.delete('carts', where: 'id = ?', whereArgs: [id]);
      print("deleted data success");
      getCartItems();
    }catch(e){
      print("error :$e");
    }
  }

  Future<void> clearCart() async {
    final Database db = await openDatabase('suryalita_sales.db');
    await db.delete('carts'); // Menghapus semua data di tabel 'cart'
    print('Keranjang berhasil dikosongkan');
  }

  Future<int> getTotalQty() async {
    final db = await database;
    final result = await db.rawQuery('SELECT SUM(qty) as totalQty FROM carts');
    if (result.isNotEmpty && result.first['totalQty'] != null) {
      return result.first['totalQty'] as int;
    }
    return 0; // Jika tidak ada data, kembalikan 0
  }
}


