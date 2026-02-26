// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottery_flutter_application/controller/history_controller.dart';
import 'package:lottery_flutter_application/models/response/order_list.response.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/view/account/login_view.dart';
import 'package:lottery_flutter_application/view/tickets/vietlott/ticket_keno_feed_history_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/response/player_profile.dart';
import '../../../models/response/response_object.dart';
import '../../../utils/box_shadow.dart';
import '../../../utils/common.dart';
import '../../../utils/dialog_process.dart';
import '../../../utils/dimen.dart';

class TicketKenoFeedHistoryView extends StatefulWidget {
  const TicketKenoFeedHistoryView({super.key});

  @override
  State<StatefulWidget> createState() => _TicketKenoFeedHistoryView();
}

class _TicketKenoFeedHistoryView extends State<TicketKenoFeedHistoryView> {
  final HistoryController _con = HistoryController();
  SharedPreferences? _prefs;
  PlayerProfile? playerProfile;

  List<OrderListResponse> orderList = [];

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
      getHistory();
    } else {
      if (mounted) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginView()));
      }
    }
  }

  getHistory() async {
    if (mounted) showProcess(context);

    ResponseObject res =
        await _con.getDataListHistory(playerProfile!.mobileNumber!);
    if (res.code == "00") {
      orderList = List<OrderListResponse>.from((jsonDecode(res.data!)
          .map((model) => OrderListResponse.fromJson(model))));

      setState(() {});
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
          title: Text("Lịch sử nuôi Keno"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: buildBody());
  }

  Widget buildBody() {
    if (orderList.isEmpty) {
      return Container(
        color: Colors.white,
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 50),
        child: Column(
          children: const [
            Icon(
              Icons.content_paste_outlined,
              size: 40,
              color: Colors.black54,
            ),
            SizedBox(
              height: 10,
            ),
            Text("Bạn chưa có đơn hàng nào!")
          ],
        ),
      );
    }
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: orderList.map((item) {
            return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TicketKenoFeedHistoryDetailView(
                              code: item.code!)));
                },
                child: Container(
                    padding: EdgeInsets.all(Dimen.padingDefault),
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[boxShadow()],
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.all(Radius.circular(Dimen.radiusBorder)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Ionicons.code_outline,
                                      size: 12,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: textBold(item.code))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Ionicons.person_outline,
                                      size: 12,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: textBold(item.name))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Ionicons.calendar_outline,
                                      size: 12,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: textBold(item.createdDate))
                                  ],
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  formatAmountD(item.amount),
                                  style: TextStyle(
                                      fontSize: Dimen.fontSizeAmount,
                                      color: ColorLot.ColorPrimary,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 1,
                                          color: ColorLot.ColorRandomFast,
                                          style: BorderStyle.solid)),
                                  child: Text(
                                    item.type == 1
                                        ? "Hệ thống tự chọn"
                                        : "Tự đặt nuôi",
                                    style: TextStyle(
                                      fontSize: Dimen.fontSizeDefault,
                                      color: ColorLot.ColorRandomFast,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Tổng: "),
                                  Text(
                                    formatAmount(item.quantity),
                                    style: TextStyle(
                                        fontSize: Dimen.fontSizeAmount,
                                        color: ColorLot.ColorPrimary,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Đã in: "),
                                  Text(
                                    formatAmount(item.quantityPrint),
                                    style: TextStyle(
                                        fontSize: Dimen.fontSizeAmount,
                                        color: ColorLot.ColorSuccess,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Đã hủy: "),
                                  Text(
                                    formatAmount(item.quantityCancel),
                                    style: TextStyle(
                                        fontSize: Dimen.fontSizeAmount,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    )));
          }).toList(),
        ),
      ),
    );
  }

  Widget textBold(text) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: Dimen.fontSizeDefault,
          color: Colors.black),
    );
  }
}
