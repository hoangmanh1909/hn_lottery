// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/models/request/xskt_base_request.dart';
import 'package:lottery_flutter_application/models/response/get_result_lotomb_response.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:lottery_flutter_application/view/result/result_mb_view.dart';
import 'package:lottery_flutter_application/view/result/result_mientrung_view.dart';

import '../../controller/result_controller.dart';
import '../../utils/color_lot.dart';
import '../../utils/dialog_process.dart';

class ResultKienThietView extends StatefulWidget {
  const ResultKienThietView({Key? key}) : super(key: key);

  @override
  State<ResultKienThietView> createState() => _ResultKienThietViewState();
}

class _ResultKienThietViewState extends State<ResultKienThietView>
    with TickerProviderStateMixin {
  final ResultController _con = ResultController();

  List<GetResultLotoMBResponse>? resultMB;
  List<GetResultLotoMBResponse>? resultMT;
  List<GetResultLotoMBResponse>? resultMN;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getResult();
    });
  }

  getResult() async {
    showProcess(context);

    await getMB();
    // await getMT();
    await getMN();

    if (mounted) {
      Navigator.pop(context);
    }
  }

  getMB() async {
    ResponseObject res = await _con.getResultMienBac();
    if (res.code == "00") {
      setState(() {
        resultMB = List<GetResultLotoMBResponse>.from((jsonDecode(res.data!)
            .map((model) => GetResultLotoMBResponse.fromJson(model))));
      });
    }
  }

  getMT() async {
    XSKTBaseRequest req = XSKTBaseRequest();
    req.iD = 2;
    ResponseObject res = await _con.getXSKT(req);
    if (res.code == "00") {
      setState(() {
        resultMT = List<GetResultLotoMBResponse>.from((jsonDecode(res.data!)
            .map((model) => GetResultLotoMBResponse.fromJson(model))));
      });
    }
  }

  getMN() async {
    XSKTBaseRequest req = XSKTBaseRequest();
    req.iD = 3;
    ResponseObject res = await _con.getXSKT(req);
    if (res.code == "00") {
      setState(() {
        resultMN = List<GetResultLotoMBResponse>.from((jsonDecode(res.data!)
            .map((model) => GetResultLotoMBResponse.fromJson(model))));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var sizeTab = size.width / 3;
    return DefaultTabController(
      length: 2,
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
                    child: Tab(text: 'Miền Bắc'),
                  ),
                  // SizedBox(
                  //   height: 40,
                  //   width: sizeTab,
                  //   child: Tab(text: 'Miền Trung'),
                  // ),
                  SizedBox(
                    height: 40,
                    width: sizeTab,
                    child: Tab(text: 'Miền Nam'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                // <-- Your TabBarView
                children: [
                  ResultMienBacView(xsktMienBac: resultMB ?? []),
                  // ResultMienTrungView(xsktMienTrung: resultMT ?? []),
                  ResultMienTrungView(xsktMienTrung: resultMN ?? []),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
