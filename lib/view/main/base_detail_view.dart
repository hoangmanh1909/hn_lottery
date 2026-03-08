import 'package:flutter/material.dart';
import '../../utils/color_lot.dart';

class BaseDetailView extends StatelessWidget {
  final String title;
  final Widget body;

  const BaseDetailView({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorLot.ColorBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: ColorLot.ColorPrimary,
          elevation: 0,
          centerTitle: true,
          // Nút back tự động của trang độc lập
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
          ),
          title: Text(
            title.toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: body, // Code cũ của bro sẽ nằm ở đây
    );
  }
}
