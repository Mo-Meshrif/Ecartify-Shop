import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../../app/errors/exception.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../models/cart_item_model.dart';
import '../models/cart_item_statistics_model.dart';

abstract class BaseCartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<bool> addToCart(CartItemStatisticsModel statisticsModel);
  Future<bool> changeQuantity(CartItemStatisticsModel statisticsModel);
  Future<bool> deleteItem(String prodId);
}

class CartLocalDataSource implements BaseCartLocalDataSource {
  CartLocalDataSource._();
  static final CartLocalDataSource db = CartLocalDataSource._();
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDb();
    return _database;
  }

  initDb() async {
    String path = join(await getDatabasesPath(), 'Cart.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE cart (id INTEGER PRIMARY KEY AUTOINCREMENT,uid TEXT NOT NULL,prodId TEXT NOT NULL,color TEXT NOT NULL, size TEXT NOT NULL, quantity TEXT NOT NULL)');
      },
    );
  }

  @override
  Future<List<CartItemModel>> getCartItems() async {
    String? uid = HelperFunctions.getSavedUser()?.id;
    var dbClient = await database;
    List<CartItemModel> cartItems = [];
    List<Map<String, Object?>> list = await dbClient!.query(
      'cart',
      orderBy: 'id DESC',
      where: 'uid=?',
      whereArgs: [uid],
    );
    for (var item in list) {
      CartItemStatisticsModel statisticsModel =
          CartItemStatisticsModel.fromJson(item);
      int index = cartItems
          .indexWhere((element) => element.prodId == statisticsModel.prodId);
      if (index == -1) {
        cartItems.add(
          CartItemModel(
            prodId: statisticsModel.prodId,
            statistics: [statisticsModel],
          ),
        );
      } else {
        cartItems[index].statistics.add(statisticsModel);
      }
    }
    return cartItems;
  }

  @override
  Future<bool> addToCart(CartItemStatisticsModel statisticsModel) async {
    try {
      String? uid = HelperFunctions.getSavedUser()?.id;
      var dbClient = await database;
      int val = await dbClient!.insert(
        'cart',
        statisticsModel.toJson()
          ..addAll(
            {'uid': uid},
          ),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return val != 0;
    } catch (e) {
      throw LocalExecption(e.toString());
    }
  }

  @override
  Future<bool> changeQuantity(CartItemStatisticsModel statisticsModel) async {
    try {
      String? uid = HelperFunctions.getSavedUser()?.id;
      var dbClient = await database;
      int val = 0;
      if (statisticsModel.quantity != '0') {
        val = await dbClient!.update(
          'cart',
          statisticsModel.toJson(),
          where: 'uid=? AND prodId=? AND color=? AND size=?',
          whereArgs: [
            uid,
            statisticsModel.prodId,
            statisticsModel.color,
            statisticsModel.size
          ],
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } else {
        val = await dbClient!.delete(
          'cart',
          where: 'uid=? AND prodId=? AND color=? AND size=?',
          whereArgs: [
            uid,
            statisticsModel.prodId,
            statisticsModel.color,
            statisticsModel.size
          ],
        );
      }
      return val != 0;
    } catch (e) {
      throw LocalExecption(e.toString());
    }
  }

  @override
  Future<bool> deleteItem(String prodId) async {
    try {
      String? uid = HelperFunctions.getSavedUser()?.id;
      var dbClient = await database;
      int val = await dbClient!.delete(
        'cart',
        where: 'uid=? AND prodId=?',
        whereArgs: [uid, prodId],
      );
      return val != 0;
    } catch (e) {
      throw LocalExecption(e.toString());
    }
  }
}
