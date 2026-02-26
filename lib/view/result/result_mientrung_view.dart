// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottery_flutter_application/models/response/get_result_lotomb_response.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/common.dart';

class ResultMienTrungView extends StatefulWidget {
  const ResultMienTrungView({Key? key, required this.xsktMienTrung})
      : super(key: key);
  final List<GetResultLotoMBResponse> xsktMienTrung;
  @override
  State<ResultMienTrungView> createState() => _ResultMienTrungViewState();
}

class _ResultMienTrungViewState extends State<ResultMienTrungView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var ma = widget.xsktMienTrung.map((e) => e.toJson());

    var newData =
        groupBy(ma, (Map obj) => obj['DrawDate']).map((k, v) => MapEntry(
            k,
            v.map((item) {
              item.remove('DrawDate');
              return item;
            }).toList()));

    var size = MediaQuery.of(context).size;
    return Container(
        color: ColorLot.ColorBackground,
        child: Row(children: <Widget>[
          Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: newData.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    var lable = newData.keys.elementAt(index);
                    var items = newData.values.elementAt(index);
                    return Container(
                        decoration: BoxDecoration(color: Colors.white),
                        margin: EdgeInsets.only(top: 8, left: 8, right: 8),
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 30,
                              // decoration:
                              //     BoxDecoration(color: Colors.amber[100]),
                              child: Text(
                                "${getDayOfWeekVi(DateFormat('EEEE').format(DateFormat("dd/MM/yyyy").parse(lable!)))} $lable",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ),
                            Table(
                                columnWidths: const <int, TableColumnWidth>{
                                  0: FixedColumnWidth(52),
                                  1: FlexColumnWidth(),
                                },
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                border: TableBorder.all(color: Colors.black12),
                                children: [
                                  TableRow(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text("Giải"),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: items.map((el) {
                                          GetResultLotoMBResponse model =
                                              GetResultLotoMBResponse.fromJson(
                                                  el);
                                          return Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.all(1),
                                            width: (size.width - 92) /
                                                items.length,
                                            child: _buildTextResult(
                                                model.radioName!,
                                                14,
                                                Colors.black),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text("100N"),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: items.map((el) {
                                          GetResultLotoMBResponse model =
                                              GetResultLotoMBResponse.fromJson(
                                                  el);
                                          return Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.all(1),
                                            width: (size.width - 92) /
                                                items.length,
                                            child: _buildTextResult(
                                                model.result08!,
                                                20,
                                                ColorLot.ColorPrimary),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text("200N"),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: items.map((el) {
                                          GetResultLotoMBResponse model =
                                              GetResultLotoMBResponse.fromJson(
                                                  el);
                                          return Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.all(1),
                                            width: (size.width - 92) /
                                                items.length,
                                            child: _buildTextResult(
                                                model.result07!,
                                                16,
                                                Colors.black),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text("400N"),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: items.map((el) {
                                          GetResultLotoMBResponse model =
                                              GetResultLotoMBResponse.fromJson(
                                                  el);
                                          return Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.all(1),
                                              width: (size.width - 92) /
                                                  items.length,
                                              child: SizedBox(
                                                  height: 70,
                                                  child: Wrap(
                                                      children: model.result06!
                                                          .split(',')
                                                          .map((e) {
                                                    return SizedBox(
                                                      width:
                                                          (size.width - 120) /
                                                              3,
                                                      height: 24,
                                                      child: Center(
                                                        child: _buildTextResult(
                                                            e,
                                                            16,
                                                            Colors.black),
                                                      ),
                                                    );
                                                  }).toList())));
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text("1TR"),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: items.map((el) {
                                          GetResultLotoMBResponse model =
                                              GetResultLotoMBResponse.fromJson(
                                                  el);
                                          return Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.all(1),
                                            width: (size.width - 92) /
                                                items.length,
                                            child: _buildTextResult(
                                                model.result05!,
                                                16,
                                                Colors.black),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text("3TR"),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: items.map((el) {
                                          GetResultLotoMBResponse model =
                                              GetResultLotoMBResponse.fromJson(
                                                  el);
                                          return Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.all(1),
                                              width: (size.width - 92) /
                                                  items.length,
                                              child: SizedBox(
                                                  height: 170,
                                                  child: Wrap(
                                                      children: model.result04!
                                                          .split(',')
                                                          .map((e) {
                                                    return SizedBox(
                                                      width:
                                                          (size.width - 120) /
                                                              3,
                                                      height: 24,
                                                      child: Center(
                                                        child: _buildTextResult(
                                                            e,
                                                            16,
                                                            Colors.black),
                                                      ),
                                                    );
                                                  }).toList())));
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text("10TR"),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: items.map((el) {
                                          GetResultLotoMBResponse model =
                                              GetResultLotoMBResponse.fromJson(
                                                  el);
                                          return Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.all(1),
                                              width: (size.width - 92) /
                                                  items.length,
                                              child: SizedBox(
                                                  height: 48,
                                                  child: Wrap(
                                                      children: model.result03!
                                                          .split(',')
                                                          .map((e) {
                                                    return SizedBox(
                                                      width:
                                                          (size.width - 120) /
                                                              3,
                                                      height: 24,
                                                      child: Center(
                                                        child: _buildTextResult(
                                                            e,
                                                            16,
                                                            Colors.black),
                                                      ),
                                                    );
                                                  }).toList())));
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text("15TR"),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: items.map((el) {
                                          GetResultLotoMBResponse model =
                                              GetResultLotoMBResponse.fromJson(
                                                  el);
                                          return Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.all(1),
                                            width: (size.width - 92) /
                                                items.length,
                                            child: _buildTextResult(
                                                model.result02!,
                                                16,
                                                Colors.black),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text("30TR"),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: items.map((el) {
                                          GetResultLotoMBResponse model =
                                              GetResultLotoMBResponse.fromJson(
                                                  el);
                                          return Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.all(1),
                                            width: (size.width - 92) /
                                                items.length,
                                            child: _buildTextResult(
                                                model.result!,
                                                16,
                                                Colors.black),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text("2Tỷ"),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: items.map((el) {
                                          GetResultLotoMBResponse model =
                                              GetResultLotoMBResponse.fromJson(
                                                  el);
                                          return Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.all(1),
                                            width: (size.width - 92) /
                                                items.length,
                                            child: _buildTextResult(
                                                model.result!,
                                                18,
                                                ColorLot.ColorPrimary),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ])
                          ],
                        ));
                  }))
        ]));
  }

  Widget _buildTextResult(String value, double fontSize, Color color) {
    return Text(
      value,
      style: TextStyle(
          fontSize: fontSize, color: color, fontWeight: FontWeight.w600),
    );
  }
}
