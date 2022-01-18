import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/data_base_service_bloc.dart';
import '../types/page_types.dart';

class CustomPageIndicator extends StatefulWidget {
  final ScrollController scrollController;
  final Future<FolderType> folder;

  const CustomPageIndicator(
      {Key? key, required this.scrollController, required this.folder})
      : super(key: key);

  @override
  State<CustomPageIndicator> createState() => _CustomPageIndicatorState();
}

class _CustomPageIndicatorState extends State<CustomPageIndicator>
    with TickerProviderStateMixin {
  int pageIndex = 0;
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController =
        TabController(length: 1, initialIndex: pageIndex, vsync: this);
    widget.scrollController.addListener(() {
      double pixels = widget.scrollController.position.pixels;
      int newPageIndex = (pixels / 4 != 0 ? pixels / 4 : 1) ~/ (260 + 10);
      if (newPageIndex != tabController?.index && mounted) {
        setState(() {
          pageIndex = newPageIndex;
          tabController?.animateTo(newPageIndex);
        });
      }
      // page spacing with standard height of 260 ca 270 * scale
      // page (height + 10) * scale * index => pixels
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: RotatedBox(
        quarterTurns: 1,
        child: FutureBuilder<List<D4PageType>>(
          // TODO optimize
          future: Provider.of<DataBaseServiceBloc>(context, listen: true)
              .pageDao
              .getByFutureIDs(
                widget.folder.then((value) => value.contentIds),
              ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              tabController = TabController(
                  length: ((snapshot.data?.length ?? 0) + 1),
                  initialIndex: pageIndex,
                  vsync: this);
              return TabPageSelector(
                controller: tabController,
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
