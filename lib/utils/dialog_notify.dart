// ignore_for_file: prefer_const_constructors, unused_element

import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/dimen.dart';

dialogNotify(BuildContext context, String title, String message) {
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
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        content: message != ""
            ? Text(
                message,
                textAlign: TextAlign.center,
              )
            : SizedBox.shrink(),
        actions: <Widget>[
          InkWell(
            onTap: () => {Navigator.pop(context)},
            child: Container(
              alignment: Alignment.center,
              height: 40,
              decoration: BoxDecoration(
                  color: ColorLot.ColorPrimary,
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimen.radiusBorder)),
                  border: Border.all(color: ColorLot.ColorPrimary, width: 1)),
              child: Text(
                "Đóng",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      );
    },
  );
}
