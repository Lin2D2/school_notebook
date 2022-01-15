import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/data_base_service_bloc.dart';
import '../types/page_types.dart';
import 'custom_folder_create_dialog.dart';
import 'custom_folder_element.dart';

class CustomFolderLayout extends StatelessWidget {
  const CustomFolderLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Future<List<FolderType>> folder =
        Provider.of<DataBaseServiceBloc>(context, listen: true)
            .folderDao
            .getAllSortedByName();

    return FutureBuilder<List<FolderType>>(
        future: folder,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<FolderType>? data = snapshot.data;
            int length = 0;
            if (data?.length != null) {
              length = data!.length + 1;
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: size.width ~/ 400,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                childAspectRatio: 188 / 260,
              ),
              itemCount: length,
              itemBuilder: (context, index) {
                if (index == length - 1) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(15, 15,
                        (index + 1) % (size.width ~/ 400) == 0 ? 15 : 0, 0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(35),
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomFolderCreateDialog();
                            },
                          );
                        },
                        constraints: const BoxConstraints.expand(),
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.black,
                          size: 60,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(15, 15,
                        (index + 1) % (size.width ~/ 400) == 0 ? 15 : 0, 0),
                    child: CustomFolderElement(
                      index: index,
                      folder: data![index],
                    ),
                  );
                }
              },
            );
          } else {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Error"),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        });
  }
}
