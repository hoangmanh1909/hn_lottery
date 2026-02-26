import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';

class IconWithBackground extends StatelessWidget {
  final IconData icon; // Icon đầu vào
  final double size; // Size của icon
  final Color? iconColor; // Màu icon (tùy chọn)
  final Color backgroundColor; // Màu nền (mặc định là #ffe0e0)
  final double padding; // Khoảng cách đệm

  const IconWithBackground({
    Key? key,
    required this.icon,
    this.size = 25.0,
    this.iconColor,
    this.backgroundColor = const Color(0xFFFFE0E0),
    this.padding = 6.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius:
            BorderRadius.circular(8), // Bạn có thể chỉnh sửa độ bo góc ở đây
      ),
      child: Icon(
        icon,
        size: size,
        color: iconColor ??
            ColorLot.ColorPrimary, // Nếu không truyền màu thì lấy mặc định
      ),
    );
  }
}
