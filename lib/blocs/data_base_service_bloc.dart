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

  void folderInsert(FolderType folder) async {
    await _folderDao.insert(folder);
    notifyListeners();
  }

  void folderDelete(FolderType folder) async {
    await _folderDao.delete(folder);
    notifyListeners();
  }

  void folderUpdate(FolderType folder) async {
    await _folderDao.update(folder);
    notifyListeners();
  }

  void pageInsert(D4PageType page) async {
    await _pagesDao.insert(page);
    notifyListeners();
  }

  void pageDelete(D4PageType page) async {
    await _pagesDao.delete(page);
    notifyListeners();
  }

  void pageUpdate(D4PageType page) async {
    await _pagesDao.update(page);
    notifyListeners();
  }
}
