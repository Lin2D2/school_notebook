import 'package:flutter/material.dart';

import '../types/d4_page_dao.dart';

class DataBaseServiceBloc extends ChangeNotifier {
  static final FolderDao _folderDao = FolderDao();
  static final D4PageDao _pagesDao = D4PageDao();
  static final ContentElementDao _elementsDao = ContentElementDao();

  FolderDao get folderDao => _folderDao;
  D4PageDao get pageDao => _pagesDao;
  ContentElementDao get elementsDao => _elementsDao;
}
