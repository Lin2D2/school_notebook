import 'dart:math';

import 'package:flutter/material.dart';

import '../types/page_types.dart';
import '../types/page_types_dao.dart';

class DataBaseServiceBloc extends ChangeNotifier {
  static final FolderDao _folderDao = FolderDao();
  static final D4PageDao _pagesDao = D4PageDao();
  static final ContentElementDao _elementsDao = ContentElementDao();

  FolderDao get folderDao => _folderDao;

  D4PageDao get pageDao => _pagesDao;

  ContentElementDao get elementsDao => _elementsDao;

  int _generateID() {
    return int.parse(DateTime
        .now()
        .millisecondsSinceEpoch
        .toString() +
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
    int pageID = _generateID();
    int folderID = _generateID();
    FolderType folder = FolderType(
        id: folderID, name: name, color: color, contentIds: [pageID]);
    await pageInsert(Future(() => folder), pageID: pageID);
    await _folderDao.insert(folder);
    notifyListeners();
    return folderID;
  }

  Future folderDelete(FolderType folder) async {
    await _folderDao.delete(folder);
    notifyListeners();
  }

  Future pageInsert(Future<FolderType> futureFolder, {int? pageID}) async {
    FolderType folder = await futureFolder;
    bool updateFolder = pageID == null;
    pageID ??= _generateID();
    DateTime now = DateTime.now();
    String day = now.day.toString();
    if (day.length == 1) {
      day = "0" + day; // NOTE this is to make it always 2 long
    }
    String month = now.month.toString();
    if (month.length == 1) {
      month = "0" + month; // NOTE this is to make it always 2 long
    }
    String year = now.year.toString();
    String date = day + "." + month + "." + year.substring(2);
    D4PageType page =
    D4PageType(id: pageID, name: "Untitled", date: date, contentIds: []);
    List<int> contentIds = [pageID];
    contentIds.addAll(folder.contentIds);
    FolderType newFolder = FolderType(
        id: folder.id,
        name: folder.name,
        color: folder.color,
        contentIds: contentIds);
    await _pagesDao.insert(page);
    if (updateFolder) {
      await _folderDao.update(newFolder);
    }
    notifyListeners();
  }

  Future pageDelete(D4PageType page) async {
    await _pagesDao.delete(page);
    notifyListeners();
  }

  Future _pageInsertElement(int pageID, int elementID) async {
    D4PageType page = (await _pagesDao.getByIDs([pageID]))[0];
    List<int> contentIds = [elementID];
    contentIds.addAll(page.contentIds);
    page.contentIds = contentIds;
    await _pagesDao.update(page);
    notifyListeners();
  }

  Future elementInsert(int pageID, int top, int left) async {
    int elementID = _generateID();
    ContentElement contentElement = ContentElement(
      id: elementID,
      left: left,
      top: top,
      width: 10,
      height: 10,
      contentId: _generateID(), // TODO create contentData
    );
    await _elementsDao.insert(contentElement);
    await _pageInsertElement(
        pageID, elementID); // NOTE notifyListeners called here
  }

  Future elementUpdatePosition(
      ContentElement element, int top, int left) async {
    ContentElement newElement = ContentElement(
        id: element.id,
        left: left,
        top: top,
        width: element.width,
        height: element.height,
        contentId: element.contentId);
    _elementsDao.update(newElement);
    notifyListeners();
  }

  Future elementUpdateSize(
      ContentElement element, int height, int width) async {
    ContentElement newElement = ContentElement(
        id: element.id,
        left: element.left,
        top: element.top,
        width: width,
        height: height,
        contentId: element.contentId);
    _elementsDao.update(newElement);
    notifyListeners();
  }
}
