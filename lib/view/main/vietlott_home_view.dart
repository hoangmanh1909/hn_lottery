// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/constants/common.dart';
import 'package:lottery_flutter_application/models/response/get_draw_keno_response.dart';
import 'package:lottery_flutter_application/models/response/get_jackpot_response.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:lottery_flutter_application/utils/CountdownLottery.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/dialog_process.dart';
import 'package:lottery_flutter_application/utils/scaffold_messger.dart';
import 'package:lottery_flutter_application/view/loto/loto_capso_view.dart';
import 'package:lottery_flutter_application/view/loto/loto_so_view.dart';
import 'package:lottery_flutter_application/view/main/kienthiet_view.dart';
import 'package:lottery_flutter_application/view/tickets/vietlott/ticket_3d_base_view.dart';
import 'package:lottery_flutter_application/view/tickets/vietlott/ticket_3d_view.dart';
import 'package:lottery_flutter_application/view/tickets/vietlott/ticket_keno_bag_view.dart';
import 'package:lottery_flutter_application/view/tickets/vietlott/ticket_keno_feed_od.dart';
import 'package:lottery_flutter_application/view/tickets/vietlott/ticket_keno_view.dart';
import 'package:lottery_flutter_application/view/tickets/vietlott/ticket_lotto_535.dart';
import 'package:lottery_flutter_application/view/tickets/vietlott/ticket_together_group_view.dart';
import 'package:lottery_flutter_application/view/tickets/vietlott/ticket_vietlott_base_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/dictionary_controller.dart';
import '../../utils/common.dart';
import '../../utils/dimen.dart';
import '../../utils/timer_app.dart';
import '../tickets/vietlott/ticket_keno_feed.dart';
import '../tickets/vietlott/ticket_together_view.dart';

class VietlottHomeView extends StatefulWidget {
  const VietlottHomeView({super.key});

  @override
  State<StatefulWidget> createState() => _VietlottHomeView();
}

class _VietlottHomeView extends State<VietlottHomeView> {
  final DictionaryController _con = DictionaryController();

  GetJackpotHomeResponse? jackpotHome;
  GetDrawKenoResponse? drawKenoResponse;
  DateTime? _datePower;
  DateTime? _dateMega;
  DateTime? _dateMax3D;
  String mode = "ON";
  String? drawCode;
  int secondCountdown = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    _datePower = dayPower();
    _dateMega = dayMega();
    _dateMax3D = dayMax3d();

