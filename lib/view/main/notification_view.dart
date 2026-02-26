// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottery_flutter_application/controller/dictionary_controller.dart';
import 'package:lottery_flutter_application/models/request/notification_update_request.dart';
import 'package:lottery_flutter_application/models/response/notification_response.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/scaffold_messger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/response/player_profile.dart';
import '../../../models/response/response_object.dart';
import '../../../utils/box_shadow.dart';
import '../../../utils/common.dart';
import '../../../utils/dialog_process.dart';
import '../../../utils/dimen.dart';
import '../../constants/common.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<StatefulWidget> createState() => _NotificationView();
}

class _NotificationView extends State<NotificationView> {
  final DictionaryController _con = DictionaryController();
  SharedPreferences? _prefs;
  PlayerProfile? playerProfile;
  bool isBack = false;

  List<NotificationSearchResponse> notication = [];
  String mode = "ON";
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      initPref();
    });
  }

  initPref() async {
    _prefs = await SharedPreferences.getInstance();
    mode = _prefs!.getString(Common.SHARE_MODE_UPLOAD)!;
    String? userMap = _prefs?.getString('user');
    if (userMap != null) {
      setState(() {
        playerProfile = PlayerProfile.fromJson(jsonDecode(userMap));
      });
      if (mode == Common.ANDROID_MODE_UPLOAD) {
        getHistory();
      }
    }
  }

  getHistory() async {
    if (mounted) showProcess(context);

    ResponseObject res =
        await _con.getNotification(playerProfile!.mobileNumber!);
    if (res.code == "00") {
      notication = List<NotificationSearchResponse>.from((jsonDecode(res.data!)
          .map((model) => NotificationSearchResponse.fromJson(model))));
      isBack = true;
      setState(() {});
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  updateRead(int id) async {
    if (mounted) showProcess(context);
    NotificationUpdateReadRequest req = NotificationUpdateReadRequest();
    req.iD = id;
    req.mobileNumber = playerProfile!.mobileNumber!;
    ResponseObject res = await _con.updateNotification(req);
    if (res.code == "00") {
      isBack = true;
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  updateReadAll() async {
    NotificationUpdateReadRequest req = NotificationUpdateReadRequest();
    req.mobileNumber = playerProfile!.mobileNumber!;
    ResponseObject res = await _con.updateNotification(req);

    if (res.code == "00") {
      if (mounted) {
        isBack = true;
        showMessage(context, "Đã đọc tất cả thông báo", "00");
      }
    } else {
      if (mounted) {
        showMessage(context, res.message!, "99");
      }
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
          title: Text("Thông báo"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop(isBack);
            },
          ),
          // actions: [
          //   IconButton(
          //     icon: const Icon(
          //       Ionicons.checkmark_done_outline,
          //       color: Colors.white,
          //     ),
          //     onPressed: () {
          //       updateReadAll();
          //     },
          //   )
          // ],
        ),
        body: buildBody());
  }

  Widget buildBody() {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: notication.map((item) {
            return InkWell(
                onTap: () {
                  updateRead(item.iD!);
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Ionicons.reader_outline,
                                  color: Colors.black45,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                item.isRead! == "N"
                                    ? textBold(item.title)
                                    : textBoldRead(item.title)
                              ],
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Ionicons.chatbox_outline,
                                  color: Colors.black45,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Flexible(
                                    child: Text(item.content!,
                                        style: TextStyle(
                                            fontWeight: item.isRead == "N"
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                            color: Colors.black,
                                            fontSize: Dimen.fontSizeDefault)))
                              ],
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Ionicons.calendar_outline,
                                  color: Colors.black45,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(item.createdDate!,
                                    style: TextStyle(
                                        fontSize: Dimen.fontSizeDefault,
                                        color: item.isRead == "N"
                                            ? Colors.black
                                            : Colors.black54))
                              ],
                            )
                          ],
                        )),
                        type(item.isType!, item.addInfo!),
                      ],
                    )));
          }).toList(),
        ),
      ),
    );
  }

  Widget type(String isType, String mes) {
    String text = "";
    if (isType == "D") {
      text = "-";
      return Container(
          width: 110,
          alignment: Alignment.topRight,
          child: Text(
            text + formatAmountD(int.parse(mes)),
            style: TextStyle(
                fontSize: Dimen.fontSizeAmount,
                color: Colors.black,
                fontWeight: FontWeight.w600),
          ));
    } else if (isType == "C") {
      text = "+";
      return Container(
          width: 110,
          alignment: Alignment.topRight,
          child: Text(
            text + formatAmountD(int.parse(mes)),
            style: TextStyle(
                fontSize: Dimen.fontSizeAmount,
                color: ColorLot.ColorPrimary,
                fontWeight: FontWeight.w600),
          ));
    }
    return SizedBox.shrink();
  }

  Widget textBold(text) {
    return Flexible(
        child: Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: Dimen.fontSizeValue,
          color: Colors.black),
      softWrap: true,
    ));
  }

  Widget textBoldRead(text) {
    return Flexible(
        child: Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: Dimen.fontSizeValue,
          color: Colors.black54),
      softWrap: true,
    ));
  }
}
