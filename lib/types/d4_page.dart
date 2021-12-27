import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';


class NotesType {
  List<FolderType> content = [];
}


class FolderType {
  final String id = const Uuid().v1();
  String name;

  List<D4PageType> content = [];

  FolderType({required this.name});
}


class D4PageType {
  final String id = const Uuid().v1();

  String title = "";
  final TextEditingController titleController = TextEditingController();

  String date = DateTime.now().day.toString() +
      "." +
      DateTime.now().month.toString() +
      "." +
      DateTime.now().year.toString().substring(2);
  final TextEditingController dateController = TextEditingController();

  bool visible = true;

  List<ContentElement> content = [];
}

class ContentElement {
  final String id = const Uuid().v1();

  // NOTE x range: 1 - 34
  int left;
  int width;

  // NOTE y range: 1 - 45
  int top;
  int height;

  ContentTypes contentType;
  var content;

  ContentElement(
      {required this.left,
      required this.top,
      required this.width,
      required this.height,
      this.contentType = ContentTypes.text,
      this.content = ""});
}

enum ContentTypes {
  text,
  image,
  canvas,
}
