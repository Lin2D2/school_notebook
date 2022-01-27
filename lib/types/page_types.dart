import 'package:flutter/material.dart';

class FolderType {
  int id;
  String name;
  Color color;

  List<int> contentIds;

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
  int id;

  String name;
  TextEditingController? nameController;

  String date;
  TextEditingController? dateController;

  double height;
  double width;

  List<int> contentIDs;

  D4PageType(
      {required this.id,
      required this.name,
      this.nameController,
      required this.date,
      this.dateController,
      this.height = 260, // NOTE D4 Paper size // IMPORTANT min value 40
      this.width = 188, // NOTE D4 Paper size
      required this.contentIDs});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'contentIDs': contentIDs,
    };
  }

  static D4PageType fromMap(Map<String, dynamic> map) {
    return D4PageType(
      id: map['id'],
      name: map['name'],
      nameController: TextEditingController(),
      date: map['date'],
      dateController: TextEditingController(),
      contentIDs: map['contentIDs'].cast<int>().toList(),
    );
  }
}

class ContentElement {
  // TODO maybe allow this to be complexer shape
  /* Exmple:
  ---------------
  |             |
  |             |
  |      --------
  |      |
  |      |
  |      |
  |      --------
  |             |
  |             |
  ---------------
  */
  // NOTE maybe do this with self instancing, ContentElement made out of 3
  // more ContentElements, or with a list of left, width and top and height
  int id;

  // NOTE x range: 1 - 34
  int left;
  int width;

  // NOTE y range: 1 - 45
  int top;
  int height;

  ContentTypes? contentType;
  List<int>? contentIDs;

  ContentElement(
      {required this.id,
      required this.left,
      required this.top,
      required this.width,
      required this.height,
      this.contentType,
      this.contentIDs});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'left': left,
      'top': top,
      'width': width,
      'height': height,
      'contentType': contentType.toString(),
      'contentIDs': contentIDs,
    };
  }

  static ContentElement fromMap(Map<String, dynamic> map) {
    String contentTypeString = map['contentType'];
    ContentTypes? contentType;
    for (var element in ContentTypes.values) {
      if (element.toString() == contentTypeString) {
        contentType = element;
        break;
      }
    }
    return ContentElement(
      id: map['id'],
      left: map['left'],
      top: map['top'],
      width: map['width'],
      height: map['height'],
      contentType: contentType,
      contentIDs: map['contentIDs'],
    );
  }
}

enum ContentTypes {
  text,
  image,
  canvas,
  contentElement,
}

class ContentTextType {
  int id;

  String content;

  ContentTextType({required this.id, this.content = ""});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
    };
  }

  static ContentTextType fromMap(Map<String, dynamic> map) {
    return ContentTextType(
      id: map['id'],
      content: map['content'],
    );
  }
}
