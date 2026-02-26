// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/view/loto/loto_home_view.dart';
import 'package:lottery_flutter_application/view/main/kienthiet_view.dart';
import 'package:lottery_flutter_application/view/main/vietlott_home_view.dart';

import '../../utils/color_lot.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double widthTab = size.width / 3;

    return DefaultTabController(
      length: 3,
      initialIndex: 1,
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
                    child: Tab(text: 'Điện toán'),
                  ),
                  SizedBox(
                    height: 40,
                    width: widthTab,
                    child: Tab(text: 'Vietlott'),
                  ),
                  SizedBox(
                    height: 40,
                    width: widthTab,
                    child: Tab(text: 'Kiến thiết'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                // <-- Your TabBarView
                children: [LotoHomeView(), VietlottHomeView(), KienThietView()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
