// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/controller/history_controller.dart';
import 'package:lottery_flutter_application/models/response/get_order_response.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/view/history/history_order_sucess_view.dart';
import 'package:lottery_flutter_application/view/history/history_order_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/response/player_profile.dart';
import '../../models/response/response_object.dart';
import '../../utils/dialog_process.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<StatefulWidget> createState() => _HistoryView();
}

class _HistoryView extends State<HistoryView> {
  final HistoryController _con = HistoryController();
  SharedPreferences? _prefs;
  PlayerProfile? playerProfile;

  List<GetOrderResponse>? dangcho;
  List<GetOrderResponse>? chuaxo;
  List<GetOrderResponse>? trungthuong;
  List<GetOrderResponse>? daxo;
  List<GetOrderResponse>? dahuy;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      initPref();
    });
  }

  initPref() async {
    _prefs = await SharedPreferences.getInstance();
    String? userMap = _prefs?.getString('user');
    if (userMap != null) {
      setState(() {
        playerProfile = PlayerProfile.fromJson(jsonDecode(userMap));
      });
      getHistory();
    }
  }

  getHistory() async {
    if (mounted) showProcess(context);

    ResponseObject res =
        await _con.getDataHistory(playerProfile!.mobileNumber!);
    if (res.code == "00") {
      List<GetOrderResponse> his = List<GetOrderResponse>.from(
          (jsonDecode(res.data!)
              .map((model) => GetOrderResponse.fromJson(model))));

      if (his.isNotEmpty) {
        setState(() {
          dangcho =
              his.where((x) => x.status == "S" || x.status == "D").toList();
          chuaxo =
              his.where((x) => x.status == "A" && x.isResult == "N").toList();
          trungthuong =
              his.where((x) => x.isWin == "Y" && x.isResult == "Y").toList();
          daxo = his.where((x) => x.isWin == "N" && x.isResult == "Y").toList();
          dahuy = his.where((x) => x.status == "X").toList();
        });
      }
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

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
                    child: Tab(text: 'Đang chờ'),
                  ),
                  SizedBox(
                    height: 40,
                    width: sizeTab,
                    child: Tab(text: 'Đã mua'),
                  ),
                  SizedBox(
                    height: 40,
                    width: sizeTab,
                    child: Tab(text: 'Đã hủy'),
                  )
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                // <-- Your TabBarView
                children: [
                  HistoryOrderView(orderModels: dangcho ?? []),
                  HistoryOrderSuccessView(
                    chuaxo: chuaxo ?? [],
                    trungthuong: trungthuong ?? [],
                    daxo: daxo ?? [],
                  ),
                  HistoryOrderView(orderModels: dahuy ?? []),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
