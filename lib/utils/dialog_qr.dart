// ignore_for_file: prefer_const_constructors, unused_element

import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/dimen.dart';
import 'package:lottery_flutter_application/view/main/main_view.dart';
import 'package:qr_flutter/qr_flutter.dart';

dialogQR(BuildContext context, String value) {
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
        content: Container(
          width: 300,
          height: 60,
          alignment: Alignment.center,
          child: Column(
            children: const [
              Flexible(
                  child: Text(
                "Cám ơn bạn đã sử dụng My Lott. My Lott hỗ trợ bạn xem kết quả, tạm tính giá vé.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: Dimen.fontSizeDefault),
                softWrap: true,
              )),
              // QrImageView(
              //   data: value,
              //   version: QrVersions.auto,
              //   size: 200.0,
              // )
            ],
          ),
        ),
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
                  border: Border.all(color: ColorLot.ColorSuccess, width: 1)),
              child: Text(
                "Trang chủ",
                style: TextStyle(color: ColorLot.ColorSuccess),
              ),
            ),
          )
        ],
      );
    },
  );
}
