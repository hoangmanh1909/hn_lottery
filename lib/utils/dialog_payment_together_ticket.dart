// ignore_for_file: prefer_const_constructors, unused_element, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/controller/payment_controller.dart';
import 'package:lottery_flutter_application/models/request/order_add_request.dart';
import 'package:lottery_flutter_application/models/request/together_payment.dart';
import 'package:lottery_flutter_application/models/request/trans_payment_request.dart';
import 'package:lottery_flutter_application/models/response/player_profile.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/common.dart';
import 'package:lottery_flutter_application/utils/dimen.dart';
import 'package:lottery_flutter_application/utils/widget_divider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/common.dart';
import '../models/response/response_object.dart';
import 'dialog_notify_sucess.dart';
import 'dialog_process.dart';
import 'scaffold_messger.dart';

dialogPaymentTogetherTicket(
    BuildContext context,
    PlayerProfile profile,
    OrderAddNewRequest orderAddNewRequest,
    String code,
    SharedPreferences? preferences) {
  PaymentController con = PaymentController();
  onOk() async {
    TogetherTicketPaymentRequest req = TogetherTicketPaymentRequest();
    req.mobileNumber = profile.mobileNumber!;
    req.fee = orderAddNewRequest.fee!;
    req.transDes = "Thanh toán bao chung";
    req.retRefNumber = code;
    if (context.mounted) {
      showProcess(context);
    }
    ResponseObject res = await con.paymentTogetherTicket(req);
    if (context.mounted) Navigator.pop(context);
    if (res.code == "00") {
      if (context.mounted) {
        if (context.mounted) Navigator.pop(context);

        preferences!.setString(Common.MAIN_INDEX, "0");

        dialogBuilderSucess(
            context, "Thanh toán thành công", "Mã đơn hàng $code");
      }
    } else {
      if (context.mounted) showMessage(context, res.message!, "98");
    }
  }

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
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
        title: Text("Xác nhận thanh toán",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16)),
        content: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(Dimen.padingDefault),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.all(Radius.circular(Dimen.radiusBorderButton)),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [textLable("Mã thanh toán"), textValue(code)],
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [textLable("Họ tên"), textValue(profile.name!)],
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [textLable("Số GTTT"), textValue(profile.pIDNumber!)],
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  textLable("Email"),
                  textValue(profile.emailAddress!)
                ],
              ),
              dividerLot(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  textLable("Tiền vé"),
                  textValue(formatAmountD(orderAddNewRequest.amount))
                ],
              ),
              buildFee(orderAddNewRequest),
              SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  textLable("Tổng tiền"),
                  textValueAmount(formatAmountD(
                      orderAddNewRequest.amount! + orderAddNewRequest.fee!))
                ],
              ),
            ])),
        actions: <Widget>[
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => {Navigator.pop(context)},
                  child: Container(
                    alignment: Alignment.center,
                    height: Dimen.buttonHeight,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(Dimen.radiusBorderButton)),
                        border:
                            Border.all(color: ColorLot.ColorPrimary, width: 1)),
                    child: Text(
                      "Đóng",
                      style: TextStyle(color: ColorLot.ColorPrimary),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: InkWell(
                onTap: onOk,
                child: Container(
                  alignment: Alignment.center,
                  height: Dimen.buttonHeight,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(Dimen.radiusBorderButton)),
                      border:
                          Border.all(color: ColorLot.ColorSuccess, width: 1)),
                  child: Text(
                    "Đặt vé",
                    style: TextStyle(color: ColorLot.ColorSuccess),
                  ),
                ),
              ))
            ],
          )
        ],
      );
    },
  );
}

Widget textLable(String lable) {
  return Text(
    lable,
    style: TextStyle(color: Colors.black54, fontSize: Dimen.fontSizeLable),
  );
}

Widget textValue(String lable) {
  return Flexible(
      child: Text(
    lable,
    textAlign: TextAlign.right,
    style: TextStyle(
        color: Colors.black,
        fontSize: Dimen.fontSizeValue,
        fontWeight: FontWeight.w600),
  ));
}

Widget textValueAmount(String lable) {
  return Flexible(
      child: Text(
    lable,
    textAlign: TextAlign.right,
    style: TextStyle(
        color: ColorLot.ColorPrimary,
        fontSize: Dimen.fontSizeValue,
        fontWeight: FontWeight.w600),
  ));
}

Widget buildFee(OrderAddNewRequest orderAddNewRequest) {
  if (orderAddNewRequest.productID == Common.ID_LOTO234 ||
      orderAddNewRequest.productID == Common.ID_LOTO235 ||
      orderAddNewRequest.productID == Common.ID_LOTO235) {
    return Column(
      children: [
        SizedBox(
          height: 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            textLable("Phí dịch vụ kết nối"),
            textValue(formatAmountD(orderAddNewRequest.fee))
          ],
        )
      ],
    );
  } else {
    return SizedBox.shrink();
  }
}
