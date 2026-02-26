// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/models/response/get_result_keno_response.dart';
import 'package:lottery_flutter_application/models/response/get_result_max3d_response.dart';
import 'package:lottery_flutter_application/models/response/get_result_response.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:lottery_flutter_application/view/result/result_lotto_535.dart';

import '../../controller/result_controller.dart';
import '../../utils/color_lot.dart';
import '../../utils/dialog_process.dart';
import 'result_keno_view.dart';
import 'result_max3d_pro_view.dart';
import 'result_max3d_view.dart';
import 'result_mega_view.dart';
import 'result_power_view.dart';

class ResultVietlottView extends StatefulWidget {
  const ResultVietlottView({Key? key}) : super(key: key);

  @override
  State<ResultVietlottView> createState() => _ResultVietlottViewState();
}

class _ResultVietlottViewState extends State<ResultVietlottView>
    with TickerProviderStateMixin {
  final ResultController _con = ResultController();

  List<GetResultKenoResponse>? resultKenos;
  List<GetResultMax3DResponse>? resultMax3d;
  List<GetResultMax3DResponse>? resultMax3dPro;
  List<GetResultResponse>? resultMega;
  List<GetResultResponse>? resultPower;
  List<GetResultResponse>? resultLotto535;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getResult();
    });
  }

  getResult() async {
    showProcess(context);

    await getResultKeno();
    await getLotto535();
    await getMega();
    await getPower();
    await getResultMax3DPro();
    await getResultMax3D();

    if (mounted) {
      Navigator.pop(context);
    }
  }

  getMega() async {
    ResponseObject res = await _con.getResultMega645();
    if (res.code == "00") {
      setState(() {
        resultMega = List<GetResultResponse>.from((jsonDecode(res.data!)
            .map((model) => GetResultResponse.fromJson(model))));
      });
    }
  }

  getLotto535() async {
    ResponseObject res = await _con.getResultLotto535();
    if (res.code == "00") {
      setState(() {
        resultLotto535 = List<GetResultResponse>.from((jsonDecode(res.data!)
            .map((model) => GetResultResponse.fromJson(model))));
      });
    }
  }

  getPower() async {
    ResponseObject res = await _con.getResultPower();
    if (res.code == "00") {
      setState(() {
        resultPower = List<GetResultResponse>.from((jsonDecode(res.data!)
            .map((model) => GetResultResponse.fromJson(model))));
      });
    }
  }

  getResultKeno() async {
    ResponseObject res = await _con.getResultKeno();
    if (res.code == "00") {
      setState(() {
        resultKenos = List<GetResultKenoResponse>.from((jsonDecode(res.data!)
            .map((model) => GetResultKenoResponse.fromJson(model))));
      });
    }
  }

  getResultMax3D() async {
    ResponseObject res = await _con.getResultMax3D();
    if (res.code == "00") {
      setState(() {
        resultMax3d = List<GetResultMax3DResponse>.from((jsonDecode(res.data!)
            .map((model) => GetResultMax3DResponse.fromJson(model))));
      });
    }
  }

  getResultMax3DPro() async {
    ResponseObject res = await _con.getResultMax3DPro();
    if (res.code == "00") {
      setState(() {
        resultMax3dPro = List<GetResultMax3DResponse>.from(
            (jsonDecode(res.data!)
                .map((model) => GetResultMax3DResponse.fromJson(model))));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        body: Column(
          children: [
            Material(
              color: ColorLot.ColorBackgoundTab,
              child: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
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
                    child: Tab(text: 'Keno'),
                  ),
                  SizedBox(
                    height: 40,
                    child: Tab(text: 'Lotto 5/35'),
                  ),
                  SizedBox(
                    height: 40,
                    child: Tab(text: 'Power 6/55'),
                  ),
                  SizedBox(
                    height: 40,
                    child: Tab(text: 'Mega 6/45'),
                  ),
                  SizedBox(
                    height: 40,
                    child: Tab(text: 'Max 3D Pro'),
                  ),
                  SizedBox(
                    height: 40,
                    child: Tab(text: 'Max 3D'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                // <-- Your TabBarView
                children: [
                  ResultKenoView(kenoResults: resultKenos ?? []),
                  ResultLotto535View(powerResults: resultLotto535 ?? []),
                  ResultPowerView(powerResults: resultPower ?? []),
                  ResultMegaView(megaResults: resultMega ?? []),
                  ResultMax3DProView(max3dResults: resultMax3dPro ?? []),
                  ResultMax3DView(max3dResults: resultMax3d ?? []),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
