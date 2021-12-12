import 'package:get_storage/get_storage.dart';
import 'dart:io';


class StorageService {
  final String storeName = "school_notebook";
  final List<String> stores = [
    "tmp",
  ];
  late GetStorage box;

  StorageService();

  Future<void> initStorage() async {
    await GetStorage.init();
    box = GetStorage(storeName);
  }

  Future getStore(String store) async {
    return box.read(store);  // TODO check for store
  }

  Future readStore(String store, Map data) async {
    return box.write(store, data);  // TODO check for store
  }
}