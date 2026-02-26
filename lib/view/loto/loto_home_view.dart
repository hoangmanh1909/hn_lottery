// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../../utils/color_lot.dart';
import 'loto_636_view.dart';
import 'loto_capso_view.dart';
import 'loto_so_view.dart';

class LotoHomeView extends StatefulWidget {
  const LotoHomeView({Key? key}) : super(key: key);

  @override
  State<LotoHomeView> createState() => _LotoHomeViewState();
}

class _LotoHomeViewState extends State<LotoHomeView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double widthTab = size.width / 3;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            Material(
              color: ColorLot.ColorBackground,
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                dividerColor: Colors.transparent,
                padding: EdgeInsets.all(2),
                indicator: BoxDecoration(
                    color: ColorLot.ColorPrimary,
                    borderRadius: BorderRadius.circular(8)),
                tabs: [
                  SizedBox(
                    height: 40,
                    width: widthTab,
                    child: Tab(text: 'Lô tô 2,3,5'),
                  ),
                  SizedBox(
                    height: 40,
                    width: widthTab,
                    child: Tab(text: 'Điện toán 6x36'),
                  ),
                  SizedBox(
                    height: 40,
                    width: widthTab,
                    child: Tab(text: 'Lô tô 2,3,4 cặp'),
                  )
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                // <-- Your TabBarView
                children: [
                  LotoSoView(),
                  Loto636View(),
                  LotoCapSoView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
