import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/screens/login.dart';
import 'package:flutter_application/screens/notifications.dart';
import 'package:http/http.dart' as http;

import 'package:url_launcher/url_launcher.dart';

// import 'package:url_launcher/url_launcher.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List items = [];
  List products = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    fetchNotification();
    getAllProducts();
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
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 140,
                  child: const Text(
                    "ADDRESS : 27, 28 SD MARKET NETAJI SUBHASH,233/A/7 ROAD, KASUNDIA, PS-SHIBPUR, PIN-711101",
                    style: TextStyle(
                        fontSize: 12.0, color: Color.fromARGB(255, 49, 0, 0)),
                    textAlign: TextAlign.center,
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(200, 300, 2, 6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35.0))),
                    child: const Text(
                      'Enquiry',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    onPressed: () => {})
              ],
            ),
            SizedBox(
                height: 80,
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

            SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      //mainAxisExtent: 160,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height),
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        elevation: 5,
                        margin: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Image.network(
                              products[index]['image'],
                              height: 300,
                              // width: 200,
                              fit: BoxFit.fill,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Price - Rs.${products[index]['price']}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Color.fromARGB(255, 2, 107, 5),
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Original Price - Rs.${products[index]['original_price']}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 13.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                )
                              ],
                            )
                            // ListTile(
                            //   subtitle: Text(products[index]["price"]),
                            // ),
                          ],
                        ),
                      );
                    })),
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
                    return const Notifications();
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
        body: isLoading ? bodyProgress : body,
        floatingActionButton: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: () =>
                _launchURL("https://wa.me/+917602419285/?text=Hello"),
            child: Image.asset("assets/whatsapp_icon.png", width: 45),
            backgroundColor: Colors.green,
          ),
        ));
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

  Future<void> getAllProducts() async {
    setState(() {
      isLoading = true;
    });
    const url = "http://moumitamouboutique.in/public/api/v1/catelouge/Sarees";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final result = json['data']['catelouge'] as List;
      setState(() {
        products = result;
      });
      setState(() {
        isLoading = false;
      });
    }
  }
}
