import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginDemo(),
    );
  }
}

class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  final storage = const FlutterSecureStorage();
  final phoneController = TextEditingController();
  var loadingMsg = "";
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 104, 186),
      appBar: AppBar(
        title: const Text("Moumita Mou Boutique"),
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(top: 110.0),
                child: Column(
                  children: [
                    Container(
                      height: 180,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/logo.jpg"),
                        ),
                      ),
                    ),
                  ],
                )),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    labelText: 'Phone number',
                    hintText: 'Enter 10 digit Mobile Number'),
                controller: phoneController,
              ),
            ),
            SizedBox(
              height: 85,
              width: 330,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(200, 300, 2, 6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35.0))),
                      child: const Text(
                        'Log in',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: navigateToDashboardPage),
                ),
              ),
            ),
            SizedBox(
              height: 60,
              child: Text(
                loadingMsg,
                style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> navigateToDashboardPage() async {
    setState(() {
      loadingMsg = "Logged in successfully...";
    });
    if (phoneController.text != "") {
      final url =
          "http://moumitamouboutique.in/public/api/v1/get-login/${phoneController.text}";
      final uri = Uri.parse(url);

      final response = await http.get(uri);
      final json = jsonDecode(response.body);
      final result = json["data"];
      await storage.write(key: "userMobNo", value: result["phone"]);
      Navigator.pushNamed(context, '/dashboard');
    }
  }
}
