// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottery_flutter_application/models/response/get_item_response.dart';
import 'package:lottery_flutter_application/models/response/get_item_result_respose.dart';
import 'package:lottery_flutter_application/models/response/get_result_response.dart';
import 'package:lottery_flutter_application/utils/dimen.dart';
import 'package:lottery_flutter_application/view/history/history_compare_view.dart';
import 'package:lottery_flutter_application/view/tickets/loto/ticket_loto_636_view.dart';
import 'package:lottery_flutter_application/view/tickets/loto/ticket_loto_capso_view.dart';
import 'package:lottery_flutter_application/view/tickets/loto/ticket_loto_view.dart';
import 'package:lottery_flutter_application/view/tickets/vietlott/ticket_3d_base_view.dart';
import 'package:lottery_flutter_application/view/tickets/vietlott/ticket_3d_view.dart';
import 'package:lottery_flutter_application/view/tickets/vietlott/ticket_vietlott_base_view.dart';

import '../../config/api.dart';
import '../../constants/common.dart';
import '../../controller/history_controller.dart';
import '../../models/response/get_order_response.dart';
import '../../models/response/get_result_lotomb_response.dart';
import '../../models/response/get_result_max3d_response.dart';
import '../../models/response/response_object.dart';
import '../../utils/color_lot.dart';
import '../../utils/common.dart';
import '../../utils/dialog_process.dart';
import '../../utils/hero_photo_view.dart';

class HistoryItemView extends StatefulWidget {
  const HistoryItemView({Key? key, required this.order}) : super(key: key);

  final GetOrderResponse order;

  @override
  State<HistoryItemView> createState() => _HistoryItemViewState();
}

class _HistoryItemViewState extends State<HistoryItemView> {
  final HistoryController _con = HistoryController();

