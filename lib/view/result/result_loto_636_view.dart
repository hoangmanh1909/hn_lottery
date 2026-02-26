// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottery_flutter_application/models/response/get_result_response.dart';

import '../../utils/color_lot.dart';
import '../../utils/common.dart';

class Result606View extends StatefulWidget {
  Result606View({Key? key, required this.result636}) : super(key: key);
  List<GetResultResponse> result636;
  @override
  State<Result606View> createState() => _Result606ViewState();
}

class _Result606ViewState extends State<Result606View> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Row(children: <Widget>[
          Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: widget.result636.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    GetResultResponse item = widget.result636[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        buildFooter(item),
                        if (index == 0) ballFirst(item) else ballNormal(item),
                        const SizedBox(
                          height: 8,
                        ),
                        Divider(
                          height: 1,
                          color: Colors.grey[200],
                        )
                      ],
                    );
                  }))
        ]));
  }
}

Widget buildFooter(GetResultResponse item) {
  DateTime tempDate = DateFormat("dd/MM/yyyy").parse(item.drawDate!);
  String date = item.drawDate!;
  return Center(
      child: Text(
          "Kỳ quay #${item.drawCode}. ${getDayOfWeekVi(DateFormat('EEEE').format(tempDate))}, $date"));
}

Widget ballNormal(GetResultResponse item) {
  List<String> drawResults = item.result!.split(',');

  return Wrap(
      direction: Axis.horizontal,
      children: drawResults.map(
        (item) {
          return Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(3),
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: ColorLot.ColorPrimary, width: 1)),
            child: InkWell(
              onTap: () {},
              child: Text(item,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      letterSpacing: 0.0)),
            ),
          );
        },
      ).toList());
}

Widget ballFirst(GetResultResponse item) {
  List<String> drawResults = item.result!.split(',');

  return Wrap(
      direction: Axis.horizontal,
      children: drawResults.map((item) {
        return Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(3),
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorLot.ColorPrimary,
              border: Border.all(color: ColorLot.ColorPrimary, width: 1)),
          child: InkWell(
            onTap: () {},
            child: Text(item,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 0.0,
                    color: Colors.white)),
          ),
        );
      }).toList());
}
