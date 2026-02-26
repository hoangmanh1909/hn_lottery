// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottery_flutter_application/models/response/get_result_lotomb_response.dart';

import '../../utils/color_lot.dart';
import '../../utils/common.dart';

class ResultMienBacView extends StatefulWidget {
  const ResultMienBacView({Key? key, required this.xsktMienBac})
      : super(key: key);
  final List<GetResultLotoMBResponse> xsktMienBac;
  @override
  State<ResultMienBacView> createState() => _ResultMienBacViewState();
}

class _ResultMienBacViewState extends State<ResultMienBacView> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
        color: ColorLot.ColorBackground,
        child: Row(children: <Widget>[
          Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: widget.xsktMienBac.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    GetResultLotoMBResponse item = widget.xsktMienBac[index];
                    return Container(
                      decoration: BoxDecoration(color: Colors.white),
                      margin: EdgeInsets.only(top: 8, left: 8, right: 8),
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Table(
                            columnWidths: const <int, TableColumnWidth>{
                              0: FixedColumnWidth(80),
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
                                    child: Text("Ký hiệu"),
                                  ),
                                  Center(
                                    child: Text(
                                      "${getDayOfWeekVi(DateFormat('EEEE').format(DateFormat("dd/MM/yyyy").parse(item.drawDate!)))} - ${item.drawDate}\n${item.symbols}",
                                      textAlign: TextAlign.center,
                                      softWrap: true,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("Đặc biệt"),
                                  ),
                                  Center(
                                    child: Text(item.result!,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: ColorLot.ColorPrimary,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("Giải nhất"),
                                  ),
                                  Center(
                                    child: _buildTextResult(
                                        item.result01!, 16, Colors.black),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("Giải nhì"),
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children:
                                          item.result02!.split(',').map((e) {
                                        return Expanded(
                                            child: Center(
                                          child: _buildTextResult(
                                              e, 16, Colors.black),
                                        ));
                                      }).toList())
                                ],
                              ),
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("Giải ba"),
                                  ),
                                  SizedBox(
                                    height: 60,
                                    child: Wrap(
                                        children:
                                            item.result03!.split(',').map((e) {
                                      return SizedBox(
                                        width: (size.width - 120) / 3,
                                        height: 30,
                                        child: Center(
                                          child: _buildTextResult(
                                              e, 16, Colors.black),
                                        ),
                                      );
                                    }).toList()),
                                  )
                                ],
                              ),
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("Giải tư"),
                                  ),
                                  SizedBox(
                                    height: 30,
                                    child: Wrap(
                                        children:
                                            item.result04!.split(',').map((e) {
                                      return SizedBox(
                                        width: (size.width - 120) / 4,
                                        height: 30,
                                        child: Center(
                                          child: _buildTextResult(
                                              e, 16, Colors.black),
                                        ),
                                      );
                                    }).toList()),
                                  )
                                ],
                              ),
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("Giải năm"),
                                  ),
                                  SizedBox(
                                    height: 60,
                                    child: Wrap(
                                        children:
                                            item.result05!.split(',').map((e) {
                                      return SizedBox(
                                        width: (size.width - 120) / 3,
                                        height: 30,
                                        child: Center(
                                          child: _buildTextResult(
                                              e, 16, Colors.black),
                                        ),
                                      );
                                    }).toList()),
                                  )
                                ],
                              ),
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("Giải sáu"),
                                  ),
                                  SizedBox(
                                    height: 30,
                                    child: Wrap(
                                        children:
                                            item.result06!.split(',').map((e) {
                                      return SizedBox(
                                        width: (size.width - 120) / 3,
                                        height: 30,
                                        child: Center(
                                          child: _buildTextResult(
                                              e, 16, Colors.black),
                                        ),
                                      );
                                    }).toList()),
                                  )
                                ],
                              ),
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("Giải bảy"),
                                  ),
                                  SizedBox(
                                    height: 30,
                                    child: Wrap(
                                        children:
                                            item.result07!.split(',').map((e) {
                                      return SizedBox(
                                        width: (size.width - 120) / 4,
                                        height: 30,
                                        child: Center(
                                          child: Text(
                                            e,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: ColorLot.ColorPrimary),
                                          ),
                                        ),
                                      );
                                    }).toList()),
                                  )
                                ],
                              ),
                            ],
                          ),
                          // Container(
                          //   alignment: Alignment.center,
                          //   height: 30,
                          //   // decoration: BoxDecoration(color: Colors.amber[100]),
                          //   child: Text(
                          //     "Kết quả xổ số Miền Bắc, ${getDayOfWeekVi(DateFormat('EEEE').format(DateFormat("dd/MM/yyyy").parse(item.drawDate!)))} - ${item.drawDate}",
                          //     style: TextStyle(fontWeight: FontWeight.w600),
                          //   ),
                          // ),
                        ],
                      ),
                    );
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
