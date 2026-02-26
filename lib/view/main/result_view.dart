// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/models/response/get_result_lotomb_response.dart';
import 'package:lottery_flutter_application/models/response/get_result_response.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:lottery_flutter_application/view/result/result_kien_thiet_view.dart';
import 'package:lottery_flutter_application/view/result/result_loto_636_view.dart';
import 'package:lottery_flutter_application/view/result/result_vietlott_view.dart';

import '../../controller/result_controller.dart';
import '../../utils/color_lot.dart';
import '../../utils/dialog_process.dart';

class ResultView extends StatefulWidget {
  const ResultView({Key? key}) : super(key: key);

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> with TickerProviderStateMixin {
  final ResultController _con = ResultController();

  List<GetResultResponse>? result606;
  List<GetResultLotoMBResponse>? resultmb;

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, () {
    //   getResult();
    // });
  }

  getResult() async {
    showProcess(context);

    // await getResultMienBac();
    //await getResult636();

    if (mounted) {
      Navigator.pop(context);
    }
  }

  getResult636() async {
    ResponseObject res = await _con.getResult636();
    if (res.code == "00") {
      setState(() {
        result606 = List<GetResultResponse>.from((jsonDecode(res.data!)
            .map((model) => GetResultResponse.fromJson(model))));
      });
    }
  }

  // getResultMienBac() async {
  //   ResponseObject res = await _con.getResultMienBac();
  //   if (res.code == "00") {
  //     setState(() {
  //       resultmb = List<GetResultLotoMBResponse>.from((jsonDecode(res.data!)
  //           .map((model) => GetResultLotoMBResponse.fromJson(model))));
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var widthTab = size.width / 3;
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
                    width: widthTab,
                    child: Tab(text: 'Vietlott'),
                  ),
                  // SizedBox(
                  //   height: 40,
                  //   width: widthTab,
                  //   child: Tab(text: 'Điện toán 636'),
                  // ),
                  SizedBox(
                    height: 40,
                    width: widthTab,
                    child: Tab(text: 'Kiến thiết'),
                  )
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ResultVietlottView(),
                  // Result606View(result636: result606 ?? []),
                  ResultKienThietView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
