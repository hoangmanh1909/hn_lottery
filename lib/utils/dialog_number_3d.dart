import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/constants/common.dart';

import 'color_lot.dart';
import 'dimen.dart';

class Line3DView extends StatefulWidget {
  const Line3DView(
      {super.key,
      required this.product,
      required this.listBall,
      required this.line,
      required this.selectedBall});

  final int product;
  final List<String>? listBall;
  final String line;
  final Function selectedBall;

  @override
  State<Line3DView> createState() => _Line3DView();
}

class _Line3DView extends State<Line3DView> {
  StateSetter? _setState;
  List<String> balss = List.generate(10, (index) => (index).toString());
  List<String> balss1 = List.generate(10, (index) => (index).toString());
  List<String> balss2 = List.generate(10, (index) => (index).toString());

  List<String> balss3 = List.generate(10, (index) => (index).toString());
  List<String> balss4 = List.generate(10, (index) => (index).toString());
  List<String> balss5 = List.generate(10, (index) => (index).toString());

  final List<String> _balls = [];
  final List<String> _balls1 = [];
  final List<String> _balls2 = [];

  final List<String> _balls3 = [];
  final List<String> _balls4 = [];
  final List<String> _balls5 = [];

  onTapBall(value, type) {
    if (type == 0) {
      _balls.clear();
      _setState!(() {
        _balls.add(value);
      });
    } else if (type == 1) {
      _balls1.clear();
      _setState!(() {
        _balls1.add(value);
      });
    } else if (type == 2) {
      _balls2.clear();
      _setState!(() {
        _balls2.add(value);
      });
    } else if (type == 3) {
      _balls3.clear();
      _setState!(() {
        _balls3.add(value);
      });
    } else if (type == 4) {
      _balls4.clear();
      _setState!(() {
        _balls4.add(value);
      });
    }
    if (type == 5) {
      _balls5.clear();
      _setState!(() {
        _balls5.add(value);
      });
    }
  }

  onClear() {
    _setState!(() {
      _balls.clear();
      _balls1.clear();
      _balls2.clear();
      _balls3.clear();
      _balls4.clear();
      _balls5.clear();
    });
  }

  onSelectedBall() {
    if (_balls.isNotEmpty &&
        _balls1.isNotEmpty &&
        _balls2.isNotEmpty &&
        _balls3.isNotEmpty &&
        _balls4.isNotEmpty &&
        _balls5.isNotEmpty) {
      List<String> a = [
        _balls[0],
        _balls1[0],
        _balls2[0],
      ];
      List<String> b = [
        _balls3[0],
        _balls4[0],
        _balls5[0],
      ];
      List<String> balls = [a.join(""), b.join("")];
      widget.selectedBall(widget.line, balls);
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  showDialogBall() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            actionsAlignment: MainAxisAlignment.center,
            titlePadding: const EdgeInsets.all(10),
            contentPadding: const EdgeInsets.all(10),
            actionsPadding: const EdgeInsets.all(10),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                _setState = setState;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Chọn số",
                            style: TextStyle(fontSize: Dimen.fontSizeTitle),
                          ),
                          InkWell(
                            onTap: () => {Navigator.pop(context)},
                            child: Container(
                              alignment: Alignment.center,
                              height: Dimen.buttonHeight,
                              child: const Text(
                                "Đóng",
                                style: TextStyle(
                                    color: ColorLot.ColorPrimary,
                                    fontSize: Dimen.fontSizeTitle),
                              ),
                            ),
                          )
                        ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Wrap(
                          direction: Axis.vertical,
                          children: balss.map((item) {
                            return _balls.contains(item)
                                ? ballSelected(item, 0)
                                : ballNormal(item, 0);
                          }).toList(),
                        ),
                        Wrap(
                          direction: Axis.vertical,
                          children: balss1.map((item) {
                            return _balls1.contains(item)
                                ? ballSelected(item, 1)
                                : ballNormal(item, 1);
                          }).toList(),
                        ),
                        Wrap(
                          direction: Axis.vertical,
                          children: balss2.map((item) {
                            return _balls2.contains(item)
                                ? ballSelected(item, 2)
                                : ballNormal(item, 2);
                          }).toList(),
                        ),
                        Container(
                          margin: const EdgeInsets.all(6),
                          width: 1,
                          height: 360,
                          color: Colors.grey,
                        ),
                        Wrap(
                          direction: Axis.vertical,
                          children: balss3.map((item) {
                            return _balls3.contains(item)
                                ? ballSelected(item, 3)
                                : ballNormal(item, 3);
                          }).toList(),
                        ),
                        Wrap(
                          direction: Axis.vertical,
                          children: balss4.map((item) {
                            return _balls4.contains(item)
                                ? ballSelected(item, 4)
                                : ballNormal(item, 4);
                          }).toList(),
                        ),
                        Wrap(
                          direction: Axis.vertical,
                          children: balss5.map((item) {
                            return _balls5.contains(item)
                                ? ballSelected(item, 5)
                                : ballNormal(item, 5);
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: onClear,
                            child: Container(
                              alignment: Alignment.center,
                              height: Dimen.buttonHeight,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(
                                          Dimen.radiusBorderButton)),
                                  border: Border.all(
                                      color: ColorLot.ColorPrimary, width: 1)),
                              child: const Text(
                                "Chọn lại",
                                style: TextStyle(color: ColorLot.ColorPrimary),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: InkWell(
                          onTap: onSelectedBall,
                          child: Container(
                            alignment: Alignment.center,
                            height: Dimen.buttonHeight,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(Dimen.radiusBorderButton)),
                                border: Border.all(
                                    color: ColorLot.ColorSuccess, width: 1)),
                            child: const Text(
                              "Đồng ý",
                              style: TextStyle(color: ColorLot.ColorSuccess),
                            ),
                          ),
                        ))
                      ],
                    )
                  ],
                );
              },
            ));
      },
    );
  }

  Widget ballNormal(item, type) {
    return InkWell(
      onTap: () => onTapBall(item, type),
      child: Container(
        alignment: Alignment.center,
        width: Dimen.sizeBall,
        height: Dimen.sizeBall,
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: ColorLot.ColorPrimary, width: 1)),
        child: Text(item,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.0,
                color: Colors.black)),
      ),
    );
  }

  Widget ballSelected(item, type) {
    return InkWell(
      onTap: () => onTapBall(item, type),
      child: Container(
        alignment: Alignment.center,
        width: Dimen.sizeBall,
        height: Dimen.sizeBall,
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorLot.ColorPrimary,
            border: Border.all(color: ColorLot.ColorPrimary, width: 1)),
        child: Text(item,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.0,
                color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width - 180,
      child: Wrap(
        direction: Axis.horizontal,
        children: widget.listBall!.map((item) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: showDialogBall,
                child: Container(
                  width: 64,
                  height: Dimen.sizeBall,
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border:
                          Border.all(color: ColorLot.ColorPrimary, width: 1)),
                  child: Center(
                    child: Text(item,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            letterSpacing: 0.0,
                            color: Colors.black)),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
