// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottery_flutter_application/constants/common.dart';
import 'package:lottery_flutter_application/models/response/get_item_response.dart';
import 'package:lottery_flutter_application/models/response/get_item_result_respose.dart';
import 'package:lottery_flutter_application/models/response/get_result_keno_response.dart';
import 'package:lottery_flutter_application/models/response/get_result_max3d_response.dart';
import 'package:lottery_flutter_application/models/response/get_result_response.dart';
import 'package:lottery_flutter_application/view/result/result_keno_view.dart';
import 'package:lottery_flutter_application/view/result/result_loto_636_view.dart';
import 'package:lottery_flutter_application/view/result/result_lotto_535.dart';
import 'package:lottery_flutter_application/view/result/result_max3d_view.dart';
import 'package:lottery_flutter_application/view/result/result_mb_view.dart';
import 'package:lottery_flutter_application/view/result/result_mega_view.dart';
import 'package:lottery_flutter_application/view/result/result_miennam_view.dart';
import 'package:lottery_flutter_application/view/result/result_power_view.dart';

import '../../models/response/get_result_lotomb_response.dart';
import '../../utils/color_lot.dart';
import '../../utils/common.dart';
import '../../utils/dimen.dart';

class HistoryCompareView extends StatefulWidget {
  const HistoryCompareView({Key? key, required this.item}) : super(key: key);
  final GetItemResponse item;
  @override
  State<HistoryCompareView> createState() => _HistoryCompareViewState();
}

