// ignore_for_file: prefer_const_constructors, unused_element

import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/constants/common.dart';
import 'package:lottery_flutter_application/models/selected_item_model.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/dimen.dart';

class DialogSelectedRadio extends StatefulWidget {
  const DialogSelectedRadio(
      {super.key,
      required this.title,
      required this.callback,
      required this.productID,
      required this.contentHeight,
      this.value,
      this.condition});

  final double contentHeight;
  final String title;
  final int productID;
  final Function callback;
  final String? value;
  final int? condition;

  @override
  State<DialogSelectedRadio> createState() => _DialogSelectedRadio();
}

class _DialogSelectedRadio extends State<DialogSelectedRadio> {
  List<SelectItemModel> list = [];
  String? groupvalue;

  @override
  void initState() {
    super.initState();

    groupvalue = widget.value ?? "";

    if (widget.productID == Common.ID_MEGA ||
        widget.productID == Common.ID_POWER) {
      list.add(SelectItemModel(text: "Vé thường", value: "6"));
      list.add(SelectItemModel(text: "Bao 5", value: "5"));
      list.add(SelectItemModel(text: "Bao 7", value: "7"));
      list.add(SelectItemModel(text: "Bao 8", value: "8"));
      list.add(SelectItemModel(text: "Bao 9", value: "9"));
      list.add(SelectItemModel(text: "Bao 10", value: "10"));
      list.add(SelectItemModel(text: "Bao 11", value: "11"));
      list.add(SelectItemModel(text: "Bao 12", value: "12"));
      list.add(SelectItemModel(text: "Bao 13", value: "13"));
      list.add(SelectItemModel(text: "Bao 14", value: "14"));
      list.add(SelectItemModel(text: "Bao 15", value: "15"));
      list.add(SelectItemModel(text: "Bao 18", value: "18"));
    } else if (widget.productID == Common.ID_KENO_TYPE_SPOT) {
      list.add(SelectItemModel(text: "Hệ thống tự chọn", value: "1"));
      list.add(SelectItemModel(text: "Tự đặt nuôi", value: "2"));
    } else if (widget.productID == Common.ID_KENO_TYPE_BAG) {
      for (int i = 3; i < 13; i++) {
        list.add(SelectItemModel(text: "Bao $i", value: i.toString()));
      }
    } else if (widget.productID == Common.ID_KENO_TYPE_BAG_OP) {
      int condition = widget.condition!;
      int litmit = 2;
      if (condition == 12) {
        litmit = 10;
      } else if (condition == 11) {
        litmit = 9;
      } else if (condition == 10) {
        litmit = 8;
      } else if (condition == 9) {
        litmit = 7;
      }
      for (int i = litmit; i < condition && i < 11; i++) {
        list.add(SelectItemModel(text: "Bậc $i", value: i.toString()));
      }
    } else if (widget.productID == Common.ID_MAX3D_PRO) {
      list.add(SelectItemModel(text: "Vé thường", value: "1"));
      list.add(SelectItemModel(text: "Bao bộ số", value: "2"));
      list.add(SelectItemModel(text: "Bao 3 số", value: "3"));
      list.add(SelectItemModel(text: "Bao 4 số", value: "4"));
      list.add(SelectItemModel(text: "Bao 5 số", value: "5"));
      list.add(SelectItemModel(text: "Bao 6 số", value: "6"));
      list.add(SelectItemModel(text: "Bao 7 số", value: "7"));
      list.add(SelectItemModel(text: "Bao 8 số", value: "8"));
      list.add(SelectItemModel(text: "Bao 9 số", value: "9"));
      list.add(SelectItemModel(text: "Bao 10 số", value: "10"));
      list.add(SelectItemModel(text: "Bao 11 số", value: "11"));
      list.add(SelectItemModel(text: "Bao 12 số", value: "12"));
      list.add(SelectItemModel(text: "Bao 13 số", value: "13"));
      list.add(SelectItemModel(text: "Bao 14 số", value: "14"));
      list.add(SelectItemModel(text: "Bao 15 số", value: "15"));
      list.add(SelectItemModel(text: "Bao 16 số", value: "16"));
      list.add(SelectItemModel(text: "Bao 17 số", value: "17"));
      list.add(SelectItemModel(text: "Bao 18 số", value: "18"));
      list.add(SelectItemModel(text: "Bao 19 số", value: "19"));
      list.add(SelectItemModel(text: "Bao 20 số", value: "20"));
    } else if (widget.productID == Common.ID_LOTTO_535) {
      list.add(SelectItemModel(value: 5.toString(), text: "Vé thường"));
      for (int i = 4; i <= 15; i++) {
        if (i != 5) {
          list.add(SelectItemModel(value: i.toString(), text: "Bao $i số"));
        }
      }
    } else if (widget.productID == Common.ID_LOTTO_535_SPECIAL) {
      list.add(SelectItemModel(value: "1", text: "Vé thường"));

      for (int i = 2; i < 13; i++) {
        list.add(SelectItemModel(text: "Bao $i số", value: i.toString()));
      }
    } else {
      for (int i = 1; i < 11; i++) {
        list.add(SelectItemModel(text: "Bậc $i", value: i.toString()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor: ColorLot.ColorBackground,
      surfaceTintColor: Colors.transparent,
      titlePadding: EdgeInsets.all(10),
      contentPadding: EdgeInsets.all(10),
      actionsPadding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                widget.title,
                style: TextStyle(fontSize: Dimen.fontSizeTitle),
              ),
              InkWell(
                onTap: () => {Navigator.pop(context)},
                child: Container(
                  alignment: Alignment.center,
                  height: Dimen.buttonHeight,
                  child: Text(
                    "Đóng",
                    style: TextStyle(
                        color: ColorLot.ColorPrimary,
                        fontSize: Dimen.fontSizeTitle),
                  ),
                ),
              )
            ]),
            Container(
                alignment: Alignment.center,
                height: widget.contentHeight,
                width: MediaQuery.of(context).size.width,
                child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  double width = 140;
                  if (widget.productID == Common.ID_KENO_TYPE_SPOT) {
                    width = MediaQuery.of(context).size.width;
                  }
                  return Wrap(
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      direction: Axis.vertical,
                      children: list.map((e) {
                        String s = e.text!;
                        return SizedBox(
                          width: width,
                          height: 36,
                          child: RadioListTile(
                            title: Text(e.text!),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 0.0),
                            value: e.value!,
                            dense: false,
                            visualDensity: VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity),
                            groupValue: groupvalue,
                            onChanged: (value) {
                              setState(() {
                                groupvalue = value.toString();
                              });
                            },
                          ),
                        );
                      }).toList());
                }))
          ]),
      actions: <Widget>[
        InkWell(
          onTap: () {
            Navigator.pop(context, 1);
            widget.callback(groupvalue);
          },
          child: Container(
            alignment: Alignment.center,
            height: 40,
            decoration: BoxDecoration(
              color: ColorLot.ColorPrimary,
              borderRadius:
                  BorderRadius.all(Radius.circular(Dimen.radiusBorder)),
            ),
            child: Text(
              "Đồng ý",
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
