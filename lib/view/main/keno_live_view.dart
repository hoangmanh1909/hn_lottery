// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';

import 'package:flip_board/flip_clock.dart';
import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/controller/dictionary_controller.dart';
import 'package:lottery_flutter_application/models/response/get_draw_keno_response.dart';
import 'package:lottery_flutter_application/models/response/get_result_keno_response.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:lottery_flutter_application/models/selected_item_model.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/view/result/result_keno_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KenoLiveView extends StatefulWidget {
  const KenoLiveView({super.key});

  @override
  State<StatefulWidget> createState() => _KenoLiveView();
}

class _KenoLiveView extends State<KenoLiveView> {
  late final WebViewController _controller;
  final DictionaryController _con = DictionaryController();

  List<GetResultKenoResponse>? resultKenos;
  GetDrawKenoResponse? drawKenoResponse;
  String drawCode = "#";
  int secondCountdown = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getData();
    });
  }

  getData() async {
    await getDrawKeno();
    await getResultKeno();
  }

  getDrawKeno() async {
    ResponseObject res = await _con.getDrawKeno();
    if (res.code == "00") {
      drawKenoResponse = GetDrawKenoResponse.fromJson(jsonDecode(res.data!));
      secondCountdown = drawKenoResponse!.closeTime!;
      drawCode = drawKenoResponse!.drawCode!;
      setState(() {});
      if (drawKenoResponse != null) {
        startTimer();
      }
    }
  }

  void startTimer() {
    Duration oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (secondCountdown == 0) {
          Future.delayed(Duration(seconds: 1), () {
            getData();
          });

          setState(() {});
        } else {
          if (mounted) {
            setState(() {
              secondCountdown--;
            });
          }
        }
      },
    );
  }

  @override
  void dispose() {
    if (timer != null) timer!.cancel();
    super.dispose();
  }

  getResultKeno() async {
    ResponseObject res = await _con.getResultKeno();

    if (res.code == "00") {
      if (mounted) {
        resultKenos = List<GetResultKenoResponse>.from((jsonDecode(res.data!)
            .map((model) => GetResultKenoResponse.fromJson(model))));
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          color: ColorLot.ColorBackground,
          child: Column(
            children: [
              // _buidLink(),
              Container(
                  height: 60,
                  width: double.infinity,
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15.0,
                          offset: Offset(0.0, 0.75))
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Image(
                              image: AssetImage("assets/img/keno.png"),
                              width: 75,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: ColorLot.ColorPrimary,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Kỳ quay",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text("#$drawCode",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18))
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      _flipClock()
                    ],
                  )),
              buildResultFirst(),
              buildGeneral()
            ],
          )),
    ));
  }

  Widget buildResultFirst() {
    if (resultKenos != null) {
      GetResultKenoResponse item = resultKenos![0];
      return Container(
          height: 180,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const <BoxShadow>[
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15.0,
                  offset: Offset(0.0, 0.75))
            ],
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Kết quả kỳ quay #${item.drawCode}",
                  style: TextStyle(color: ColorLot.ColorPrimary),
                ),
              ),
              ballFirst(item),
              SizedBox(
                height: 4,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                item.even! > 10
                    ? bigSmallActive(
                        "Chắn (${item.even})", ColorLot.ColorPrimary)
                    : bigSmall("Chắn (${item.even})"),
                item.even! == 11 || item.even == 12
                    ? bigSmallActive("Chẵn 11-12", ColorLot.ColorPrimary)
                    : bigSmall("Chẵn 11-12"),
                item.even! == 10
                    ? bigSmallActive("Hòa CL", ColorLot.ColorPrimary)
                    : bigSmall("Hòa CL"),
                item.odd! == 11 || item.odd == 12
                    ? bigSmallActive("Lẻ 11-12", ColorLot.ColorPrimary)
                    : bigSmall("Lẻ 11-12"),
                item.odd! == 10
                    ? bigSmallActive("Lẻ (${item.odd})", ColorLot.ColorPrimary)
                    : bigSmall("Lẻ (${item.odd})"),
              ]),
              const SizedBox(
                height: 2,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                item.big! > 10
                    ? bigSmallActive("Lớn (${item.big})", Colors.red)
                    : bigSmall("Lớn (${item.big})"),
                item.big! == 10
                    ? bigSmallActive("Hòa lớn nhỏ", Colors.red)
                    : bigSmall("Hòa lớn nhỏ"),
                item.small! > 10
                    ? bigSmallActive("Nhỏ (${item.small})", Colors.red)
                    : bigSmall("Nhỏ (${item.small})"),
              ]),
            ],
          ));
    } else {
      return SizedBox.shrink();
    }
  }

  Widget buildGeneral() {
    if (resultKenos != null) {
      List<String> results = [];
      for (int i = 0; i < resultKenos!.length; i++) {
        results.addAll(resultKenos![i].result!.split(','));
      }
      List<SelectItemModel> items = [];
      for (int i = 1; i <= 80; i++) {
        SelectItemModel item = SelectItemModel();
        item.text = i.toString().padLeft(2, '0');
        item.iValue = results
            .where((element) => element == i.toString().padLeft(2, '0'))
            .length;
        items.add(item);
      }
      items.sort((a, b) => b.iValue!.compareTo(a.iValue!));
      List<SelectItemModel> itemsTop = [];
      List<SelectItemModel> itemsBot = [];
      for (int i = 0; i < 10; i++) {
        itemsTop.add(items[i]);
      }
      for (int i = 1; i < 11; i++) {
        itemsBot.add(items[items.length - i]);
      }
      return Column(
        children: [
          Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 8, right: 8, top: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15.0,
                      offset: Offset(0.0, 0.75))
                ],
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Số về nhiều nhất",
                      style: TextStyle(color: ColorLot.ColorPrimary),
                    ),
                  ),
                  buildTop(itemsTop),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Số về ít nhất",
                      style: TextStyle(color: ColorLot.ColorPrimary),
                    ),
                  ),
                  buildBot(itemsBot)
                ],
              )),
          Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15.0,
                      offset: Offset(0.0, 0.75))
                ],
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Thống kê các kỳ xổ gần nhất",
                      style: TextStyle(color: ColorLot.ColorPrimary),
                    ),
                  ),
                  buildBall(items)
                ],
              )),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget buildTop(List<SelectItemModel> items) {
    return Wrap(
        alignment: WrapAlignment.center,
        children: items.map((e) {
          return Column(
            children: [
              Container(
                width: 60,
                margin: EdgeInsets.all(3),
                child: Row(
                  children: [
                    Text(e.text!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: 0.0,
                            color: ColorLot.ColorSuccess)),
                    Text(
                      " ${e.iValue!} lần",
                      style:
                          TextStyle(color: ColorLot.ColorPrimary, fontSize: 12),
                    )
                  ],
                ),
              ),
            ],
          );
        }).toList());
  }

  Widget buildBot(List<SelectItemModel> items) {
    return Wrap(
        alignment: WrapAlignment.center,
        children: items.map((e) {
          return Column(
            children: [
              Container(
                width: 60,
                margin: EdgeInsets.all(3),
                child: Row(
                  children: [
                    Text(e.text!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: 0.0,
                            color: ColorLot.ColorRandomFast)),
                    Text(
                      " ${e.iValue!} lần",
                      style:
                          TextStyle(color: ColorLot.ColorPrimary, fontSize: 12),
                    )
                  ],
                ),
              ),
            ],
          );
        }).toList());
  }

  Widget buildBall(List<SelectItemModel> items) {
    return Wrap(
        alignment: WrapAlignment.center,
        children: items.map((e) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 28,
                height: 28,
                margin: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorLot.ColorPrimary,
                    border: Border.all(color: ColorLot.ColorPrimary, width: 1)),
                child: InkWell(
                  onTap: () {},
                  child: Center(
                      child: Text(e.text!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              letterSpacing: 0.0,
                              color: Colors.white))),
                ),
              ),
              Container(
                  width: 50,
                  alignment: Alignment.center,
                  child: Text(
                    "${e.iValue!} lần",
                    style:
                        TextStyle(color: ColorLot.ColorPrimary, fontSize: 12),
                  )),
              SizedBox(
                height: 5,
              ),
            ],
          );
        }).toList());
  }

  // Widget _buidLink() {
  //   if (urlLive != null) {
  //     return SizedBox(
  //         width: double.infinity,
  //         height: 220,
  //         child: WebViewWidget(controller: _controller));
  //   } else {
  //     return SizedBox.shrink();
  //   }
  // }

  Widget _flipClock() {
    if (secondCountdown > 0) {
      return FlipCountdownClock(
        duration: Duration(seconds: secondCountdown),
        flipDirection: AxisDirection.down,
        digitSize: 26.0,
        width: 30.0,
        height: 40.0,
        separatorColor: ColorLot.ColorPrimary,
        digitColor: Colors.white,
        backgroundColor: ColorLot.ColorPrimary,
        // separatorColor: colors.onSurface,
        // borderColor: colors.primary,
        // hingeColor: colors.surface,
        onDone: () {
          setState(() {});
        },
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
