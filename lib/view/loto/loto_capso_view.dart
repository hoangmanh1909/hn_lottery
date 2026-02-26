// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/models/response/get_draw_keno_response.dart';
import 'package:lottery_flutter_application/models/response/get_jackpot_response.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';

import '../../utils/box_shadow.dart';
import '../../utils/common.dart';
import '../../utils/dimen.dart';
import '../../utils/timer_app.dart';
import '../tickets/loto/ticket_loto_capso_view.dart';

class LotoCapSoView extends StatefulWidget {
  const LotoCapSoView({super.key});

  @override
  State<StatefulWidget> createState() => _LotoCapSoView();
}

class _LotoCapSoView extends State<LotoCapSoView> {
  GetJackpotHomeResponse? jackpotHome;
  GetDrawKenoResponse? drawKenoResponse;
  final DateTime _dateLoto = dayFullWeek();

  String? drawCode;
  int secondCountdown = 0;
  Timer? timer;

  void startTimer() {
    Duration oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (secondCountdown == 0) {
          setState(() {
            secondCountdown = 480;
          });
        } else {
          setState(() {
            secondCountdown--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    if (timer != null) timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          title: const Text("Lô tô 2,3,4 cặp số",
              style: TextStyle(color: Colors.white, fontSize: 16)),
          backgroundColor: ColorLot.ColorPrimary,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Scaffold(
            backgroundColor: ColorLot.ColorBackground,
            body: SingleChildScrollView(
                child: Column(
              children: [
                buildProduct("Lô tô 2 cặp số", "x10 lần", 2),
                buildProduct("Lô tô 3 cặp số", "x45 lần", 3),
                buildProduct("Lô tô 4 cặp số", "x110 lần", 4),
                SizedBox(
                  height: Dimen.marginDefault,
                )
              ],
            ))));
  }

  bookTicketLoto(int type) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TicketLotoCapSoView(
                  type: type,
                )));
  }

  Widget buildProduct(String name, String prize, int product) {
    return InkWell(
      onTap: () => bookTicketLoto(product),
      child: Container(
        height: 90,
        padding: EdgeInsets.all(Dimen.padingDefault),
        margin: EdgeInsets.only(
            left: Dimen.marginDefault,
            right: Dimen.marginDefault,
            top: Dimen.marginDefault),
        width: double.infinity,
        color: ColorLot.ColorBaoChung,
        child: Row(
          children: [
            Container(
              width: 90,
              height: double.infinity,
              padding: EdgeInsets.all(16),
              child: Image(
                image: AssetImage("assets/img/logo_loto.png"),
                width: 50,
              ),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hàng ngày",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  "$name - $prize",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                _buildCountdown(),
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildCountdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Thời gian còn ",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
        ),
        TimerApp(
          eventTime: _dateLoto,
          textStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
        )
      ],
    );
  }
}
