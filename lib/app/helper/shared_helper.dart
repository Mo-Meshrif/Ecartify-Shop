import 'package:get_storage/get_storage.dart';

abstract class AppShared {
  setVal(String key, value);
  getVal(String key);
  removeVal(String key);
  clearAllShared();
}

class AppStorage implements AppShared {
  final GetStorage storage;

  AppStorage(this.storage);

  @override
  setVal(String key, value) => storage.write(key, value);

  @override
  getVal(String key) => storage.read(key);

  @override
  removeVal(String key) => storage.remove(key);

  @override
  clearAllShared() => storage.erase();
}