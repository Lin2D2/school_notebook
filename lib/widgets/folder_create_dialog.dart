import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_notebook/blocs/data_base_service_bloc.dart';
import 'package:school_notebook/blocs/navigator_bloc.dart';

import '../types/d4_page.dart';

class FolderCreateDialog extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FolderCreateDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double baseValue = size.height;
    if (size.width < size.height) {
      baseValue = size.width;
    }
    String folder_name = "Untitled";
    return Center(
      child: SizedBox(
        width: (baseValue * 0.75 * 0.75),
        height: (baseValue * 0.35) < 400 ? 400 : (baseValue * 0.35),
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Create New Folder"),
          ),
          body: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter a Folder Name',
                    ),
                    validator: (String? value) {
                      // TODO also check if already in database
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      if (value != null) {
                        folder_name = value;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 25, right: 25, top: 15, bottom: 25),
                  child: SizedBox(
                    height: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text("Select a Color"),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: GridView.count(
                              crossAxisCount: 10, // TODO make this adapt
                              children: List.generate(20, (index) {
                                return const CircleAvatar(
                                  backgroundColor: Colors
                                      .red, // TODO color from list and mark selected with outline
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // TODO add item to database
                        _formKey.currentState?.save();
                        Provider.of<DataBaseServiceBloc>(context, listen: false)
                            .folderDao
                            .insert(
                              FolderType(
                                id: Random().nextInt(100000),
                                name: folder_name,
                                color: Colors.red, // TODO get from Form
                                contentIds: [],
                              ),
                            );
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Create'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
