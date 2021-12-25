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
}
