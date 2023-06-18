import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> productDetails = {};
  getRequest() async {
    String url =
        "http://3.111.164.112:9000/product/product-search?url_key=makeup&productSorting=&page_size=10&page_no=1&searchByKeyword=&searchByWidgetProduct=";
    final response = await http.get(Uri.parse(url));
    productDetails = json.decode(response.body);
    print(productDetails);
  }

  @override
  void initState() {
    getRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 1.8 / 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: productDetails.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: SizedBox(
                                height: 60,
                                width: 60,
                                child: Image.network(
                                  productDetails["products"][index]["image"],
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Image.asset(
                                        "assets/images/person_icon.png");
                                  },
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                            child:
                                Text(productDetails["products"][index]["name"]),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Mrp: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(
                                productDetails["products"][index]["mrp"]
                                    .toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Sale Price: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(
                                productDetails["products"][index]["sale_price"]
                                    .toString(),
                                style: const TextStyle(color: Colors.brown),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Rating: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(productDetails["products"][index]["rating"]
                                  .toString()),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Discount %: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(productDetails["products"][index]
                                      ["discount_percentage"]
                                  .toString()),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            Container(height: 50),
          ],
        ),
      ),
    );
  }
}
