// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottery_flutter_application/models/radio_model.dart';
import 'package:lottery_flutter_application/models/xskt_model.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/common.dart';
import 'package:lottery_flutter_application/utils/dimen.dart';
import 'package:lottery_flutter_application/utils/timer_app.dart';
import 'package:lottery_flutter_application/view/tickets/kienthiet/ticket_kienthiet_view.dart';

class KienThietView extends StatefulWidget {
  const KienThietView({super.key});

  @override
  State<StatefulWidget> createState() => _KienThietView();
}

class _KienThietView extends State<KienThietView> {
  List<XSKTModel>? kts;
  int regionID = 0;

  @override
  void initState() {
    super.initState();

    setState(() {
      kts = listXSKT();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: ColorLot.ColorPrimary,
              automaticallyImplyLeading: false,
              centerTitle: true,
              titleTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              title: Text("Xổ số kiến thiết"),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            backgroundColor: ColorLot.ColorBackground,
            body: buildItem()));
  }

  Color getCorlorArea(int area) {
    if (area == 1) {
      return Colors.red[100]!;
    } else if (area == 2) {
      return Colors.yellow[100]!;
    } else {
      return Colors.blue[100]!;
    }
  }

  Widget buildItem() {
    var size = MediaQuery.of(context).size;
    var sizeChild = size.width - 106;
    var itemSize = (sizeChild / 4).floorToDouble();
    var maxLength = 1;

    return ListView.builder(
        itemCount: kts!.length,
        itemBuilder: (BuildContext ctxt, int index) {
          XSKTModel item = kts![index];
          List<RadioModel> radios = item.value!.where((element) {
            return element.region != 2;
          }).toList();
          radios.sort((a, b) => a.region!.compareTo(b.region!));

          return Container(
              height: 180,
              decoration: BoxDecoration(color: Colors.white),
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildTopDay(index, item.lable!.toUpperCase(), item.date!),
                    Container(
                        padding: EdgeInsets.all(8),
                        width: size.width - 98,
                        child: Wrap(
                            alignment: WrapAlignment.start,
                            direction: Axis.horizontal,
                            children: radios.map((it) {
                              return Container(
                                  width: double.parse(itemSize.toString()),
                                  height: 90,
                                  margin: EdgeInsets.symmetric(horizontal: 2),
                                  child: InkWell(
                                      onTap: () {
                                        Future.delayed(Duration.zero, () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      XSKTBookView(
                                                          radioModel: it,
                                                          xsktModel: item)));
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          Image(
                                            image: AssetImage(it.img!),
                                            width: itemSize - 15,
                                            height: 50,
                                          ),
                                          Container(
                                            width: itemSize,
                                            decoration: BoxDecoration(
                                                color:
                                                    getCorlorArea(it.region!)),
                                            height: 20,
                                            margin: EdgeInsets.only(top: 2),
                                            alignment: Alignment.center,
                                            child: Text(
                                              it.name!,
                                              style: TextStyle(
                                                  fontSize: Dimen
                                                      .fontSizeXsktRadioLable),
                                            ),
                                          )
                                        ],
                                      )));
                            }).toList()))
                  ]));
        });
  }

  Widget buildTopDay(int index, String title, DateTime date) {
    if (index == 0) {
      return Container(
          decoration: BoxDecoration(color: ColorLot.ColorPrimary),
          padding: EdgeInsets.all(8),
          height: double.infinity,
          width: 90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style:
                    TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    color: Colors.white),
                margin: EdgeInsets.symmetric(vertical: 8),
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text("Hôm nay",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                        fontSize: 12)),
              ),
              Text(
                DateFormat("dd/MM/yyyy").format(date),
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 12),
              ),
              TimerApp(
                eventTime: getDayXSKT(date),
                textStyle: TextStyle(fontSize: 12, color: Colors.white),
              )
            ],
          ));
    } else if (index == 1) {
      return Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.yellow,
          ),
          padding: EdgeInsets.all(8),
          width: 90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style:
                    TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    color: Colors.red),
                padding: EdgeInsets.symmetric(horizontal: 4),
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Text("Ngày mai",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 12)),
              ),
              Text(
                DateFormat("dd/MM/yyyy").format(date),
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 12),
              ),
              TimerApp(
                eventTime: getDayXSKT(date),
                textStyle: TextStyle(
                    fontSize: Dimen.fontSizeLable, color: Colors.black),
              )
            ],
          ));
    } else {
      return Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: ColorLot.ColorXSKT,
          ),
          padding: EdgeInsets.all(8),
          width: 90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 7),
                child: Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
              Text(
                DateFormat("dd/MM/yyyy").format(date),
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 12),
              ),
              TimerApp(
                eventTime: getDayXSKT(date),
                textStyle: TextStyle(fontSize: 10, color: Colors.white),
              )
            ],
          ));
    }
  }
}
