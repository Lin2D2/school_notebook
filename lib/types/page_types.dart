import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';

class FolderType {
  int id;
  String name;
  Color color;

  List<int> contentIds; // TODO List<int> but error type 'ImmutableList<dynamic>' is not a subtype of type 'List<int>'

  FolderType(
      {required this.id,
      required this.name,
      required this.color,
      required this.contentIds});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': {
        "r": color.red,
        "g": color.green,
        "b": color.blue,
        "o": color.opacity
      },
      'contentIds': contentIds,
    };
  }

  static FolderType fromMap(Map<String, dynamic> map) {
    return FolderType(
      id: map['id'],
      name: map['name'],
      color: Color.fromRGBO(map['color']["r"], map['color']["g"],
          map['color']["b"], map['color']["o"]),
      contentIds: map['contentIds'].cast<int>().toList(),
    );
  }
}

class D4PageType {
  // final String id = const Uuid().v1();
  int id;

  String name;

  // final TextEditingController titleController = TextEditingController();
  TextEditingController? nameController;

  // String date = DateTime.now().day.toString() +
  //     "." +
  //     DateTime.now().month.toString() +
  //     "." +
  //     DateTime.now().year.toString().substring(2);
  String date;
  TextEditingController? dateController;

  List<int> contentIds;

  D4PageType(
      {required this.id,
      required this.name,
      this.nameController,
      required this.date,
      this.dateController,
      required this.contentIds});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
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
      contentIds: map['contentIds'].cast<int>().toList(),
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

  ContentTextType({required this.id, this.content = ""});
}
