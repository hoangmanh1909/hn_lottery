// ignore_for_file: prefer_const_constructors, unused_element

import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/models/response/draw_response.dart';
import 'package:lottery_flutter_application/models/selected_item_model.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/dimen.dart';

class DialogDrawCheckbox extends StatefulWidget {
  const DialogDrawCheckbox(
      {super.key,
      required this.title,
      required this.callback,
      required this.draws,
      required this.drawsSeleted});

  final String title;
  final List<DrawResponse> draws;
  final List<DrawResponse> drawsSeleted;
  final Function callback;

  @override
  State<DialogDrawCheckbox> createState() => _DialogDrawCheckbox();
}

class _DialogDrawCheckbox extends State<DialogDrawCheckbox> {
  List<SelectItemModel> list = [];
  List<SelectItemModel> listSeleted = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.draws.length; i++) {
      var e = widget.draws[i];
      var se = widget.drawsSeleted
          .where((element) => element.drawCode == e.drawCode)
          .toList();
      list.add(SelectItemModel(
          text: "#${e.drawCode!} - ${e.drawDate}",
          value: "${e.drawCode!}-${e.drawDate}",
          isSelected: se.isEmpty ? false : true));
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
                width: MediaQuery.of(context).size.width,
                child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Wrap(
                      direction: Axis.vertical,
                      children: list.map((e) {
                        return SizedBox(
                            height: 40,
                            width: MediaQuery.of(context).size.width - 50,
                            child: CheckboxListTile(
                              title: Text(e.text!),
                              value: e.isSelected,
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (bool? value) {
                                setState(() {
                                  e.isSelected = value;
                                });
                              },
                            ));
                      }).toList());
                }))
          ]),
      actions: <Widget>[
        InkWell(
          onTap: () {
            listSeleted = list.where((element) => element.isSelected!).toList();
            if (listSeleted.isNotEmpty) {
              List<DrawResponse> draws = [];
              for (int i = 0; i < listSeleted.length; i++) {
                DrawResponse item = DrawResponse();
                item.drawCode = listSeleted[i].value!.split('-')[0];
                item.drawDate = listSeleted[i].value!.split('-')[1];
                draws.add(item);
              }
              widget.callback(draws);
              Navigator.pop(context, 1);
            }
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
