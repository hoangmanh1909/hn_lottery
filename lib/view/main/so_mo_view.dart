import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/controller/result_controller.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:lottery_flutter_application/models/response/so_mo_response.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/dialog_process.dart';

class SoMoView extends StatefulWidget {
  const SoMoView({
    Key? key,
  }) : super(key: key);

  @override
  State<SoMoView> createState() => _SoMoViewState();
}

class _SoMoViewState extends State<SoMoView> {
  final ResultController _con = ResultController();

  List<SoMoResponse>? somo;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getSomo();
    });
  }

  getSomo() async {
    if (mounted) {
      showProcess(context);
    }
    ResponseObject res = await _con.getSomo();
    if (mounted) Navigator.of(context).pop();
    if (res.code == "00") {
      somo = List<SoMoResponse>.from(
          (jsonDecode(res.data!).map((model) => SoMoResponse.fromJson(model))));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorLot.ColorPrimary,
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        title: const Text("Sổ mơ - Giải mộng"),
      ),
      body: Container(color: ColorLot.ColorBackground, child: buidView()),
    );
  }

  Widget buidView() {
    if (somo != null) {
      return Container(
          color: Colors.white,
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          child: Row(children: <Widget>[
            Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: somo!.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      SoMoResponse item = somo![index];
                      return Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          border: TableBorder.all(color: Colors.black12),
                          children: [
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(item.title!),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(item.value!),
                              ),
                            ])
                          ]);
                    }))
          ]));
    }
    return const SizedBox.shrink();
  }
}