  List<GetItemResponse>? items;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getItems();
    });
  }

  getItems() async {
    if (mounted) showProcess(context);

    ResponseObject res = await _con.getItemByCode(widget.order.code!);
    if (res.code == "00") {
      setState(() {
        items = List<GetItemResponse>.from((jsonDecode(res.data!)
            .map((model) => GetItemResponse.fromJson(model))));
      });
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  onCompare(GetItemResponse item) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HistoryCompareView(
                  item: item,
                )));
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
          title: const Text('Chi tiết đơn hàng'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Scaffold(
          backgroundColor: ColorLot.ColorBackground,
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              items != null ? _buildItem() : SizedBox.shrink(),
              _buildMuaLai()
            ],
          ),
        ));
  }

  mualai() {
    if (items![0].productID == Common.ID_MAX3D_PLUS ||
        items![0].productID == Common.ID_MAX3D_PRO) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Ticket3DView(
                    productID: items![0].productID!,
                    code: items![0].orderCode,
                  )));
    } else if (items![0].productID == Common.ID_MEGA ||
        items![0].productID == Common.ID_POWER) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TicketVietlottBaseView(
                    productID: items![0].productID!,
                    code: items![0].orderCode,
                  )));
    } else if (items![0].productID == Common.ID_MAX3D) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Ticket3DBaseView(
                    type: 3,
                    code: items![0].orderCode,
                  )));
    } else if (items![0].productID == Common.ID_DIENTOAN_636) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TicketLoto636View(
                    code: items![0].orderCode,
                  )));
    } else if (items![0].productID == Common.ID_LOTO234) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TicketLotoCapSoView(
                    type: items![0].systemA!,
                    code: items![0].orderCode,
                  )));
    } else if (items![0].productID == Common.ID_LOTO235) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TicketLotoView(
                    type: items![0].systemA!,
                    code: items![0].orderCode,
                  )));
    }
  }

  Widget _buildMuaLai() {
    if (items != null) {
      if (items![0].productID != 7 &&
          items![0].productID != 14 &&
          items![0].productID != 16 &&
          items![0].productID != 15) {
        if (items![0].isResult == "Y") {
          return InkWell(
            onTap: () {
              mualai();
            },
            child: Container(
              height: 40,
              margin: EdgeInsets.all(Dimen.marginDefault),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: ColorLot.ColorPrimary,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: Center(
                  child: Text(
                "Mua lại",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ),
          );
        }
      }
    }
    return SizedBox.shrink();
  }

  Widget _buildItem() {
    var size = MediaQuery.of(context).size;
    return Expanded(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: items!.length,
          itemBuilder: (BuildContext ctxt, int index) {
            var item = items![index];
            GetItemResultResponse? itemResult;
            if (item.isResult == "Y") {
              itemResult =
                  GetItemResultResponse.fromJson(jsonDecode(item.itemResult!));
            }
            return Container(
                margin: EdgeInsets.only(
                    top: Dimen.marginDefault,
                    right: Dimen.marginDefault,
                    left: Dimen.marginDefault),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15.0,
                          offset: Offset(0.0, 0.75))
                    ],
                    borderRadius:
                        BorderRadius.all(Radius.circular(Dimen.radiusBorder))),
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.all(2),
                            child: (item.productID == 14 ||
                                    item.productID == 15)
                                ? buildImageRadio(widget.order.radioLogo)
                                : Image(
                                    image: _buildImageProduct(item.productID),
                                    width: 46,
                                    height: 46,
                                  )),
                        SizedBox(
                            width: size.width - 96,
                            child: Column(
                              children: [
                                Text("#${widget.order.code!}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  item.productTypeID == 1
                                      ? "Vé thường"
                                      : (item.productID == Common.ID_LOTTO_535
                                          ? (item.systemA != 5
                                              ? "Bao số chính"
                                              : "Bao số đặc biệt")
                                          : "Bao ${item.bag}"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                (item.productID == 14 || item.productID == 15)
                                    ? Text(widget.order.radioName!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 12))
                                    : SizedBox.shrink()
                              ],
                            )),
                      ],
                    ),
                    _buildLineSimplified(item),
                    _buildImage(item),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Vé số ${index + 1}:",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    formatAmountD(item.price),
                                    style: TextStyle(
                                        color: ColorLot.ColorPrimary,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                              itemResult != null
                                  ? buildPrize(itemResult)
                                  : SizedBox.shrink()
                            ],
                          ),
                          _buildButtonStatusResult(item),
                        ],
                      ),
                    )
                  ],
                ));
          }),
    );
  }

  Widget buildPrize(GetItemResultResponse item) {
    if (item.prize! > 0) {
      return Row(
        children: [
          Text(
            "Tiền thưởng: ",
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(
            width: 2,
          ),
          Text(
            formatAmountD(item.prize!),
            style: TextStyle(
                color: ColorLot.ColorPrimary, fontWeight: FontWeight.w600),
          )
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget buildFooter(GetItemResponse item) {
    DateTime tempDate = DateFormat("dd/MM/yyyy").parse(item.drawDate!);
    String date = DateFormat("dd/MM/yyyy").format(tempDate);
    return Row(
      children: [
        Text(
          "Kỳ quay: ",
          style: TextStyle(color: Colors.black54),
        ),
        Text(
          "#${item.drawCode} ",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        Text(
          "Ngày: ",
          style: TextStyle(color: Colors.black54),
        ),
        Text("${getDayOfWeekVi(DateFormat('EEEE').format(tempDate))} - $date",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600))
      ],
    );
  }

  Widget _buildLineConditional(String label, String line, String system,
      int price, String symbols, GetItemResponse item) {
    if (line.isEmpty) return SizedBox.shrink();

    return Column(
      children: [
        if (label != "A") SizedBox(height: 8),
        item.productID == Common.ID_LOTTO_535
            ? _buildLineDetail535(label, line, system, price, symbols, item)
            : _buildLineDetail(label, line, system, price, item)
      ],
    );
  }

// Sử dụng helper method
  Widget _buildLineSimplified(GetItemResponse item) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          _buildLineConditional("A", item.lineA!, item.systemA!.toString(),
              item.priceA!, item.symbolA!, item),
          _buildLineConditional(
              "B",
              item.lineB ?? "",
              item.systemB?.toString() ?? "0",
              item.priceB ?? 0,
              item.symbolB!,
              item),
          _buildLineConditional(
              "C",
              item.lineC ?? "",
              item.systemC?.toString() ?? "0",
              item.priceC ?? 0,
              item.symbolC!,
              item),
          _buildLineConditional(
              "D",
              item.lineD ?? "",
              item.systemD?.toString() ?? "0",
              item.priceD ?? 0,
              item.symbolD!,
              item),
          _buildLineConditional(
              "E",
              item.lineE ?? "",
              item.systemE?.toString() ?? "0",
              item.priceE ?? 0,
              item.symbolE!,
              item),
          _buildLineConditional(
              "F",
              item.lineF ?? "",
              item.systemF?.toString() ?? "0",
              item.priceF ?? 0,
              item.symbolF!,
              item),
          SizedBox(height: 8),
          buildFooter(item),
        ],
      ),
    );
  }

  Widget _buildLineDetail(String title, String line, String system, int amount,
      GetItemResponse item) {
    List<String> results = [];
    if (item.isResult == "Y") {
      GetResultLotoMBResponse mb =
          GetResultLotoMBResponse.fromJson(jsonDecode(item.result!));

      if (item.productID == Common.ID_LOTO235) {
        if (line.length == 2) {
          results.add(mb.result!.substring(3));
        } else if (line.length == 3) {
          results.add(mb.result!.substring(2));
        } else if (line.length == 5) {
          results.add(mb.result!);
        }
      } else if (item.productID == Common.ID_LOTO234) {
        results.add(mb.result!.substring(3));
        results.add(mb.result01!.substring(3));
        for (int i = 0; i < mb.result02!.split(',').length; i++) {
          results.add(mb.result02!.split(',')[i].substring(3));
        }
        for (int i = 0; i < mb.result03!.split(',').length; i++) {
          results.add(mb.result03!.split(',')[i].substring(3));
        }
        for (int i = 0; i < mb.result04!.split(',').length; i++) {
          results.add(mb.result04!.split(',')[i].substring(2));
        }
        for (int i = 0; i < mb.result05!.split(',').length; i++) {
          results.add(mb.result05!.split(',')[i].substring(2));
        }
        for (int i = 0; i < mb.result06!.split(',').length; i++) {
          results.add(mb.result06!.split(',')[i].substring(1));
        }
        for (int i = 0; i < mb.result07!.split(',').length; i++) {
          results.add(mb.result07!.split(',')[i]);
        }
      } else if (item.productID == Common.ID_DIENTOAN_636 ||
          item.productID == Common.ID_KENO ||
          item.productID == Common.ID_MEGA ||
          item.productID == Common.ID_POWER) {
        results.addAll(mb.result!.split(','));
      } else if (item.productID == Common.ID_MAX3D ||
          item.productID == Common.ID_MAX3D_PLUS ||
          item.productID == Common.ID_MAX3D_PRO) {
        GetResultMax3DResponse max3d =
            GetResultMax3DResponse.fromJson(jsonDecode(item.result!));

        for (int i = 0; i < max3d.resultST!.split(',').length; i++) {
          results.add(max3d.resultST!.split(',')[i]);
        }

        for (int i = 0; i < max3d.resultND!.split(',').length; i++) {
          results.add(max3d.resultND!.split(',')[i]);
        }

        for (int i = 0; i < max3d.resultRD!.split(',').length; i++) {
          results.add(max3d.resultRD!.split(',')[i]);
        }

        for (int i = 0; i < max3d.resultENC!.split(',').length; i++) {
          results.add(max3d.resultENC!.split(',')[i]);
        }
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text(
                title,
                style: TextStyle(
                    color: ColorLot.ColorPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
                child: Wrap(
              children: line.split(",").map((e) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Text(e,
                      style: TextStyle(
                          color: results.contains(e)
                              ? ColorLot.ColorPrimary
                              : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                );
              }).toList(),
            )),
          ],
        )),
        SizedBox(
          width: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(system),
              SizedBox(
                width: 4,
              ),
              Text(formatAmountD(amount),
                  style: TextStyle(
                      color: ColorLot.ColorPrimary,
                      fontSize: Dimen.fontSizeAmount,
                      fontWeight: FontWeight.w600))
            ],
          ),
        )
      ],
    );
  }

  Widget _buildLineDetail535(String title, String line, String system,
      int amount, String symbols, GetItemResponse item) {
    List<String> results = [];
    String bonus = "";
    if (item.isResult == "Y") {
      GetResultResponse mb =
          GetResultResponse.fromJson(jsonDecode(item.result!));
      results.addAll(mb.result!.split(','));
      bonus = mb.bonus!;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: Text(
                  title,
                  style: TextStyle(
                      color: ColorLot.ColorPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: Wrap(
                  children: [
                    // Hiển thị các số chính (line)
                    ...line.split(",").map((e) {
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        child: Text(e,
                            style: TextStyle(
                                color: results.contains(e)
                                    ? ColorLot.ColorPrimary
                                    : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      );
                    }).toList(),

                    // Hiển thị dấu phân cách và symbols nếu có
                    if (symbols.isNotEmpty) ...[
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        child: Text(
                          "|",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      // Hiển thị các symbols với màu đỏ
                      ...symbols.split(",").map((e) {
                        return Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          child: Text(e,
                              style: TextStyle(
                                  color: !bonus.contains(e)
                                      ? ColorLot.ColorPrimary
                                      : Colors.red, // Màu đỏ cho symbols
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        );
                      }).toList(),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButtonStatusResult(GetItemResponse item) {
    String? status;
    Color? color;

    if (item.isWin == "Y") {
      color = ColorLot.ColorPrimary;
      status = "Trúng thưởng";
    } else {
      if (item.isResult == "N") {
        color = Colors.green;
        status = "Chưa xổ";
      } else {
        color = Colors.black54;
        status = "So kết quả";
      }
    }
    return InkWell(
      onTap: () {
        if (item.isResult != "N") {
          onCompare(item);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(width: 1, color: color)),
        child: Row(
          children: [
            item.isWin == "Y"
                ? Icon(Ionicons.trophy_outline, color: ColorLot.ColorPrimary)
                : SizedBox.shrink(),
            Text(
              status,
              style: TextStyle(color: color),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImage(GetItemResponse item) {
    if (item.imgBefore == null || item.imgBefore!.isEmpty) {
      return SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 8,
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HeroPhotoViewRouteWrapper(
                  imageProvider: NetworkImage(
                    urlImage + item.imgBefore!,
                  ),
                ),
              ),
            );
          },
          child: Image.network(
            urlImage + item.imgBefore!,
            width: 150,
            height: 150,
          ),
        ),
        if (item.productID == Common.ID_MEGA ||
            item.productID == Common.ID_POWER ||
            item.productID == Common.ID_MAX3D_PLUS ||
            item.productID == Common.ID_MAX3D_PRO)
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HeroPhotoViewRouteWrapper(
                    imageProvider: NetworkImage(
                      urlImage + item.imgAfter!,
                    ),
                  ),
                ),
              );
            },
            child: Image.network(
              urlImage + item.imgAfter!,
              width: 150,
              height: 150,
            ),
          ),
      ],
    );
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
      case Common.ID_LOTTO_535:
        return AssetImage('assets/img/lotto535.png');
      default:
        return AssetImage('assets/img/mienbac.png');
    }
  }

  Image buildImageRadio(images) {
    return Image.network(
      urlImage + images!,
      width: 46,
      height: 46,
    );
  }
}
