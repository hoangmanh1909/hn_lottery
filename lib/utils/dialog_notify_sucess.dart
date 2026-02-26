// ignore_for_file: prefer_const_constructors, unused_element

import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/dimen.dart';
import 'package:lottery_flutter_application/view/main/main_view.dart';

dialogBuilderSucess(BuildContext context, String title, String message) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        backgroundColor: ColorLot.ColorBackground,
        surfaceTintColor: Colors.transparent,
        titlePadding: EdgeInsets.all(10),
        contentPadding: EdgeInsets.all(10),
        actionsPadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        icon: Icon(
          Icons.check_circle,
          color: ColorLot.ColorSuccess,
          size: 51,
        ),
        content: message != ""
            ? Text(
                message,
                textAlign: TextAlign.center,
              )
            : SizedBox.shrink(),
        actions: <Widget>[
          InkWell(
            onTap: () => {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => MainView()),
                  (Route<dynamic> route) => false)
            },
            child: Container(
              alignment: Alignment.center,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimen.radiusBorder)),
                  color: ColorLot.ColorXSKT),
              child: Text(
                "Trang chủ",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      );
    },
  );
}
