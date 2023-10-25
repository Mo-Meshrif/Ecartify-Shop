import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../../app/errors/exception.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../models/address_model.dart';

abstract class BaseAddressLocalDataSource {
  Future<List<AddressModel>> getAddressList();
  Future<AddressModel?> addAddress(AddressModel addressModel);
  Future<bool> editAddress(AddressModel addressModel);
  Future<bool> deleteAddress(int addressId);
}

class AddressLocalDataSource implements BaseAddressLocalDataSource {
  AddressLocalDataSource._();
  static final AddressLocalDataSource db = AddressLocalDataSource._();
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDb();
    return _database;
  }

  initDb() async {
    String path = join(await getDatabasesPath(), 'Address.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE address (id INTEGER PRIMARY KEY AUTOINCREMENT,uid TEXT NOT NULL,name TEXT NOT NULL,details TEXT NOT NULL,lat TEXT NOT NULL,lon TEXT NOT NULL,isDefault INTEGER NOT NULL)');
      },
    );
  }

  @override
  Future<List<AddressModel>> getAddressList() async {
    try {
      String? uid = HelperFunctions.getSavedUser()?.id;
      if (uid != null) {
        var dbClient = await database;
        List<Map<String, Object?>> list = await dbClient!.query(
          'address',
          orderBy: 'id DESC',
          where: 'uid=?',
          whereArgs: [uid],
        );
        return list.map((e) => AddressModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw LocalExecption(e.toString());
    }
  }

  @override
  Future<AddressModel?> addAddress(AddressModel addressModel) async {
    try {
      String? uid = HelperFunctions.getSavedUser()?.id;
      if (uid != null) {
        var dbClient = await database;
        await _removeDefualt(addressModel.isDefault);
        int val = await dbClient!.insert(
          'address',
          addressModel.toJson()
            ..addAll(
              {'uid': uid},
            ),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        return val != 0 ? addressModel.copyWith(id: val) : null;
      } else {
        return null;
      }
    } catch (e) {
      throw LocalExecption(e.toString());
    }
  }

  @override
  Future<bool> editAddress(AddressModel addressModel) async {
    try {
      String? uid = HelperFunctions.getSavedUser()?.id;
      if (uid != null) {
        var dbClient = await database;
        await _removeDefualt(addressModel.isDefault);
        int val = await dbClient!.update(
          'address',
          addressModel.toJson(),
          where: 'uid=? AND id=?',
          whereArgs: [
            uid,
            addressModel.id,
          ],
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        return val != 0;
      } else {
        return false;
      }
    } catch (e) {
      throw LocalExecption(e.toString());
    }
  }

  @override
  Future<bool> deleteAddress(int addressId) async {
    try {
      String? uid = HelperFunctions.getSavedUser()?.id;
      if (uid != null) {
        var dbClient = await database;
        int val = await dbClient!.delete(
          'address',
          where: 'uid=? AND id=?',
          whereArgs: [uid, addressId],
        );
        return val != 0;
      } else {
        return false;
      }
    } catch (e) {
      throw LocalExecption(e.toString());
    }
  }

  Future<void> _removeDefualt(bool newIsDefault) async {
    if (newIsDefault) {
      String? uid = HelperFunctions.getSavedUser()?.id;
      if (uid != null) {
        var dbClient = await database;
        dbClient!.update(
          'address',
          {'isDefault': '0'},
          where: 'uid=? AND isDefault=?',
          whereArgs: [
            uid,
            '1',
          ],
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
  }
}
