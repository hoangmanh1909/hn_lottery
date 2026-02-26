// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottery_flutter_application/controller/dictionary_controller.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/dimen.dart';
import 'package:lottery_flutter_application/utils/head_balance_view.dart';
import 'package:lottery_flutter_application/view/account/login_view.dart';
import 'package:lottery_flutter_application/view/tickets/vietlott/ticket_keno_advan_view.dart';
import 'package:lottery_flutter_application/view/tickets/vietlott/ticket_keno_base_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/common.dart';
import '../../../controller/account_controller.dart';
import '../../../models/request/player_base_request.dart';
import '../../../models/response/get_balance_response.dart';
import '../../../models/response/get_draw_keno_response.dart';
import '../../../models/response/player_profile.dart';
import '../../../utils/common.dart';
import '../../../utils/dialog_process.dart';

class TicketKenoView extends StatefulWidget {
  const TicketKenoView({Key? key, this.code}) : super(key: key);
  final String? code;
  @override
  State<TicketKenoView> createState() => _TicketKenoViewState();
}

class _TicketKenoViewState extends State<TicketKenoView>
    with TickerProviderStateMixin {
  final DictionaryController _con = DictionaryController();
  final AccountController _conAcc = AccountController();

  SharedPreferences? _prefs;
  PlayerProfile? playerProfile;

  GetDrawKenoResponse? drawKenoResponse;
  List<GetBalanceResponse>? balanceResponse;
  int balance = 0;

  int secondCountdown = 0;
  Timer? timer;
  String mode = "ON";
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getData();
    });
  }

  @override
  void dispose() {
    if (timer != null) timer!.cancel();
    super.dispose();
  }

  getData() async {
    _prefs = await SharedPreferences.getInstance();
    mode = _prefs!.getString(Common.SHARE_MODE_UPLOAD)!;
    String? userMap = _prefs?.getString('user');
    if (userMap != null) {
      setState(() {
        playerProfile = PlayerProfile.fromJson(jsonDecode(userMap));
      });
    } else {
      if (mounted) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginView()));
      }
    }
    if (mounted) {
      showProcess(context);
    }

    await getDrawKeno();
    await getBalance();
    if (mounted) {
      Navigator.pop(context);
    }
  }

  getBalance() async {
    if (playerProfile != null) {
      PlayerBaseRequest request =
          PlayerBaseRequest(mobileNumber: playerProfile!.mobileNumber!);
      ResponseObject res = await _conAcc.getBalance(request);
      if (res.code == "00") {
        if (mounted) {
          balanceResponse = List<GetBalanceResponse>.from((jsonDecode(res.data!)
              .map((model) => GetBalanceResponse.fromJson(model))));
          GetBalanceResponse bl = balanceResponse!
              .where((element) => element.accountType == "P")
              .first;
          setState(() {
            balance = bl.amount!;
          });
        }
      }
    }
  }

  getDrawKeno() async {
    if (mounted) {
      showProcess(context);
    }
    ResponseObject res = await _con.getDrawKeno();
    if (mounted) {
      Navigator.pop(context);
    }
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

  startTimer() {
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
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorLot.ColorPrimary,
          automaticallyImplyLeading: false,
          centerTitle: true,
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          title: Text("Keno"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          children: [
            Container(
                color: ColorLot.ColorBackground,
                padding: EdgeInsets.all(Dimen.padingDefault),
                child: Column(
                  children: [
                    headBalance(
                        balance,
                        mode,
                        playerProfile != null
                            ? playerProfile!.mobileNumber!
                            : ""),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Kỳ #${drawKenoResponse != null ? drawKenoResponse!.drawCode : ""} ",
                          style: TextStyle(
                              color: ColorLot.ColorPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),
                        ),
                        _countDownKeno()
                      ],
                    )
                  ],
                )),
            Expanded(
                child: DefaultTabController(
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
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
                                  width: size.width / 2 - 50,
                                  child: Tab(text: 'Cơ bản'),
                                ),
                                SizedBox(
                                  height: 40,
                                  width: size.width / 2 - 50,
                                  child: Tab(text: 'Chẵn lẻ - Lớn nhỏ'),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              // <-- Your TabBarView
                              children: [
                                TicketBaseKenoView(
                                    balance: balance,
                                    drawKeno: drawKenoResponse,
                                    code: widget.code),
                                TicketKenoAdvanView(
                                    balance: balance,
                                    drawKeno: drawKenoResponse),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )))
          ],
        ));
  }

  Widget _countDownKeno() {
    if (secondCountdown > 0) {
      Duration duration = Duration(seconds: secondCountdown);
      return Text(
        " thời gian còn ${padLeftTwo(duration.inMinutes.remainder(60))}:${padLeftTwo(duration.inSeconds.remainder(60))}",
        style: TextStyle(
            color: ColorLot.ColorPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 15),
      );
    } else {
      return Text(" thời gian còn 00:00",
          style: TextStyle(
              color: ColorLot.ColorPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 15));
    }
  }
}
