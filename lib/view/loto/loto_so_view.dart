// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/models/response/get_draw_keno_response.dart';
import 'package:lottery_flutter_application/models/response/get_jackpot_response.dart';
import 'package:lottery_flutter_application/utils/box_shadow.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/view/tickets/loto/ticket_loto_view.dart';

import '../../utils/common.dart';
import '../../utils/dimen.dart';
import '../../utils/timer_app.dart';

class LotoSoView extends StatefulWidget {
  const LotoSoView({super.key});

  @override
  State<StatefulWidget> createState() => _LotoSoView();
}

class _LotoSoView extends State<LotoSoView> {
  GetJackpotHomeResponse? jackpotHome;
  GetDrawKenoResponse? drawKenoResponse;
  final DateTime _dateLoto = dayFullWeek();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorLot.ColorPrimary,
          automaticallyImplyLeading: false,
          centerTitle: true,
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          title: Text("Lô tô 2,3,5 số"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Scaffold(
            backgroundColor: ColorLot.ColorBackground,
            body: SingleChildScrollView(
                child: Column(
              children: [
                buildProduct("Lô tô 2 số", "x70 lần", 2),
                // buildProduct(
                //     "Bao Lô tô 2 số XSĐT Thủ Đô", "x70 lần, chọn số nhanh", 2),
                buildProduct("Lô tô 3 số", "x420 lần", 3),
                buildProduct("Lô tô 5 số", "x20.000 lần", 5),
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
            builder: (context) => TicketLotoView(
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
                padding: EdgeInsets.all(Dimen.padingDefault),
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage("assets/img/logo_loto.png"),
                  width: 50,
                )),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hàng ngày",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  "$name - $prize",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
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
