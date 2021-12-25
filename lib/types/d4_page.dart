import 'package:flutter/material.dart';

class D4PageType {
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
  // NOTE x range: 1 - 34
  int left;
  int width;
  // NOTE y range: 1 - 45
  int top;
  int height;

  ContentTypes contentType;
  var content;

  ContentElement(this.left, this.top, this.width, this.height,
      {this.contentType = ContentTypes.text, this.content = ""});
}

enum ContentTypes {
  text,
  image,
  canvas,
}
