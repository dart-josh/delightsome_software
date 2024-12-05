import 'package:delightsome_software/dataModels/materialStoreModels/productMaterialItem.model.dart';
import 'package:delightsome_software/dataModels/materialStoreModels/productMaterials.model.dart';
import 'package:delightsome_software/dataModels/materialStoreModels/restockProductMaterial.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/product.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/productItem.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/productionRecord.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/terminalCollectionRecord.model.dart';
import 'package:delightsome_software/dataModels/saleModels/sales.model.dart';
import 'package:delightsome_software/globalvariables.dart';
import 'package:delightsome_software/helpers/materialStoreHelpers.dart';
import 'package:delightsome_software/helpers/productStoreHelpers.dart';
import 'package:delightsome_software/helpers/saleHelpers.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/pages/record_testPage.dart';
import 'package:flutter/material.dart';

class FormTestPage extends StatefulWidget {
  const FormTestPage({super.key});

  @override
  State<FormTestPage> createState() => _FormTestPageState();
}

class _FormTestPageState extends State<FormTestPage> {
  //  ! products
  List<ProductModel> products = [];

  // ! Selected products
  List<ProductItemModel> selected_products = [];

  String shortNote = '';

  get_products() async {
    var res = await ProductStoreHelpers.get_products();
    if (res.isNotEmpty) {
      products = res;
      setState(() {});
    }
  }

  @override
  void initState() {
    get_products();
    super.initState();
  }

  String saleType = 'store';

  @override
  Widget build(BuildContext context) {
    int orderPrice = 0;
    int totalQuantity = 0;
    for (var element in selected_products) {
      orderPrice += element.product.storePrice;
      totalQuantity += element.quantity;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Form Page'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            DropdownButton(
                value: saleType,
                items: ['store', 'online']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    saleType = value!;
                  });
                }),

            SizedBox(height: 10),

            // select products
            DropdownButton(
                items: products
                    .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                    .toList(),
                onChanged: (value) {
                  var pi = ProductItemModel(product: value!, quantity: 2);
                  bool csk = selected_products
                      .where((e) => e.product.key! == value.key!)
                      .isEmpty;
                  if (csk) {
                    selected_products.add(pi);
                    setState(() {});
                  }
                }),

            SizedBox(height: 10),

            Text('Short note'),
            SizedBox(height: 1),

            // fields form
            TextField(
              controller: TextEditingController(text: shortNote),
              onChanged: (val) {
                setState(() {
                  shortNote = val;
                });
              },
            ),

            SizedBox(height: 10),

            // items
            Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.brown.shade900,
              ),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: selected_products
                    .map((e) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.blue.shade700,
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(e.product.name),
                              SizedBox(width: 3),
                              Text('=>'),
                              Text(e.quantity.toString()),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),

            SizedBox(height: 30),
            Row(children: [
              Text('Order Price: ${orderPrice}'),
              SizedBox(width: 100),
              Text('Total Quantity: ${totalQuantity}'),
            ]),
            SizedBox(height: 30),

            // submit
            ElevatedButton(
                onPressed: () async {
                  if (activeStaff == null) {
                    UniversalHelpers.showToast(
                      context: context,
                      color: Colors.red,
                      toastText: 'No active Staff',
                      icon: Icons.error,
                    );

                    return;
                  }

                  SalesModel record = SalesModel(
                      recordDate: DateTime.now(),
                      products: selected_products,
                      orderPrice: orderPrice,
                      paymentMethod: "Transfer",
                      splitPaymentMethod: [],
                      saleType: saleType);

                  Map data = record.toJson(soldBy: activeStaff!.key!);

                  // return print(data);

                  bool res = await SaleHelpers.enter_new_sale(context, data);
                  // print(res);
                },
                child: Text('Submit')),
          ],
        ),
      )),
    );
  }
}
