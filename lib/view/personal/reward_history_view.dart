import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/controller/reward_controller.dart';
import 'package:lottery_flutter_application/models/request/reward_exchage_search_request.dart';
import 'package:lottery_flutter_application/models/response/player_profile.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:lottery_flutter_application/models/response/reward_exchage_search_response.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/common.dart';
import 'package:lottery_flutter_application/utils/dialog_payment.dart';
import 'package:lottery_flutter_application/utils/dialog_process.dart';
import 'package:lottery_flutter_application/utils/text_amount.dart';
import 'package:lottery_flutter_application/utils/text_bold.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardHistoryView extends StatefulWidget {
  const RewardHistoryView({Key? key}) : super(key: key);

  @override
  State<RewardHistoryView> createState() => _RewardHistoryViewState();
}

class _RewardHistoryViewState extends State<RewardHistoryView> {
  final RewardController _con = RewardController();

  SharedPreferences? prefs;
  PlayerProfile? playerProfile;
  List<RewardExchangeSearchResponse> models = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      initPref();
    });
  }

  initPref() async {
    prefs = await SharedPreferences.getInstance();
    String? userMap = prefs?.getString('user');

    if (userMap != null) {
      setState(() {
        playerProfile = PlayerProfile.fromJson(jsonDecode(userMap));
      });
      getItems();
    }
  }

  getItems() async {
    if (mounted) showProcess(context);

    RewardExchangeSearchRequest req = RewardExchangeSearchRequest();
    req.mobileNumber = playerProfile!.mobileNumber;
    ResponseObject res = await _con.getRewardHistory(req);
    if (res.code == "00") {
      setState(() {
        models = List<RewardExchangeSearchResponse>.from((jsonDecode(res.data!)
            .map((model) => RewardExchangeSearchResponse.fromJson(model))));
      });
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorLot.ColorPrimary,
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        title: const Text('Lịch sử đổi thưởng'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: buildItem(),
    );
  }

  Widget buildItem() {
    if (models.isNotEmpty) {
      return Container(
          color: ColorLot.ColorBackground,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: models.length,
              itemBuilder: (BuildContext ctxt, int index) {
                RewardExchangeSearchResponse item = models[index];
                return Container(
                    color: Colors.white,
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.all(4),
                    child: Row(children: [
                      Expanded(
                          child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.person_outline,
                                size: 15,
                              ),
                              textBold(item.accountName!, Colors.black),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.credit_card_outlined,
                                size: 15,
                              ),
                              Text(item.accountNumber!),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.account_balance_outlined,
                                size: 15,
                              ),
                              Text(
                                item.bankName!,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.date_range_outlined,
                                size: 15,
                              ),
                              Text(
                                item.createdDate!,
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ],
                          )
                        ],
                      )),
                      SizedBox(
                        width: 120,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            textBold("#${item.retRefNumber!}", Colors.black),
                            buildStatus(item),
                            textAmount(formatAmountD(item.amount))
                          ],
                        ),
                      )
                    ]));
              }));
    }
    return const SizedBox.shrink();
  }

  Widget buildStatus(RewardExchangeSearchResponse item) {
    if (item.status == "P") {
      return const Text(
        "Chờ xác nhận",
        style: TextStyle(color: ColorLot.ColorWarring, fontSize: 15),
      );
    } else {
      return const Text(
        "Hoàn thành",
        style: TextStyle(color: ColorLot.ColorSuccess, fontSize: 15),
      );
    }
  }
}
