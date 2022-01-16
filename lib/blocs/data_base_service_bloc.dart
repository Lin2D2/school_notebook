import 'dart:math';

import 'package:flutter/material.dart';
import 'package:school_notebook/types/page_types.dart';

import '../types/page_types_dao.dart';

class DataBaseServiceBloc extends ChangeNotifier {
  static final FolderDao _folderDao = FolderDao();
  static final D4PageDao _pagesDao = D4PageDao();
  static final ContentElementDao _elementsDao = ContentElementDao();

  FolderDao get folderDao => _folderDao;

  D4PageDao get pageDao => _pagesDao;

  ContentElementDao get elementsDao => _elementsDao;

  int generateID() {
    return int.parse(DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(99).toString());
  }

  Future<int> purgeDatabase() async {
    int value = 0;
    for (var folder in await _folderDao.getAllSortedByName()) {
      value = value + await _folderDao.delete(folder);
    }
    notifyListeners();
    return value;
  }

  Future<int> folderInsert(String name, Color color) async {
    int pageID = await pageInsert();
    int folderID = generateID();
    FolderType folder = FolderType(
        id: folderID, name: name, color: color, contentIds: [pageID]);
    await _folderDao.insert(folder);
    notifyListeners();
    return folderID;
  }

  void folderDelete(FolderType folder) async {
    await _folderDao.delete(folder);
    notifyListeners();
  }

  void folderUpdate(FolderType folder) async {
    await _folderDao.update(folder);
    notifyListeners();
  }

  Future<int> pageInsert() async {
    int pageID = generateID();
    DateTime now = DateTime.now();
    String date = now.day.toString() +
        "." +
        now.month.toString() +
        "." +
        now.year.toString().substring(2);
    D4PageType page =
        D4PageType(id: pageID, name: "Untitled", date: date, contentIds: []);
    await _pagesDao.insert(page);
    notifyListeners();
    return pageID;
  }

  void pageDelete(D4PageType page) async {
    await _pagesDao.delete(page);
    notifyListeners();
  }

  Future pageInsertElement(int pageID, int elementID) async {
    D4PageType page = (await _pagesDao.getByIDs([pageID]))[0];
    List<int> contentIds = [elementID];
    contentIds.addAll(page.contentIds);
    page.contentIds = contentIds;
    await _pagesDao.update(page);
    notifyListeners();
  }

  Future elementInsert(int pageID, int top, int left) async {
    int elementID = generateID();
    ContentElement contentElement = ContentElement(
      id: elementID,
      left: left,
      top: top,
      width: 10,
      height: 10,
      contentId: 0,
    );
    await _elementsDao.insert(contentElement);
    await pageInsertElement(pageID, elementID); // NOTE notifyListeners called here
  }
}
