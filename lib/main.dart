import 'package:flutter/material.dart';
// import 'package:flutter_application/routes.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/screens/dashboard.dart';
import 'package:flutter_application/screens/login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var storage = FlutterSecureStorage();
    Future<String?> value = storage.read(key: "userMobNo");
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: LoginDemo(),
      // initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/dashboard') {
          // final value = settings.arguments as int; // Retrieve the value.
          return MaterialPageRoute(builder: (_) => const Dashboard());
        }
        return null; // Let `onUnknownRoute` handle this behavior.
      },
    );
  }
}
