import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:lottery_flutter_application/constants/common.dart';
import 'package:lottery_flutter_application/controller/dictionary_controller.dart';
import 'package:lottery_flutter_application/models/response/params_response.dart';
import 'package:lottery_flutter_application/models/response/response_object.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/view/account/login_view.dart';
import 'package:lottery_flutter_application/view/main/f_result_view.dart';
import 'package:lottery_flutter_application/view/main/main_shell_view.dart';
import 'package:lottery_flutter_application/view/main/main_view.dart';
import 'utils/storage_util.dart';
import 'package:google_fonts/google_fonts.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call initializeApp before using other Firebase services.
  print("Handling a background message : ${message.messageId}");
}

Future<void> setupFlutterNotifications() async {
  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   name: "Luckylotter",
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  // await setupFlutterNotifications();
  //await StorageUtil.getInstance();
  String initialAppRoute = await getRoute();
  runApp(MyApp(initialRoute: initialAppRoute));
}

Future<String> getRoute() async {
  DictionaryController dictionaryController = DictionaryController();
  ResponseObject res = await dictionaryController.getPrams();
  if (res.code == "00") {
    List<ParamsResponse> params = List<ParamsResponse>.from(
        (jsonDecode(res.data!).map((model) => ParamsResponse.fromJson(model))));

    ParamsResponse p;
    if (Common.CHANNEL == "IOS") {
      p = params
          .where((element) => element.parameter == "APPLE_MODE_UPLOAD")
          .first;
    } else {
      p = params
          .where((element) => element.parameter == "CHPLAY_MODE_UPLOAD")
          .first;
    }
    if (p.value == "ON") {
      return "/result";
    }
    return "/main";
  } else {
    return "/result";
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Happy Lott',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // fontFamily: 'sans-serif',
          colorScheme: ColorScheme.fromSeed(seedColor: ColorLot.ColorPrimary),
          useMaterial3: true,
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        initialRoute: initialRoute,
        routes: {
          "/main": (context) => const LoginView(),
          "/result": (context) => const MainShellView(),
          "/": (context) => const MainShellView(),
        });
  }

  // This widget is the root of your application.
}
