import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_notebook/blocs/data_base_service_bloc.dart';

import '../types/d4_page.dart';
import 'folder_element.dart';

class FolderPageLayout extends StatelessWidget {
  const FolderPageLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                // TODO better with dynamic cross Axis count and dynamic size of folder
                crossAxisCount: width ~/ 400,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                childAspectRatio: 188 / 260,
              ),
              itemCount: length,
              itemBuilder: (context, index) {
                if (index == length - 1) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                        15, 15, (index + 1) % (width ~/ 400) == 0 ? 15 : 0, 0),
                    child: Container(
                      color: Colors.white,
                      child: IconButton(
                        onPressed: () {
                          // TODO add item to database

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
                    padding: EdgeInsets.fromLTRB(
                        15, 15, (index + 1) % (width ~/ 400) == 0 ? 15 : 0, 0),
                    child: FolderElement(
                      index: index,
                      folder: data![index],
                    ),
                  );
                }
              },
            );
          } else {
            if (snapshot.hasError) {
              print(snapshot.error);
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
