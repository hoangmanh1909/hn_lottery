// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottery_flutter_application/controller/together_ticket_controller.dart';
import 'package:lottery_flutter_application/models/request/together_ticket_request.dart';
import 'package:lottery_flutter_application/models/response/together_ticket_response.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';

import '../../../constants/common.dart';
import '../../../models/response/response_object.dart';
import '../../../utils/box_shadow.dart';
import '../../../utils/common.dart';
import '../../../utils/dialog_process.dart';
import '../../../utils/dimen.dart';
import 'ticket_together_detail_view.dart';
import 'ticket_together_history_view.dart';

class TicketTogetherView extends StatefulWidget {
  const TicketTogetherView({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _TicketTogetherView();
}

class _TicketTogetherView extends State<TicketTogetherView> {
  final TogetherTicketController _con = TogetherTicketController();

  List<TogetherTicketSearchResponse> tickets = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getTickets();
    });
  }

  getTickets() async {
    if (mounted) showProcess(context);

    TogetherTicketSearchRequest req = TogetherTicketSearchRequest();
    req.status = "S";
    req.type = 1;
    ResponseObject res = await _con.search(req);
    if (res.code == "00") {
      tickets = List<TogetherTicketSearchResponse>.from((jsonDecode(res.data!)
          .map((model) => TogetherTicketSearchResponse.fromJson(model))));

      setState(() {});
    }

    if (mounted) {
      Navigator.pop(context);
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
          title: Text("Bao chung"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Ionicons.time_outline,
                color: Colors.white,
              ),
              onPressed: () {
                Future.delayed(Duration.zero, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TicketTogetherHistoryView(
                                type: 1,
                              )));
                });
              },
            )
          ],
        ),
        body: buildBody());
  }

  Widget buildBody() {
    if (tickets.isEmpty) {
      return Container(
        color: Colors.white,
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 50),
        child: Column(
          children: const [
            Icon(
              Ionicons.clipboard_outline,
              size: 40,
              color: Colors.black54,
            ),
            SizedBox(
              height: 10,
            ),
            Text("Danh sách trống!")
          ],
        ),
      );
    }
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: tickets.map((item) {
            return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TicketTogetherDetailView(code: item.code!)));
                },
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[boxShadow()],
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                    padding: EdgeInsets.all(6),
                                    child: Image(
                                      image: _buildImageProduct(item.productID),
                                      width: 50,
                                      height: 50,
                                    )),
                                Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        textBold("Mã bao ${item.code}",
                                            Colors.black),
                                        textBold(
                                            "Bao ${item.systematic} - ${formatAmountD(item.price)}",
                                            Colors.blue),
                                        textNormal(
                                            "Kỳ: #${item.drawCode} - ${item.drawDate}"),
                                        Text(
                                          item.createdDate!,
                                          style: TextStyle(
                                              fontSize: Dimen.fontSizeDefault,
                                              color: Colors.black45),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              width: 120,
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: ColorLot.ColorBaoChung,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft:
                                          Radius.circular(Dimen.radiusBorder))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  textBold("${item.quantity} người góp",
                                      Colors.white),
                                  textBold(
                                      "${item.percent!.toStringAsFixed(0)}% hoàn thành",
                                      Colors.white)
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    )));
          }).toList(),
        ),
      ),
    );
  }

  Widget textBold(text, Color color) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: Dimen.fontSizeDefault,
          color: color),
    );
  }

  Widget textNormal(text) {
    return Text(
      text,
      style: TextStyle(fontSize: Dimen.fontSizeDefault, color: Colors.black),
    );
  }
}

ImageProvider<Object> _buildImageProduct(productID) {
  switch (productID) {
    case Common.ID_KENO:
      return AssetImage('assets/img/keno.png');
    case Common.ID_MEGA:
      return AssetImage('assets/img/mega.png');
    case Common.ID_POWER:
      return AssetImage('assets/img/power.png');
    case Common.ID_MAX3D:
      return AssetImage('assets/img/max3dtrang.png');
    case Common.ID_MAX3D_PLUS:
      return AssetImage('assets/img/max3dcongtrang.png');
    case Common.ID_MAX3D_PRO:
      return AssetImage('assets/img/max_3dpro.png');
    default:
      return AssetImage('assets/img/mienbac.png');
  }
}
