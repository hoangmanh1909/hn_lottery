import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 40, // Ép chiều cao đúng 40px
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets
                .zero, // Xóa padding mặc định để chữ căn giữa chuẩn theo 40px
            backgroundColor: backgroundColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14, // Với cao 40, size 14-15 là vừa mắt
            ),
          ),
        ),
      ),
    );
  }
}
