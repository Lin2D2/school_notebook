import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/data_base_service_bloc.dart';

class CustomFolderCreateDialog extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CustomFolderCreateDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double baseValue = size.height;
    if (size.width < size.height) {
      baseValue = size.width;
    }
    String folderName = "Untitled";
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
                        folderName = value;
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
                        _formKey.currentState?.save();
                        Provider.of<DataBaseServiceBloc>(context, listen: false)
                            .folderInsert(folderName, Colors.red);
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
