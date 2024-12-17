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

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'cart.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
      CREATE TABLE cart (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  transaction_id TEXT,
  item_id TEXT NOT NULL,
  unit TEXT NOT NULL,
  qty INTEGER NOT NULL,
  price INTEGER NOT NULL,
  total INTEGER NOT NULL,
  name TEXT,  
  image TEXT  
)
        ''');
      },
    );
  }

  Future<void> migrateDatabase(Database db) async {
    // Buat tabel sementara dengan skema baru
    await db.execute('''
    CREATE TABLE carts_new (
      id TEXT PRIMARY KEY,
      transaction_id TEXT,
      item_id TEXT NOT NULL,
      unit TEXT NOT NULL,
      qty INTEGER NOT NULL,
      price INTEGER NOT NULL,
      total INTEGER NOT NULL
    )
  ''');

    // Salin data dari tabel lama ke tabel baru
    await db.execute('''
    INSERT INTO carts_new (id, transaction_id, item_id, qty, price, total)
    SELECT id, transaction_id, item_id, qty, price, total FROM carts
  ''');

    // Hapus tabel lama
    await db.execute('DROP TABLE carts');

    // Ganti nama tabel baru menjadi nama tabel lama
    await db.execute('ALTER TABLE carts_new RENAME TO carts');
  }

  Future<int> insertCart(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('cart', data);
  }

  // Fetch cart items from the database
  Future<List<Cart>> getCartItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("cart");

    // Mapping hasil query ke daftar Cart
    return maps.map((map) => Cart.fromMap(map)).toList();
  }

  Future<void> updateCartQuantity(int id, int newQty, int price) async {
    final db = await database;
    await db.update(
      'cart',
      {'qty': newQty, 'total': newQty * price}, // Update qty and total
      where: 'id = ?',
      whereArgs: [id],
    );

    print("update succeess");
  }

  Future<void> deleteCartItem(int id) async {
    final db = await database;
    await db.delete('cart', where: 'id = ?', whereArgs: [id]);

    print("deleted data success");
  }

  Future<void> clearCart() async {
    final Database db = await openDatabase('cart.db');
    await db.delete('cart'); // Menghapus semua data di tabel 'cart'
    print('Keranjang berhasil dikosongkan');
  }
}
