// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottery_flutter_application/controller/reward_controller.dart';
import 'package:lottery_flutter_application/utils/common.dart';
import 'package:lottery_flutter_application/view/personal/reward_history_view.dart';
import 'package:lottery_flutter_application/view/personal/reward_view.dart';
import 'package:lottery_flutter_application/widgets/icon_with_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/request/player_base_request.dart';
import '../../models/response/get_balance_response.dart';
import '../../models/response/player_profile.dart';
import '../../models/response/response_object.dart';
import '../../utils/color_lot.dart';
import '../../utils/dimen.dart';

class RewardCateView extends StatefulWidget {
  const RewardCateView({Key? key}) : super(key: key);

  @override
  State<RewardCateView> createState() => _RewardCateViewState();
}

class _RewardCateViewState extends State<RewardCateView> {
  final RewardController _con = RewardController();
  SharedPreferences? _prefs;
  PlayerProfile? playerProfile;
  List<GetBalanceResponse>? balanceResponse;
  int balance = 0;

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
      getBalance();
    }
  }

  getBalance() async {
    if (playerProfile != null) {
      PlayerBaseRequest request =
          PlayerBaseRequest(mobileNumber: playerProfile!.mobileNumber!);
      ResponseObject res = await _con.getBalance(request);
      if (res.code == "00") {
        if (mounted) {
          balanceResponse = List<GetBalanceResponse>.from((jsonDecode(res.data!)
              .map((model) => GetBalanceResponse.fromJson(model))));
          GetBalanceResponse bl = balanceResponse!
              .where((element) => element.accountType == "W")
              .first;
          setState(() {
            balance = bl.amount!;
          });
        }
      }
    }
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
          title: const Text('Hình thức đổi thưởng'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.history,
                color: Colors.white,
              ),
              onPressed: () {
                Future.delayed(Duration.zero, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RewardHistoryView()));
                });
              },
            )
          ],
        ),
        body: Scaffold(
            backgroundColor: ColorLot.ColorBackground,
            body: Container(
                height: size.height,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Ionicons.wallet_outline,
                              size: 20, color: ColorLot.ColorPrimary),
                          Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Text("Số dư đổi thưởng"),
                          )
                        ],
                      ),
                      Text(
                        formatAmountD(balance),
                        style: TextStyle(
                            color: ColorLot.ColorPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  Container(
                      padding: EdgeInsets.all(Dimen.padingDefault),
                      height: 60,
                      margin: EdgeInsets.only(
                          left: Dimen.marginDefault,
                          right: Dimen.marginDefault,
                          top: Dimen.marginDefault),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                            Radius.circular(Dimen.radiusBorder)),
                      ),
                      child: InkWell(
                        onTap: () => {
                          Future.delayed(Duration.zero, () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RewardView(
                                          type: 1,
                                        )));
                          })
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconWithBackground(icon: Ionicons.wallet),
                                Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Text(
                                    "Nạp vào tài khoản đặt vé",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            ),
                            Icon(
                              Ionicons.chevron_forward_outline,
                              color: ColorLot.ColorPrimary,
                            ),
                          ],
                        ),
                      )),
                  Container(
                      padding: EdgeInsets.all(Dimen.padingDefault),
                      height: 60,
                      margin: EdgeInsets.only(
                          left: Dimen.marginDefault,
                          right: Dimen.marginDefault,
                          top: Dimen.marginDefault),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                            Radius.circular(Dimen.radiusBorder)),
                      ),
                      child: InkWell(
                        onTap: () => {
                          Future.delayed(Duration.zero, () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RewardView(
                                          type: 2,
                                        )));
                          })
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconWithBackground(icon: Icons.account_balance),
                                Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Text(
                                    "Chuyển khoản ngân hàng",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            ),
                            Icon(
                              Ionicons.chevron_forward_outline,
                              color: ColorLot.ColorPrimary,
                            ),
                          ],
                        ),
                      ))
                ]))));
  }
}
