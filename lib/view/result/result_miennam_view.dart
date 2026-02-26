// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottery_flutter_application/models/radio_model.dart';
import 'package:lottery_flutter_application/models/response/get_result_lotomb_response.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/common.dart';

class ResultMienNamView extends StatefulWidget {
  const ResultMienNamView({Key? key, required this.xsktMienNam})
      : super(key: key);
  final List<GetResultLotoMBResponse> xsktMienNam;
  @override
  State<ResultMienNamView> createState() => _ResultMienNamViewState();
}

class _ResultMienNamViewState extends State<ResultMienNamView> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
        color: ColorLot.ColorBackground,
        child: Row(children: <Widget>[
          Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: widget.xsktMienNam.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    GetResultLotoMBResponse item = widget.xsktMienNam[index];
                    return Container(
                      decoration: BoxDecoration(color: Colors.white),
                      margin: EdgeInsets.only(top: 8, left: 8, right: 8),
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 30,
                            // decoration: BoxDecoration(color: Colors.amber[100]),
                            child: Text(
                              "${getDayOfWeekVi(DateFormat('EEEE').format(DateFormat("dd/MM/yyyy").parse(item.drawDate!)))}, ${item.drawDate}",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ),
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
                                    child: Text("Đặc biệt"),
                                  ),
                                  Center(
                                    child: _buildTextResult(
                                        item.result!, 20, Colors.red),
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
                                    height: 30,
                                    child: Wrap(
                                        children:
                                            item.result03!.split(',').map((e) {
                                      return SizedBox(
                                        width: (size.width - 120) / 2,
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
                                    height: 60,
                                    child: Wrap(
                                        alignment: WrapAlignment.center,
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
                                    height: 30,
                                    child: Center(
                                        child: _buildTextResult(
                                            item.result05!, 16, Colors.black)),
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
                                    child: Center(
                                        child: _buildTextResult(
                                            item.result07!, 16, Colors.black)),
                                  )
                                ],
                              ),
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("Giải tám"),
                                  ),
                                  SizedBox(
                                    height: 30,
                                    child: Center(
                                        child: _buildTextResult(
                                            item.result08!, 16, Colors.black)),
                                  )
                                ],
                              ),
                            ],
                          ),
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

  ImageProvider<Object> _buildImageRadio(radioID) {
    RadioModel radioModel =
        listRadio().where((element) => element.id == radioID).first;
    return AssetImage(radioModel.img!);
  }
}
