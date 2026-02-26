import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/utils/dimen.dart';

class LineView extends StatefulWidget {
  LineView({
    super.key,
    required this.system,
    required this.systemSpecial,
    required this.listBall,
    required this.listsp,
    required this.line,
    required this.selectedBall,
    required this.balss,
    required this.specialBalls,
  });

  final int system;
  final int systemSpecial;
  final List<String> balss;
  final List<String> specialBalls;
  List<String>? listBall;
  List<String>? listsp;
  final String line;
  final Function selectedBall;

  @override
  State<LineView> createState() => _LineView();
}

class _LineView extends State<LineView> {
  StateSetter? _setState;
  final List<String> _balls = [];
  final List<String> _specialBalls = [];

  @override
  void initState() {
    super.initState();
    // Load dữ liệu hiện tại vào _balls và _specialBalls
    _balls.clear();
    _specialBalls.clear();

    if (widget.listBall != null) {
      for (String ball in widget.listBall!) {
        if (ball.isNotEmpty) {
          _balls.add(ball);
        }
      }
    }

    if (widget.listsp != null) {
      for (String ball in widget.listsp!) {
        if (ball.isNotEmpty) {
          _specialBalls.add(ball);
        }
      }
    }
  }

  onTapBall(value, {bool isSpecial = false}) {
    List<String> targetList = isSpecial ? _specialBalls : _balls;
    int maxLength = isSpecial ? widget.systemSpecial : widget.system;

    if (targetList.contains(value)) {
      _setState!(() {
        targetList.remove(value);
      });
    } else {
      if (targetList.length < maxLength) {
        _setState!(() {
          targetList.add(value);
        });
      }
    }
  }

  onSelectedBall() {
    bool mainComplete = widget.system == _balls.length;
    bool specialComplete = widget.systemSpecial == _specialBalls.length;

    if (mainComplete && specialComplete) {
      widget.selectedBall(widget.line, _balls, _specialBalls);
      Navigator.of(context, rootNavigator: true).pop();
    } else {
      if (mainComplete) {
        widget.selectedBall(widget.line, _balls, widget.listsp);
        Navigator.of(context, rootNavigator: true).pop();
      }
      if (specialComplete) {
        widget.selectedBall(widget.line, widget.listBall, _specialBalls);
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  onClear({bool isSpecial = false}) {
    _setState!(() {
      if (isSpecial) {
        _specialBalls.clear();
      } else {
        _balls.clear();
      }
    });
  }

  showDialogBall({bool isSpecial = false}) {
    List<String> availableNumbers =
        isSpecial ? widget.specialBalls : widget.balss;
    List<String> selectedNumbers = isSpecial ? _specialBalls : _balls;
    int maxSelection = isSpecial ? widget.systemSpecial : widget.system;
    String title = isSpecial ? "Chọn số đặc biệt" : "Chọn số chính";
    Color primaryColor = !isSpecial ? Colors.orange : ColorLot.ColorPrimary;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          actionsAlignment: MainAxisAlignment.center,
          titlePadding: EdgeInsets.all(10),
          contentPadding: EdgeInsets.all(10),
          actionsPadding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: StatefulBuilder(
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
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: Dimen.fontSizeTitle,
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: () => {Navigator.pop(context)},
                              child: Container(
                                alignment: Alignment.center,
                                height: Dimen.buttonHeight,
                                child: Text(
                                  "Đóng",
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: Dimen.fontSizeTitle),
                                ),
                              ),
                            )
                          ]),
                      Wrap(
                        alignment: WrapAlignment.center,
                        direction: Axis.horizontal,
                        children: availableNumbers.map((item) {
                          return selectedNumbers.contains(item)
                              ? ballSelected(item, isSpecial: isSpecial)
                              : ballNormal(item, isSpecial: isSpecial);
                        }).toList(),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Bạn đã chọn: ${selectedNumbers.length}/$maxSelection",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => onClear(isSpecial: isSpecial),
                              child: Container(
                                alignment: Alignment.center,
                                height: Dimen.buttonHeight,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            Dimen.radiusBorderButton)),
                                    border: Border.all(
                                        color: primaryColor, width: 1)),
                                child: Text(
                                  "Chọn lại",
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                              child: InkWell(
                            onTap: onSelectedBall,
                            child: Container(
                              alignment: Alignment.center,
                              height: Dimen.buttonHeight,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          Dimen.radiusBorderButton)),
                                  color:
                                      (selectedNumbers.length == maxSelection)
                                          ? ColorLot.ColorSuccess
                                          : Colors.grey[300],
                                  border: Border.all(
                                      color: (selectedNumbers.length ==
                                              maxSelection)
                                          ? ColorLot.ColorSuccess
                                          : Colors.grey,
                                      width: 1)),
                              child: Text(
                                "Đồng ý",
                                style: TextStyle(
                                  color:
                                      (selectedNumbers.length == maxSelection)
                                          ? Colors.white
                                          : Colors.grey,
                                ),
                              ),
                            ),
                          ))
                        ],
                      )
                    ],
                  );
                },
              )),
        );
      },
    );
  }

  Widget ballNormal(item, {bool isSpecial = false}) {
    Color borderColor = !isSpecial ? Colors.orange : ColorLot.ColorPrimary;

    return InkWell(
      onTap: () => onTapBall(item, isSpecial: isSpecial),
      child: Container(
        alignment: Alignment.center,
        width: Dimen.sizeBallDialog,
        height: Dimen.sizeBallDialog,
        margin: EdgeInsets.all(3),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 1)),
        child: Text(item,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.0,
                color: Colors.black)),
      ),
    );
  }

  Widget ballSelected(item, {bool isSpecial = false}) {
    Color bgColor = !isSpecial ? Colors.orange : ColorLot.ColorPrimary;

    return InkWell(
      onTap: () => onTapBall(item, isSpecial: isSpecial),
      child: Container(
        alignment: Alignment.center,
        width: Dimen.sizeBallDialog,
        height: Dimen.sizeBallDialog,
        margin: EdgeInsets.all(3),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor,
            border: Border.all(color: bgColor, width: 1)),
        child: Text(item,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.0,
                color: Colors.white)),
      ),
    );
  }

  Widget _buildBallItem(String item, {bool isSpecial = false}) {
    // Màu viền
    Color borderColor = isSpecial ? Colors.red : Colors.orange;

    // Màu nền và text
    Color bgColor, textColor;
    if (item.isEmpty) {
      bgColor = Colors.white;
      textColor = Colors.grey;
    } else {
      bgColor = isSpecial ? Colors.red : Colors.orange;
      textColor = Colors.white;
    }

    return InkWell(
      onTap: () => showDialogBall(isSpecial: isSpecial),
      child: Container(
        width: Dimen.sizeBall,
        height: Dimen.sizeBall,
        margin: EdgeInsets.all(3),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor,
            border: Border.all(color: borderColor, width: 1)),
        child: Center(
          child: Text(
            item.isEmpty ? "" : item,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.0,
                color: textColor),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width - 180,
      child: Wrap(
        children: [
          // Các ô số chính (màu cam)
          ...List.generate(widget.system, (index) {
            String item =
                index < widget.listBall!.length ? widget.listBall![index] : "";
            return _buildBallItem(item, isSpecial: false);
          }),

          SizedBox(width: 8),

          // Các ô số đặc biệt (màu đỏ/tím)
          ...List.generate(widget.systemSpecial, (index) {
            String item =
                index < widget.listsp!.length ? widget.listsp![index] : "";
            return _buildBallItem(item, isSpecial: true);
          }),
        ],
      ),
    );
  }
}
