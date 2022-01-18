import 'package:sembast/sembast.dart';

import '../services/data_base_service.dart';
import 'page_types.dart';

class FolderDao {
  static const String folderStoreName = 'folder';
  final _folderStore = intMapStoreFactory.store(folderStoreName);

  Future<Database> get _db async => await DatabaseService.instance.database;

  Future insert(FolderType folder) async {
    await _folderStore.add(await _db, folder.toMap());
  }

  Future<int> update(FolderType folder) async {
    final finder = Finder(filter: Filter.equals("id", folder.id));
    int value = await _folderStore.update(
      await _db,
      folder.toMap(),
      finder: finder,
    );
    return value;
  }

  Future<int> delete(FolderType folder) async {
    final finder = Finder(filter: Filter.equals("name", folder.name));
    int value = await _folderStore.delete(
      await _db,
      finder: finder,
    );
    int valueContent = 0;
    if (folder.contentIds.isNotEmpty) {
      valueContent = await D4PageDao().deleteByIDs(folder.contentIds);
    }
    return value + valueContent; // TODO maybe better solution
  }

  Future<List<FolderType>> getAllSortedByName() async {
    final finder = Finder(sortOrders: [SortOrder('name')]);

    final recordSnapshots = await _folderStore.find(
      await _db,
      finder: finder,
    );

    return recordSnapshots.map((snapshot) {
      final folder = FolderType.fromMap(snapshot.value);
      return folder;
    }).toList();
  }

  Future<FolderType> getByID(int id) async {
    final finder = Finder(
        filter: Filter.equals("id", id), sortOrders: [SortOrder('name')]);

    final recordSnapshots = await _folderStore.find(
      await _db,
      finder: finder,
    );

    return recordSnapshots.map((snapshot) {
      final folder = FolderType.fromMap(snapshot.value);
      return folder;
    }).toList()[0];
  }
}

class D4PageDao {
  static const String d4PageStoreName = 'd4page';
  final _d4PageStore = intMapStoreFactory.store(d4PageStoreName);

  Future<Database> get _db async => await DatabaseService.instance.database;

  Future insert(D4PageType d4Page) async {
    await _d4PageStore.add(await _db, d4Page.toMap());
  }

  Future<int> update(D4PageType d4Page) async {
    final finder = Finder(filter: Filter.equals("id", d4Page.id));
    int value = await _d4PageStore.update(
      await _db,
      d4Page.toMap(),
      finder: finder,
    );
    return value;
  }

  Future<int> delete(D4PageType d4Page) async {
    final finder = Finder(filter: Filter.equals("id", d4Page.id));
    int value = await _d4PageStore.delete(
      await _db,
      finder: finder,
    );
    int valueContent = 0;
    if (d4Page.contentIds.isNotEmpty) {
      valueContent = await ContentElementDao().deleteByIDs(d4Page.contentIds);
    }
    return value + valueContent; // TODO maybe better solution
  }

  Future<int> deleteByIDs(List<int> ids) async {
    List<D4PageType> pages = await getByIDs(ids);
    List<int> pagesContentIDs = [];
    for (D4PageType page in pages) {
      pagesContentIDs.addAll(page.contentIds);
    }
    int valueContent = 0;
    if (pagesContentIDs.isNotEmpty) {
      valueContent = await ContentElementDao().deleteByIDs(pagesContentIDs);
    }

    final finder = Finder(filter: Filter.inList("id", ids));
    int value = await _d4PageStore.delete(
      await _db,
      finder: finder,
    );
    return value + valueContent; // TODO maybe better solution
  }

  Future<List<D4PageType>> getAllSortedByName() async {
    final finder = Finder(sortOrders: [SortOrder('date')]);

    final recordSnapshots = await _d4PageStore.find(
      await _db,
      finder: finder,
    );

    return recordSnapshots.map((snapshot) {
      final d4Page = D4PageType.fromMap(snapshot.value);
      return d4Page;
    }).toList();
  }

  Future<List<D4PageType>> getByFutureIDs(Future<List<int>> futureIDs) async {
    List<int> ids = await futureIDs;
    return getByIDs(ids);
  }

  Future<List<D4PageType>> getByIDs(List<int> ids) async {
    final finder = Finder(
        filter: Filter.inList("id", ids), sortOrders: [SortOrder('date')]);

    final recordSnapshots = await _d4PageStore.find(
      await _db,
      finder: finder,
    );

    return recordSnapshots.map((snapshot) {
      final d4Page = D4PageType.fromMap(snapshot.value);
      return d4Page;
    }).toList();
  }
}

class ContentElementDao {
  static const String contentElementStoreName = 'contentElement';
  final _contentElementStore =
      intMapStoreFactory.store(contentElementStoreName);

  Future<Database> get _db async => await DatabaseService.instance.database;

  Future insert(ContentElement contentElement) async {
    await _contentElementStore.add(await _db, contentElement.toMap());
  }

  Future update(ContentElement contentElement) async {
    final finder = Finder(filter: Filter.equals("id", contentElement.id));
    await _contentElementStore.update(
      await _db,
      contentElement.toMap(),
      finder: finder,
    );
  }

  Future delete(ContentElement contentElement) async {
    final finder = Finder(filter: Filter.equals("id", contentElement.id));
    await _contentElementStore.delete(
      await _db,
      finder: finder,
    );
    // TODO delete children
  }

  Future<int> deleteByIDs(List<int> ids) async {
    final finder = Finder(filter: Filter.inList("id", ids));
    int value = await _contentElementStore.delete(
      await _db,
      finder: finder,
    );
    return value;
    // TODO delete children
  }

  Future<List<ContentElement>> getAllSortedByName() async {
    final finder = Finder(sortOrders: [SortOrder('left')]);

    final recordSnapshots = await _contentElementStore.find(
      await _db,
      finder: finder,
    );

    return recordSnapshots.map((snapshot) {
      final contentElement = ContentElement.fromMap(snapshot.value);
      return contentElement;
    }).toList();
  }

  Future<List<ContentElement>> getByIDs(List<int> ids) async {
    final finder = Finder(
        filter: Filter.inList("id", ids),
        sortOrders: [SortOrder('left'), SortOrder('top')]);

    final recordSnapshots = await _contentElementStore.find(
      await _db,
      finder: finder,
    );

    return recordSnapshots.map((snapshot) {
      final d4Page = ContentElement.fromMap(snapshot.value);
      return d4Page;
    }).toList();
  }
}
