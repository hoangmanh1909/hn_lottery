// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/constants/common.dart';
import 'package:lottery_flutter_application/models/response/get_draw_keno_response.dart';
import 'package:lottery_flutter_application/models/response/get_jackpot_response.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/view/tickets/loto/ticket_loto_636_view.dart';

import '../../utils/box_shadow.dart';
import '../../utils/common.dart';
import '../../utils/dimen.dart';
import '../../utils/timer_app.dart';

class Loto636View extends StatefulWidget {
  const Loto636View({super.key});

  @override
  State<StatefulWidget> createState() => _Loto636View();
}

class _Loto636View extends State<Loto636View> {
  GetJackpotHomeResponse? jackpotHome;
  GetDrawKenoResponse? drawKenoResponse;
  final DateTime _dateLoto = day636();

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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: ColorLot.ColorBackground,
            body: SingleChildScrollView(
                child: Column(
              children: [
                buildProduct("Xổ số điện toán 6x36", "Lên tới 6 tỷ đồng",
                    Common.ID_LOTO235),
                SizedBox(
                  height: Dimen.marginDefault,
                )
              ],
            ))));
  }

  Widget buildProduct(String name, String prize, int product) {
    return InkWell(
      onTap: () => {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TicketLoto636View()))
      },
      child: Container(
        height: 110,
        padding: EdgeInsets.all(Dimen.padingDefault),
        margin: EdgeInsets.only(
            left: Dimen.marginDefault,
            right: Dimen.marginDefault,
            top: Dimen.marginDefault),
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[boxShadow()],
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(Dimen.radiusBorder)),
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimen.radiusBorder),
                    bottomLeft: Radius.circular(Dimen.radiusBorder)),
              ),
              child: Image(
                image: AssetImage("assets/img/mienbac.png"),
              ),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Xổ vào thứ 4,7",
                  style: TextStyle(color: Colors.black45, fontSize: 12),
                ),
                Text(
                  name,
                  style: TextStyle(
                      color: ColorLot.ColorPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  prize,
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Thời gian còn ",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 12),
        ),
        TimerApp(
          eventTime: _dateLoto,
          textStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 12),
        )
      ],
    );
  }
}
