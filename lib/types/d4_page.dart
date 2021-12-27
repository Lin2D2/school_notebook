import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';


class FolderType {
  int id;
  String name;

  List<int> contentIds;

  FolderType({required this.id, required this.name, required this.contentIds});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contentIds': contentIds,
    };
  }

  static FolderType fromMap(Map<String, dynamic> map) {
    return FolderType(
      id: map['id'],
      name: map['name'],
      contentIds: map['contentIds'],
    );
  }
}

class D4PageType {
  // final String id = const Uuid().v1();
  int id;

  String name;

  // final TextEditingController titleController = TextEditingController();
  final TextEditingController nameController;

  // String date = DateTime.now().day.toString() +
  //     "." +
  //     DateTime.now().month.toString() +
  //     "." +
  //     DateTime.now().year.toString().substring(2);
  String date;
  final TextEditingController dateController;

  bool visible;

  List<int> contentIds;

  D4PageType(
      {required this.id,
      required this.name,
      required this.nameController,
      required this.date,
      required this.dateController,
      required this.visible,
      required this.contentIds});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'visible': visible,
      'contentIds': contentIds,
    };
  }

  static D4PageType fromMap(Map<String, dynamic> map) {
    return D4PageType(
      id: map['id'],
      name: map['name'],
      nameController: TextEditingController(),
      date: map['date'],
      dateController: TextEditingController(),
      visible: map['visible'],
      contentIds: map['contentIds'],
    );
  }
}

class ContentElement {
  int id;

  // NOTE x range: 1 - 34
  int left;
  int width;

  // NOTE y range: 1 - 45
  int top;
  int height;

  ContentTypes contentType;
  int contentId;

  ContentElement(
      {required this.id,
      required this.left,
      required this.top,
      required this.width,
      required this.height,
      this.contentType = ContentTypes.text,
      required this.contentId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'left': left,
      'top': top,
      'width': width,
      'height': height,
      'contentType': contentType,
      'contentId': contentId,
    };
  }

  static ContentElement fromMap(Map<String, dynamic> map) {
    return ContentElement(
      id: map['id'],
      left: map['left'],
      top: map['top'],
      width: map['width'],
      height: map['height'],
      contentType: map['contentType'],
      contentId: map['contentId'],
    );
  }
}

enum ContentTypes {
  text,
  image,
  canvas,
}

class ContentTextType {
  int id;

  String content;

  ContentTextType({required this.id, this. content = ""});
}
