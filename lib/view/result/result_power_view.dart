// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottery_flutter_application/models/response/get_result_response.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';

import '../../utils/common.dart';

class ResultPowerView extends StatefulWidget {
  ResultPowerView({Key? key, required this.powerResults}) : super(key: key);
  List<GetResultResponse> powerResults;
  @override
  State<ResultPowerView> createState() => _ResultPowerViewState();
}

class _ResultPowerViewState extends State<ResultPowerView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Row(children: <Widget>[
          Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: widget.powerResults.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    GetResultResponse item = widget.powerResults[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        buildFooter(item),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (index == 0)
                              ballFirst(item)
                            else
                              ballNormal(item),
                            Container(
                              width: 28,
                              height: 28,
                              padding: const EdgeInsets.all(3),
                              margin: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorLot.ColorPrimary,
                                  border: Border.all(
                                      color: ColorLot.ColorPrimary, width: 1)),
                              child: InkWell(
                                onTap: () {},
                                child: Text(item.bonus.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        letterSpacing: 0.0,
                                        color: Colors.white)),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 6,
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
  String date = DateFormat("dd/MM/yyyy").format(tempDate);
  return Center(
      child: Text(
          "Kỳ quay #${item.drawCode}, ${getDayOfWeekVi(DateFormat('EEEE').format(tempDate))} - $date"));
}

Widget ballNormal(GetResultResponse item) {
  List<String> drawResults = item.result!.split(',');

  return Wrap(
      direction: Axis.horizontal,
      children: drawResults.map(
        (item) {
          return Container(
            width: 28,
            height: 28,
            padding: const EdgeInsets.all(3),
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: ColorLot.ColorBaoChung, width: 1)),
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
          width: 28,
          height: 28,
          padding: const EdgeInsets.all(3),
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorLot.ColorBaoChung,
              border: Border.all(color: ColorLot.ColorBaoChung, width: 1)),
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
