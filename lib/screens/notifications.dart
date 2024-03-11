//create a stateless widget
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/screens/login.dart';
import 'package:http/http.dart' as http;

import 'package:url_launcher/url_launcher.dart';

// import 'package:url_launcher/url_launcher.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notifications> {
  List items = [];
  List products = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    fetchNotification();
  }

  Widget build(BuildContext context) {
    var body = Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Image.asset("assets/logo.jpg", width: 200),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () => _launchURL(
                                "https://www.facebook.com/moumitamouboutique"),
                            iconSize: 30,
                            icon: const Icon(Icons.facebook)),
                        GestureDetector(
                          onTap: () => _launchURL(
                              "https://wa.me/+917602419285/?text=Hello"),
                          child: Center(
                            child: Image.asset("assets/whatsapp_icon.png",
                                width: 33),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "+91 9477378869",
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset("assets/profile.jpeg",
                        width: MediaQuery.of(context).size.width / 2.3)),
              ],
            ),
            // text take space from top
            Center(
              child: Container(
                child: const Text(
                  "Notifications:",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(200, 300, 2, 6)),
                ),
              ),
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final itemss = items[index] as Map;
                    final message = itemss['message'] as String;
                    // final type = itemss['type'] as String;
                    return GestureDetector(
                      onTap: () {
                        _launchURL(message);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(3.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(235, 226, 226, 1),
                            border: Border.all(
                                color: const Color.fromARGB(255, 49, 0, 0)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Text(
                          textAlign: TextAlign.center,
                          message,
                          style: const TextStyle(
                              fontSize: 15.0,
                              color: Color.fromARGB(200, 300, 2, 6)),
                        ),
                      ),
                    );
                  },
                )),
          ],
        ),

        // add a sizedbox for adding a text
      ),
    );
    var bodyProgress = Container(
      child: Stack(
        children: <Widget>[
          body,
          Container(
            alignment: AlignmentDirectional.center,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(200, 300, 2, 6),
                  borderRadius: BorderRadius.circular(10.0)),
              width: 300.0,
              height: 200.0,
              alignment: AlignmentDirectional.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Center(
                    child: SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: CircularProgressIndicator(
                        value: null,
                        strokeWidth: 7.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: const Center(
                      child: Text(
                        "loading.. wait...",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Moumita Mou Boutique",
            style: TextStyle(color: Colors.white60),
          ),
          leading: const BackButton(color: Colors.white60),
          backgroundColor: const Color.fromARGB(200, 300, 2, 6),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LoginDemo();
                  }));
                },
                color: Colors.white60,
                icon: const Icon(Icons.notifications)),
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LoginDemo();
                  }));
                },
                color: Colors.white60,
                icon: const Icon(Icons.logout)),
          ],
        ),
        body: isLoading ? bodyProgress : body);
  }

  _launchURL(message) async {
    final Uri url = Uri.parse(message);
    launchUrl(url);
  }

  Future<void> fetchNotification() async {
    setState(() {
      isLoading = true;
    });
    const url = "http://moumitamouboutique.in/public/api/v1/get-messages";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final result = json['data']['messages'] as List;
      setState(() {
        items = result;
      });
      setState(() {
        isLoading = false;
      });
    }
  }
}
