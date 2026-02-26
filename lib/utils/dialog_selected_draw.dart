// ignore_for_file: prefer_const_constructors, unused_element

import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/models/response/get_draw_keno_response.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/dimen.dart';

class DialogSelectedDraw extends StatefulWidget {
  const DialogSelectedDraw({
    super.key,
    required this.title,
    this.value,
    required this.draws,
    required this.callback,
  });

  final List<GetDrawKenoResponse> draws;
  final Function callback;
  final String title;
  final String? value;

  @override
  State<DialogSelectedDraw> createState() => _DialogSelectedDraw();
}

class _DialogSelectedDraw extends State<DialogSelectedDraw> {
  String? groupvalue;

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
            ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 400),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Wrap(
                          direction: Axis.vertical,
                          children: widget.draws.map((e) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 36,
                              child: RadioListTile(
                                title: Text(
                                  "Kỳ: #${e.drawCode} - ${e.drawTime!.substring(0, 5)} ${e.drawDate}",
                                  style: TextStyle(
                                      fontSize: Dimen.fontSizeDefault),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 0.0),
                                value: "${e.drawCode!}-${e.drawDate}",
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
                    })))),
          ]),
      actions: <Widget>[
        InkWell(
          onTap: () {
            widget.callback(groupvalue);
            Navigator.pop(context, 1);
          },
          child: Container(
            alignment: Alignment.center,
            height: 40,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.circular(Dimen.radiusBorder)),
                border: Border.all(color: ColorLot.ColorSuccess, width: 1)),
            child: Text(
              "Đồng ý",
              style: TextStyle(color: ColorLot.ColorSuccess),
            ),
          ),
        )
      ],
    );
  }
}
