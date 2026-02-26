import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lottery_flutter_application/utils/color_lot.dart';
import 'package:lottery_flutter_application/view/account/login_view.dart';
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
  await StorageUtil.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        // home: TicketTogetherHistoryView());
        home: StorageUtil.getString("user") != ""
            ? const MainView()
            : const LoginView());
  }

  // This widget is the root of your application.
}
