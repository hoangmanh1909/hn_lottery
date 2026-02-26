// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/models/response/get_order_response.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/view/history/history_order_view.dart';

class HistoryOrderSuccessView extends StatefulWidget {
  const HistoryOrderSuccessView(
      {super.key, this.chuaxo, this.trungthuong, this.daxo});
  final List<GetOrderResponse>? chuaxo;
  final List<GetOrderResponse>? trungthuong;
  final List<GetOrderResponse>? daxo;
  @override
  State<StatefulWidget> createState() => _HistoryOrderSuccessView();
}

class _HistoryOrderSuccessView extends State<HistoryOrderSuccessView> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var sizeTab = size.width / 3;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            Material(
              color: ColorLot.ColorBackgoundTab,
              child: TabBar(
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: EdgeInsets.all(6),
                labelColor: Colors.white,
                indicator: BoxDecoration(
                    color: ColorLot.ColorPrimary,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      )
                    ]),
                tabs: [
                  SizedBox(
                    height: 40,
                    width: sizeTab,
                    child: Tab(text: 'Chưa xổ'),
                  ),
                  SizedBox(
                    height: 40,
                    width: sizeTab,
                    child: Tab(text: 'Trúng thưởng'),
                  ),
                  SizedBox(
                    height: 40,
                    width: sizeTab,
                    child: Tab(text: 'Đã xổ'),
                  )
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                // <-- Your TabBarView
                children: [
                  HistoryOrderView(orderModels: widget.chuaxo ?? []),
                  HistoryOrderView(orderModels: widget.trungthuong ?? []),
                  HistoryOrderView(orderModels: widget.daxo ?? []),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