    Future.delayed(Duration.zero, () {
      getData();
    });
  }

  getData() async {
    if (mounted) {
      showProcess(context);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mode = prefs.getString(Common.SHARE_MODE_UPLOAD)!;
    await getJackpotHome();
    await getDrawKeno();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  getJackpotHome() async {
    ResponseObject res = await _con.getJackpotHome();
    if (res.code == "00") {
      setState(() {
        jackpotHome = GetJackpotHomeResponse.fromJson(jsonDecode(res.data!));
      });
    }
  }

  getDrawKeno() async {
    ResponseObject res = await _con.getDrawKeno();
    if (res.code == "00") {
      setState(() {
        drawKenoResponse = GetDrawKenoResponse.fromJson(jsonDecode(res.data!));
        secondCountdown = drawKenoResponse!.closeTime!;
      });
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
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                child: Column(
              children: [
                buildProduct(
                    "assets/img/xskt.png",
                    "Hàng ngày",
                    "Xổ số kiến thiết",
                    ColorLot.ColorXSKT,
                    Common.ID_XSKT_MB,
                    "XSKT MB",
                    "",
                    Colors.black),
                buildProduct(
                    "assets/img/keno.png",
                    "Hàng ngày",
                    "Lô tô 2,3,5 số",
                    ColorLot.ColorLoto,
                    Common.ID_LOTO235,
                    "LOTO 235",
                    Common.KENO_BASE,
                    Colors.black),
                buildProduct(
                    "assets/img/keno.png",
                    "Hàng ngày",
                    "Lô tô 2,3,4 cặp số",
                    ColorLot.ColorLoto,
                    Common.ID_LOTO234,
                    "LOTO 235",
                    Common.KENO_BASE,
                    Colors.black),
                buildProduct(
                    "assets/img/keno.png",
                    "8 phút xổ",
                    "2.000.000.000",
                    ColorLot.ColorKeno,
                    Common.ID_KENO,
                    "KENO \n CƠ BẢN",
                    Common.KENO_BASE,
                    Colors.black),
                buildProduct(
                    "assets/img/keno.png",
                    "8 phút xổ",
                    "Chọn nhanh, tăng cơ hội",
                    ColorLot.ColorKeno,
                    Common.ID_KENO,
                    "KENO \n BAO",
                    Common.KENO_BAG,
                    Colors.black),
                buildProduct(
                    "assets/img/mega.png",
                    "Xổ vào 13h, 21h hàng ngày",
                    jackpotHome != null
                        ? formatAmount(jackpotHome!.lotto!)
                        : "0",
                    ColorLot.ColorLotto535,
                    Common.ID_LOTTO_535,
                    "LOTTO \n 5/35",
                    "",
                    Colors.black),
                buildProduct(
                    "assets/img/mega.png",
                    "Xổ vào Thứ 4,6,Chủ nhật",
                    jackpotHome != null
                        ? formatAmount(jackpotHome!.mega!)
                        : "0",
                    ColorLot.ColorPrimary,
                    Common.ID_MEGA,
                    "MEGA 6/45",
                    "",
                    Colors.white),
                buildProduct(
                    "assets/img/power.png",
                    "Xổ vào Thứ 3,5,7",
                    jackpotHome != null
                        ? formatAmount(jackpotHome!.power!)
                        : "0",
                    ColorLot.ColorPower,
                    Common.ID_POWER,
                    "POWER 6/55",
                    "",
                    Colors.white),
                buildProduct(
                    "assets/img/max_3dpro.png",
                    "Xổ vào Thứ 3,5,7",
                    "x200.000 lần",
                    ColorLot.Color3DPro,
                    Common.ID_MAX3D_PRO,
                    "MAX3D PRO",
                    "",
                    Colors.white),
                buildProduct(
                    "assets/img/max3dcongtrang.png",
                    "Xổ vào Thứ 2,4,6",
                    "x100.000 lần",
                    ColorLot.Color3D,
                    Common.ID_MAX3D_PLUS,
                    "MAX3D+",
                    "",
                    Colors.white),
                buildProduct(
                    "assets/img/max3dtrang.png",
                    "Xổ vào Thứ 2,4,6",
                    "x100 lần",
                    ColorLot.Color3D,
                    Common.ID_MAX3D,
                    "MAX3D",
                    "",
                    Colors.white),
                SizedBox(
                  height: Dimen.marginDefault,
                ),
              ],
            ))));
  }

  Widget buildProduct(String logo, String title, String prize, Color color,
      int product, String productName, String type, Color textColor) {
    return InkWell(
      onTap: () {
        booking(product, type);
      },
      child: Container(
        height: 88,
        margin: EdgeInsets.only(
            left: Dimen.marginHome,
            right: Dimen.marginHome,
            top: Dimen.marginHome),
        width: double.infinity,
        color: color,
        child: Row(
          children: [
            Container(
                width: 100,
                height: double.infinity,
                padding: EdgeInsets.all(Dimen.padingDefault),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimen.radiusBorder),
                      bottomLeft: Radius.circular(Dimen.radiusBorder)),
                ),
                child:
                    product == Common.ID_XSKT_MB || product == Common.ID_LOTO235
                        ? buildXSKT(product)
                        : buildHot(productName, type, textColor)),
            Expanded(
                child: Padding(
                    padding: EdgeInsets.all(Dimen.padingDefault),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              color: textColor,
                              fontSize: Dimen.fontSizeDefault),
                        ),
                        Text(
                          prize,
                          style: TextStyle(
                              color: textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        _buildCountdown(product),
                      ],
                    )))
          ],
        ),
      ),
    );
  }

  Widget buildXSKT(int productId) {
    if (productId == Common.ID_LOTO235 || productId == Common.ID_LOTO234) {
      return Image(
        image: AssetImage("assets/img/logo_loto.png"),
        width: 50,
      );
    }
    return Image(
      image: AssetImage("assets/img/xskt.png"),
      width: 50,
    );
  }

  Widget buildHot(String productName, String type, Color textColor) {
    // if (type == Common.KENO_FEED ||
    //     type == Common.KENO_BAG ||
    //     type == Common.KENO_FEED_OD) {
    //   return Column(
    //     children: [
    //       Container(
    //         alignment: Alignment.bottomRight,
    //         child: Image(
    //           image: AssetImage("assets/img/hot.png"),
    //           width: 35,
    //         ),
    //       ),
    //       Text(
    //         productName,
    //         textAlign: TextAlign.center,
    //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    //       )
    //     ],
    //   );
    // }
    return Text(
      productName,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  booking(int productID, String type) {
    if (productID == Common.ID_KENO) {
      if (type == Common.KENO_BASE) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TicketKenoView()));
      } else if (type == Common.KENO_BAG) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TicketKenoBagView()));
      } else if (type == Common.KENO_FEED) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TicketKenoFeedView()));
      } else if (type == Common.KENO_FEED_OD) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TicketKenoFeedODView()));
      }
    } else if (productID == Common.ID_MEGA || productID == Common.ID_POWER) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TicketVietlottBaseView(
                    productID: productID,
                  )));
    } else if (productID == Common.ID_MAX3D_PLUS ||
        productID == Common.ID_MAX3D_PRO) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Ticket3DView(
                    productID: productID,
                  )));
    } else if (productID == Common.ID_MAX3D) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Ticket3DBaseView(
                    type: 3,
                  )));
    } else if (productID == Common.ID_BAOCHUNG) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => TicketTogetherView()));
    } else if (productID == Common.ID_NHOMCHUNG) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => TicketTogetherGroupView()));
    } else if (productID == Common.ID_LOTTO_535) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => TicketLotto535View()));
    } else if (productID == Common.ID_XSKT_MB) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => KienThietView()));
    } else if (productID == Common.ID_LOTO235) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LotoSoView()));
    } else if (productID == Common.ID_LOTO234) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LotoCapSoView()));
    } else {
      showMessage(context, "Sản phẩm đang cập nhật", "99");
    }
  }

  Widget _buildCountdown(int product) {
    if (product == Common.ID_KENO) {
      return _countDownKeno();
    } else if (product == Common.ID_MEGA) {
      return _countDownMega();
    } else if (product == Common.ID_LOTTO_535 ||
        product == Common.ID_XSKT_MB ||
        product == Common.ID_LOTO235 ||
        product == Common.ID_LOTO234) {
      return CountdownLottery();
    } else if (product == Common.ID_POWER || product == Common.ID_MAX3D_PRO) {
      return _countDownPower();
    } else if (product == Common.ID_MAX3D || product == Common.ID_MAX3D_PLUS) {
      return _countDownMax3D();
    } else if (product == Common.ID_BAOCHUNG ||
        product == Common.ID_NHOMCHUNG) {
      return Text(
        "Tăng cơ hội trúng thưởng",
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: Dimen.fontSizeDefault),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _countDownKeno() {
    if (secondCountdown > 0) {
      Duration duration = Duration(seconds: secondCountdown);
      return Text(
        "Thời gian còn ${padLeftTwo(duration.inMinutes.remainder(60))}:${padLeftTwo(duration.inSeconds.remainder(60))}",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: Dimen.fontSizeDefault),
      );
    } else {
      return Text(
        "Thời gian còn 00:00",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: Dimen.fontSizeDefault),
      );
    }
  }

  Widget _countDownMega() {
    if (_dateMega != null) {
      return Row(
        children: [
          Text(
            "Thời gian còn ",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: Dimen.fontSizeDefault),
          ),
          TimerApp(
            eventTime: _dateMega!,
            textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: Dimen.fontSizeDefault),
          )
        ],
      );
    } else {
      return Text(
        "Thời gian còn 00:00:00:00",
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: Dimen.fontSizeDefault),
      );
    }
  }

  Widget _countDownPower() {
    if (_datePower != null) {
      return Row(
        children: [
          Text(
            "Thời gian còn ",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: Dimen.fontSizeDefault),
          ),
          TimerApp(
            eventTime: _datePower!,
            textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: Dimen.fontSizeDefault),
          )
        ],
      );
    } else {
      return Text(
        "Thời gian còn 00:00:00:00",
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: Dimen.fontSizeDefault),
      );
    }
  }

  Widget _countDownMax3D() {
    if (_dateMax3D != null) {
      return Row(
        children: [
          Text(
            "Thời gian còn ",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: Dimen.fontSizeDefault),
          ),
          TimerApp(
            eventTime: _dateMax3D!,
            textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: Dimen.fontSizeDefault),
          )
        ],
      );
    } else {
      return Text(
        "Thời gian còn 00:00:00:00",
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: Dimen.fontSizeDefault),
      );
    }
  }
}
