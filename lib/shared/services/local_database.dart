import 'dart:convert';

import 'package:lets_makeup/model/product.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static LocalDatabase? _instance;

  LocalDatabase._();

  factory LocalDatabase() => _instance ??= LocalDatabase._();

  static const _version = 3;
  static const _products = 'products';

  Database? _db;

  Future<Database> get _database async {
    return _db ??= await openDatabase(
      join(await getDatabasesPath(), 'demo.db'),
      version: _version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  void _onCreate(final Database db, final int version) async {
    await db.rawQuery('CREATE TABLE $_products ('
        'row_id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'id INTEGER,'
        'brand TEXT,'
        'name TEXT,'
        'price TEXT,'
        'price_sign TEXT,'
        'image_link TEXT,'
        'product_link TEXT,'
        'description TEXT,'
        'category TEXT,'
        'tag_list TEXT,'
        'product_colors TEXT)');
  }

  void _onUpgrade(
      final Database db, final int oldVersion, final int newVersion) async {
    await db.rawQuery('DROP TABLE IF EXISTS $_products');

    _onCreate(db, newVersion);
  }

  void insertList(final List<Map<String, dynamic>> data) async {
    (await _database).transaction((txn) async {
      await txn.rawQuery('DELETE FROM $_products');
      for (final product in data) {
        await txn.rawInsert(
            'INSERT INTO $_products '
            '(id,brand,name,price,price_sign,image_link,product_link,description,category,tag_list,product_colors) '
            'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
            [
              product['id'],
              product['brand'] ?? '',
              product['name'] ?? '',
              product['price'] ?? '',
              product['price_sign'] ?? '',
              product['image_link'] ?? '',
              product['product_link'] ?? '',
              product['description'] ?? '',
              product['category'] ?? '',
              product['tag_list']?.join(','),
              jsonEncode(product['product_colors'] ?? []),
            ]);
      }
    });
  }

  Future<List<Product>> getData() async {
    final result = await (await _database).rawQuery('SELECT * FROM $_products');
    return List<Product>.from(result.map((e) {
      final json = {...e};
      json['tag_list'] = json['tag_list'].toString().split(',');
      json['product_colors'] =
          jsonDecode(json['product_colors']?.toString() ?? '[]');
      return Product.fromJson(json);
    }));
  }

  Future<Product?> getProduct(final int id)async{
    final result = await (await _database).rawQuery('SELECT * FROM $_products WHERE id = $id');
    final json = {...result.first};
    json['tag_list'] = json['tag_list'].toString().split(',');
    json['product_colors'] =
        jsonDecode(json['product_colors']?.toString() ?? '[]');
  // print('RESULT IS : $result');
    return Product.fromJson(json);

  }
}
