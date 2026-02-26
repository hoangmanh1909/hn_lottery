// ignore_for_file: must_be_immutable, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottery_flutter_application/models/response/get_result_max3d_response.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';

import '../../utils/common.dart';
import '../../utils/widget_divider.dart';

class ResultMax3DView extends StatefulWidget {
  ResultMax3DView({Key? key, required this.max3dResults}) : super(key: key);
  List<GetResultMax3DResponse> max3dResults;
  @override
  State<ResultMax3DView> createState() => _ResultMax3DViewState();
}

class _ResultMax3DViewState extends State<ResultMax3DView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Row(children: <Widget>[
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: widget.max3dResults.length,
              itemBuilder: (BuildContext ctxt, int index) {
                GetResultMax3DResponse item = widget.max3dResults[index];
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 8),
                      buildFooter(item),
                      SizedBox(
                        height: 8,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Giải đặc biệt"),
                          SizedBox(
                            height: 4,
                          ),
                          resultST(item),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Giải nhất",
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          resultND(item),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Giải nhì",
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          resultRD(item),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Giải ba",
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          resultENC(item),
                        ],
                      ),
                      dividerLot(),
                    ]);
              },
            ),
          ),
        ]));
  }
}

Widget buildFooter(item) {
  DateTime tempDate = DateFormat("dd/MM/yyyy").parse(item.drawDate);
  return Center(
      child: Text(
          "Kỳ quay #${item.drawCode}. ${getDayOfWeekVi(DateFormat('EEEE').format(tempDate))}, ${item.drawDate}"));
}

Widget resultST(item) {
  List<String> drawResults = item.resultST!.split(',');
  List<String> list1 = drawResults[0].split('').map((char) => char).toList();
  List<String> list2 = drawResults[1].split('').map((char) => char).toList();

  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    _result(list1, ColorLot.ColorPrimary),
    SizedBox(
      width: 10,
    ),
    _result(list2, ColorLot.ColorPrimary)
  ]);
}

Widget resultST1(item) {
  List<String> drawResults = item.resultST!.split(',');
  List<String> list1 = drawResults[0].split('').map((char) => char).toList();
  List<String> list2 = drawResults[1].split('').map((char) => char).toList();

  return Row(children: [
    _result(list2, Colors.red),
    SizedBox(
      width: 10,
    ),
    _result(list1, Colors.red)
  ]);
}

Widget resultND(item) {
  List<String> drawResults = item.resultND!.split(',');
  List<String> list1 = drawResults[0].split('').map((char) => char).toList();
  List<String> list2 = drawResults[1].split('').map((char) => char).toList();
  List<String> list3 = drawResults[2].split('').map((char) => char).toList();
  List<String> list4 = drawResults[3].split('').map((char) => char).toList();

  return Wrap(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _result(list1, Colors.purple[800]!),
          SizedBox(
            width: 5,
          ),
          _result(list2, Colors.purple[800]!),
          SizedBox(
            width: 5,
          ),
          _result(list3, Colors.purple[800]!),
          SizedBox(
            width: 5,
          ),
          _result(list4, Colors.purple[800]!),
        ],
      ),
    ],
  );
}

Widget resultRD(item) {
  List<String> drawResults = item.resultRD!.split(',');
  List<String> list1 = drawResults[0].split('').map((char) => char).toList();
  List<String> list2 = drawResults[1].split('').map((char) => char).toList();
  List<String> list3 = drawResults[2].split('').map((char) => char).toList();
  List<String> list4 = drawResults[3].split('').map((char) => char).toList();
  List<String> list5 = drawResults[4].split('').map((char) => char).toList();
  List<String> list6 = drawResults[5].split('').map((char) => char).toList();
  return Wrap(
    children: [
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _result(list1, Colors.orange),
              SizedBox(
                width: 5,
              ),
              _result(list2, Colors.orange),
              SizedBox(
                width: 5,
              ),
              _result(list3, Colors.orange),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _result(list4, Colors.orange),
              SizedBox(
                width: 5,
              ),
              _result(list5, Colors.orange),
              SizedBox(
                width: 5,
              ),
              _result(list6, Colors.orange),
            ],
          ),
        ],
      )
    ],
  );
}

Widget resultENC(item) {
  List<String> drawResults = item.resultENC!.split(',');
  List<String> list1 = drawResults[0].split('').map((char) => char).toList();
  List<String> list2 = drawResults[1].split('').map((char) => char).toList();
  List<String> list3 = drawResults[2].split('').map((char) => char).toList();
  List<String> list4 = drawResults[3].split('').map((char) => char).toList();
  List<String> list5 = drawResults[4].split('').map((char) => char).toList();
  List<String> list6 = drawResults[5].split('').map((char) => char).toList();
  List<String> list7 = drawResults[6].split('').map((char) => char).toList();
  List<String> list8 = drawResults[7].split('').map((char) => char).toList();
  return Wrap(
    children: [
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _resultENC(list1),
              SizedBox(
                width: 5,
              ),
              _resultENC(list2),
              SizedBox(
                width: 5,
              ),
              _resultENC(list3),
              SizedBox(
                width: 5,
              ),
              _resultENC(list4),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _resultENC(list5),
              SizedBox(
                width: 5,
              ),
              _resultENC(list6),
              SizedBox(
                width: 5,
              ),
              _resultENC(list7),
              SizedBox(
                width: 5,
              ),
              _resultENC(list8),
            ],
          ),
        ],
      )
    ],
  );
}

Widget _result(List<String> list, Color color) {
  return Wrap(
      direction: Axis.horizontal,
      children: list.map((item) {
        return SizedBox(
            width: 27,
            height: 27,
            child: Container(
              margin: EdgeInsets.all(1),
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  border: Border.all(color: color, width: 1)),
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
            ));
      }).toList());
}

Widget _resultENC(List<String> list) {
  return Wrap(
      direction: Axis.horizontal,
      children: list.map((item) {
        return SizedBox(
            width: 27,
            height: 27,
            child: Container(
              margin: EdgeInsets.all(1),
              padding: EdgeInsets.all(1),
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
                        letterSpacing: 0.0,
                        color: Colors.black)),
              ),
            ));
      }).toList());
}
