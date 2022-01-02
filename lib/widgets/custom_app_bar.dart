import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final Future<String> title;
  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      title: FutureBuilder<String>(
        future: title,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data ?? "");
          } else {
            return const Text("");
          }
        },
      ),
      leading: InkWell(
        child: const Icon(Icons.menu),
        onTap: () => Scaffold.of(context).openDrawer(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(5000, 50);
}
