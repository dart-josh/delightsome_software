import 'dart:convert';

import 'package:delightsome_software/helpers/productStoreHelpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoadJsonPage extends StatefulWidget {
  const LoadJsonPage({super.key});

  @override
  State<LoadJsonPage> createState() => _LoadJsonPageState();
}

class _LoadJsonPageState extends State<LoadJsonPage> {
  List _items = [];

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/files/products.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["products"];
    });
  }

  String get_category(String cat) {
    switch (cat) {
      case 'tiger nut':
        return 'Tiger nut';
      case 'fruits':
        return 'Fruits';
      case 'smoothie':
        return 'Smoothies';
      case 'seed':
        return 'Seed';
      case 'whole foods':
        return 'Whole Foods';
      case 'oil':
        return 'Oil';
      case 'juice':
        return 'Juice';
      case 'supplement':
        return 'Supplement';
      case 'chocolate':
        return 'Chocolate';
      case 'yoghurt':
        return 'Yoghurt';

      default:
        return 'Unknown';
    }
  }

  Future<void> saveJson() async {
    for (var item in _items) {
      Map map = {
        // 'id': key,
        'name': item['product_name'],
        'code': item['product_code'],
        'category': get_category(item['category']),
        'quantity': item['quantity'],
        'restockLimit': item['restock_limit'],
        'storePrice': item['product_price'],
        'onlinePrice': item['online_price'],
        'isAvailable': item['isAvailable'],
        'isOnline': false,
      };

      // print(map['category']);

      bool done = await ProductStoreHelpers.add_update_product(context, map);
      print('$done: ${item['product_name']}');
      // return;
      // return done;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Load Json',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: readJson,
              child: const Text('Load Data'),
            ),

            // Display the data loaded from sample.json
            _items.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return Card(
                          key: ValueKey(_items[index]["product_name"]),
                          margin: const EdgeInsets.all(10),
                          color: Colors.amber.shade100,
                          child: ListTile(
                            leading: Text(_items[index]["quantity"].toString()),
                            title: Text(_items[index]["product_name"]),
                            subtitle:
                                Text(_items[index]["product_price"].toString()),
                          ),
                        );
                      },
                    ),
                  )
                : Container(),

            ElevatedButton(
              onPressed: saveJson,
              child: const Text('Save Data'),
            ),
          ],
        ),
      ),
    );
  }
}
