// ignore_for_file: unnecessary_new, use_build_context_synchronously, prefer_const_constructors, must_be_immutable, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottery_flutter_application/models/response/get_result_keno_response.dart';
import 'package:lottery_flutter_application/utils/common.dart';
import 'package:lottery_flutter_application/utils/dimen.dart';
import '../../utils/color_lot.dart';

class ResultKenoView extends StatefulWidget {
  ResultKenoView({Key? key, required this.kenoResults}) : super(key: key);
  List<GetResultKenoResponse> kenoResults;
  @override
  State<ResultKenoView> createState() => _ResultKenoViewState();
}

class _ResultKenoViewState extends State<ResultKenoView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: widget.kenoResults.length,
            itemBuilder: (BuildContext ctxt, int index) {
              GetResultKenoResponse item = widget.kenoResults[index];
              String drawTime = item.drawTime!.padLeft(6, '0');
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.all(Dimen.padingDefault),
                          child: Text(
                              "Kỳ #${item.drawCode}, ${getDayOfWeekVi((DateFormat('EEEE').format(DateFormat("dd/MM/yyyy").parse(item.drawDate!))))} ${drawTime.substring(0, 2)}:${drawTime.substring(2, 4)} - ${item.drawDate}",
                              style: TextStyle(fontWeight: FontWeight.w600))),
                    ],
                  ),
                  if (index == 0) ballFirst(item) else ballNormal(item),
                  SizedBox(
                    height: 4,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    item.big! > 10
                        ? bigSmallActive(
                            "Lớn (${item.big})", ColorLot.ColorPrimary)
                        : bigSmall("Lớn (${item.big})"),
                    item.big! == 10
                        ? bigSmallActive("Hòa lớn nhỏ", ColorLot.ColorPrimary)
                        : bigSmall("Hòa lớn nhỏ"),
                    item.small! > 10
                        ? bigSmallActive(
                            "Nhỏ (${item.small})", ColorLot.ColorPrimary)
                        : bigSmall("Nhỏ (${item.small})"),
                  ]),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    item.even! > 12
                        ? bigSmallActive(
                            "Chắn (${item.even})", ColorLot.ColorBaoChung)
                        : bigSmall("Chắn (${item.even})"),
                    item.even! == 11 || item.even == 12
                        ? bigSmallActive("Chẵn 11-12", ColorLot.ColorBaoChung)
                        : bigSmall("Chẵn 11-12"),
                    item.even! == 10
                        ? bigSmallActive("Hòa CL", ColorLot.ColorBaoChung)
                        : bigSmall("Hòa CL"),
                    item.odd! == 11 || item.odd == 12
                        ? bigSmallActive("Lẻ 11-12", ColorLot.ColorBaoChung)
                        : bigSmall("Lẻ 11-12"),
                    item.odd! > 12
                        ? bigSmallActive(
                            "Lẻ (${item.odd})", ColorLot.ColorBaoChung)
                        : bigSmall("Lẻ (${item.odd})"),
                  ]),
                  const SizedBox(
                    height: 6,
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey[200],
                  ),
                ],
              );
            }));
  }
}

Widget ballNormal(GetResultKenoResponse item) {
  List<String> drawResults = item.result!.split(',');

  return SizedBox(
      width: 350,
      child: Wrap(
          alignment: WrapAlignment.center,
          direction: Axis.horizontal,
          children: drawResults.map((item) {
            return Container(
              width: 28,
              height: 28,
              margin: EdgeInsets.all(3),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border:
                      Border.all(color: ColorLot.ColorResultKeno, width: 1)),
              child: InkWell(
                onTap: () {},
                child: Center(
                  child: Text(item,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        letterSpacing: 0.0,
                      )),
                ),
              ),
            );
          }).toList()));
}

Widget ballFirst(GetResultKenoResponse item) {
  List<String> drawResults = item.result!.split(',');

  return SizedBox(
      width: 350,
      child: Wrap(
          alignment: WrapAlignment.center,
          direction: Axis.horizontal,
          children: drawResults.map((item) {
            return Container(
              width: 28,
              height: 28,
              margin: EdgeInsets.all(3),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorLot.ColorPrimary,
                  border: Border.all(color: ColorLot.ColorPrimary, width: 1)),
              child: InkWell(
                onTap: () {},
                child: Center(
                    child: Text(item,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            letterSpacing: 0.0,
                            color: Colors.white))),
              ),
            );
          }).toList()));
}

Widget bigSmall(item) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
    margin: EdgeInsets.all(2),
    decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: ColorLot.ColorResultKeno, width: 1)),
    child: Text(item,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 14, letterSpacing: 0.0, color: ColorLot.ColorResultKeno)),
  );
}

Widget bigSmallActive(item, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
    margin: EdgeInsets.all(2),
    decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: color,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color, width: 1)),
    child: Text(item,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 14, letterSpacing: 0.0, color: Colors.white)),
  );
}
