import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/utils/dimen.dart';

class CountdownLottery extends StatefulWidget {
  @override
  _CountdownLotteryState createState() => _CountdownLotteryState();
}

class _CountdownLotteryState extends State<CountdownLottery> {
  Timer? _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Hàm tính thời gian đích
  DateTime _calculateTargetTime() {
    final now = DateTime.now();
    final currentHour = now.hour;
    DateTime target;

    if (currentHour > 13 && currentHour < 21) {
      // Nếu quá 13h: countdown đến 21h cùng ngày
      target = DateTime(now.year, now.month, now.day, 21, 0, 0);
    } else {
      // Nếu quá 21h: countdown đến 13h ngày hôm sau
      if (currentHour >= 21) {
        target = DateTime(now.year, now.month, now.day + 1, 13, 0, 0);
      } else {
        // Nếu <= 13h: countdown đến 13h cùng ngày
        target = DateTime(now.year, now.month, now.day, 13, 0, 0);
      }
    }

    return target;
  }

  // Hàm tính thời gian còn lại
  Duration _calculateTimeLeft() {
    final now = DateTime.now();
    final targetTime = _calculateTargetTime();
    final difference = targetTime.difference(now);

    if (difference.isNegative) {
      return Duration.zero;
    }

    return difference;
  }

  // Start countdown
  void _startCountdown() {
    // Update ngay lập tức
    _updateCountdown();

    // Set timer để update mỗi giây
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateCountdown();
    });
  }

  // Update countdown
  void _updateCountdown() {
    setState(() {
      _timeLeft = _calculateTimeLeft();
    });
  }

  // Format thời gian với leading zero
  String _zeroPad(int number, int width) {
    return number.toString().padLeft(width, '0');
  }

  // Format duration thành HH:MM:SS
  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return "Thời gian còn ${_zeroPad(hours, 2)}:${_zeroPad(minutes, 2)}:${_zeroPad(seconds, 2)}";
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDuration(_timeLeft),
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: Dimen.fontSizeDefault),
    );
  }
}