class _HistoryCompareViewState extends State<HistoryCompareView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorLot.ColorPrimary,
          automaticallyImplyLeading: false,
          centerTitle: true,
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          title: const Text('So vé'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Scaffold(
          backgroundColor: ColorLot.ColorBackground,
          body: SingleChildScrollView(
            child: buildResult(widget.item),
          ),
        ));
  }

  Widget buildResult(GetItemResponse item) {
    if (item.productID == Common.ID_LOTO234 ||
        item.productID == Common.ID_LOTO235 ||
        item.productID == Common.ID_XSKT_MB) {
      List<GetResultLotoMBResponse> xsktMienBacs = [];
      GetResultLotoMBResponse mb =
          GetResultLotoMBResponse.fromJson(jsonDecode(item.result!));
      xsktMienBacs.add(mb);
      return Column(children: [
        SizedBox(
          height: 428,
          child: ResultMienBacView(xsktMienBac: xsktMienBacs),
        ),
        Container(
          margin: EdgeInsets.all(Dimen.marginDefault),
          padding: EdgeInsets.all(Dimen.padingDefault),
          width: double.infinity,
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
          child: buildTicket(item),
        ),
      ]);
    } else if (item.productID == Common.ID_XSKT_MT ||
        item.productID == Common.ID_XSKT_MN) {
      List<GetResultLotoMBResponse> xsktMienBacs = [];
      GetResultLotoMBResponse mb =
          GetResultLotoMBResponse.fromJson(jsonDecode(item.result!));
      xsktMienBacs.add(mb);
      return Column(children: [
        SizedBox(
          height: 394,
          child: ResultMienNamView(xsktMienNam: xsktMienBacs),
        ),
        Container(
          margin: EdgeInsets.all(Dimen.marginDefault),
          padding: EdgeInsets.all(Dimen.padingDefault),
          width: double.infinity,
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
          child: buildTicket(item),
        ),
      ]);
    } else if (item.productID == Common.ID_DIENTOAN_636) {
      List<GetResultResponse> result636 = [];
      GetResultResponse mb =
          GetResultResponse.fromJson(jsonDecode(item.result!));
      result636.add(mb);

      return Column(children: [
        SizedBox(
          height: 70,
          child: Result606View(result636: result636),
        ),
        Container(
          margin: EdgeInsets.all(Dimen.marginDefault),
          padding: EdgeInsets.all(Dimen.padingDefault),
          width: double.infinity,
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
          child: buildTicket(item),
        ),
      ]);
    } else if (item.productID == Common.ID_KENO) {
      List<GetResultKenoResponse> resultKeno = [];
      GetResultKenoResponse keno =
          GetResultKenoResponse.fromJson(jsonDecode(item.result!));
      resultKeno.add(keno);

      return Column(children: [
        SizedBox(
          height: 178,
          child: ResultKenoView(kenoResults: resultKeno),
        ),
        Container(
          margin: EdgeInsets.all(Dimen.marginDefault),
          padding: EdgeInsets.all(Dimen.padingDefault),
          width: double.infinity,
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
          child: buildTicket(item),
        ),
      ]);
    } else if (item.productID == Common.ID_MEGA) {
      List<GetResultResponse> results = [];
      GetResultResponse result =
          GetResultResponse.fromJson(jsonDecode(item.result!));
      results.add(result);

      return Column(children: [
        SizedBox(
          height: 66,
          child: ResultMegaView(megaResults: results),
        ),
        Container(
          margin: EdgeInsets.all(Dimen.marginDefault),
          padding: EdgeInsets.all(Dimen.padingDefault),
          width: double.infinity,
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
          child: buildTicket(item),
        ),
      ]);
    } else if (item.productID == Common.ID_POWER) {
      List<GetResultResponse> results = [];
      GetResultResponse result =
          GetResultResponse.fromJson(jsonDecode(item.result!));
      results.add(result);

      return Column(children: [
        SizedBox(
          height: 62,
          child: ResultPowerView(powerResults: results),
        ),
        Container(
          margin: EdgeInsets.all(Dimen.marginDefault),
          padding: EdgeInsets.all(Dimen.padingDefault),
          width: double.infinity,
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
          child: buildTicket(item),
        ),
      ]);
    } else if (item.productID == Common.ID_LOTTO_535) {
      List<GetResultResponse> results = [];
      GetResultResponse result =
          GetResultResponse.fromJson(jsonDecode(item.result!));
      results.add(result);

      return Column(children: [
        SizedBox(
          height: 62,
          child: ResultLotto535View(powerResults: results),
        ),
        Container(
          margin: EdgeInsets.all(Dimen.marginDefault),
          padding: EdgeInsets.all(Dimen.padingDefault),
          width: double.infinity,
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
          child: buildTicket(item),
        ),
      ]);
    } else if (item.productID == Common.ID_MAX3D ||
        item.productID == Common.ID_MAX3D_PLUS ||
        item.productID == Common.ID_MAX3D_PRO) {
      List<GetResultMax3DResponse> results = [];
      GetResultMax3DResponse result =
          GetResultMax3DResponse.fromJson(jsonDecode(item.result!));
      results.add(result);

      return Column(children: [
        SizedBox(
          height: 330,
          child: ResultMax3DView(max3dResults: results),
        ),
        Container(
          margin: EdgeInsets.all(Dimen.marginDefault),
          padding: EdgeInsets.all(Dimen.padingDefault),
          width: double.infinity,
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
          child: buildTicket(item),
        ),
      ]);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildTicket(GetItemResponse item) {
    GetItemResultResponse itemResult =
        GetItemResultResponse.fromJson(jsonDecode(item.itemResult!));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Các vé bạn đã mua trong kỳ"),
        _buildLine(item),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            const Text("Tiền thưởng"),
            const SizedBox(
              width: 8,
            ),
            Text(
              formatAmountD(itemResult.prize),
              style: const TextStyle(
                  color: ColorLot.ColorPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            )
          ],
        )
      ],
    );
  }

  Widget _buildLine(GetItemResponse item) {
    GetItemResultResponse itemResult =
        GetItemResultResponse.fromJson(jsonDecode(item.itemResult!));

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          _buildLineConditional(
              "A",
              item.productTypeID == 3 || item.productTypeID == 5
                  ? getProductTypeName(item.lineA!)
                  : item.lineA!,
              item.productTypeID != 3 && item.productTypeID != 5
                  ? item.systemA!.toString()
                  : "",
              itemResult.prizeA!,
              item.symbolA ?? "",
              item),
          _buildLineConditional(
              "B",
              item.lineB ?? "",
              item.productTypeID != 3 && item.productTypeID != 5
                  ? (item.systemB?.toString() ?? "")
                  : "",
              itemResult.prizeB ?? 0,
              item.symbolB ?? "",
              item),
          _buildLineConditional(
              "C",
              item.lineC ?? "",
              item.productTypeID != 3 && item.productTypeID != 5
                  ? (item.systemC?.toString() ?? "")
                  : "",
              itemResult.prizeC ?? 0,
              item.symbolC ?? "",
              item),
          _buildLineConditional(
              "D",
              item.lineD ?? "",
              item.productTypeID != 3 && item.productTypeID != 5
                  ? (item.systemD?.toString() ?? "")
                  : "",
              itemResult.prizeD ?? 0,
              item.symbolD ?? "",
              item),
          _buildLineConditional(
              "E",
              item.lineE ?? "",
              item.productTypeID != 3 && item.productTypeID != 5
                  ? (item.systemE?.toString() ?? "")
                  : "",
              itemResult.prizeE ?? 0,
              item.symbolE ?? "",
              item),
          _buildLineConditional(
              "F",
              item.lineF ?? "",
              item.productTypeID != 3 && item.productTypeID != 5
                  ? (item.systemF?.toString() ?? "")
                  : "",
              itemResult.prizeF ?? 0,
              item.symbolF ?? "",
              item),
        ],
      ),
    );
  }

// Helper method để xử lý điều kiện hiển thị line
  Widget _buildLineConditional(String label, String line, String system,
      int prize, String symbol, GetItemResponse item) {
    if (line.isEmpty) return SizedBox.shrink();

    return Column(
      children: [
        if (label != "A") SizedBox(height: 8),
        item.productID == Common.ID_LOTTO_535
            ? _buildLineDetail535(label, line, system, prize, symbol, item)
            : _buildLineDetail(label, line, system, prize, item)
      ],
    );
  }

  Widget _buildLineDetail(String title, String line, String system, int amount,
      GetItemResponse item) {
    GetResultLotoMBResponse mb =
        GetResultLotoMBResponse.fromJson(jsonDecode(item.result!));
    List<String> results = [];
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          width: 30,
          child: (amount > 0)
              ? Icon(Ionicons.trophy_outline, color: ColorLot.ColorSuccess)
              : SizedBox.shrink(),
        )
      ],
    );
  }
}

Widget _buildLineDetail535(String title, String line, String system, int amount,
    String symbols, GetItemResponse item) {
  List<String> results = [];
  String bonus = "";
  if (item.isResult == "Y") {
    GetResultResponse mb = GetResultResponse.fromJson(jsonDecode(item.result!));
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

                  // Hiển thị dấu phân cách và symbols nếu có
                  if (symbols.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
