import 'package:delightsome_software/dataModels/saleModels/dailysales.model.dart';
import 'package:delightsome_software/dataModels/saleModels/sales.model.dart';
import 'package:delightsome_software/helpers/saleHelpers.dart';
import 'package:flutter/material.dart';

class RecordTestPage extends StatefulWidget {
  const RecordTestPage({super.key});

  @override
  State<RecordTestPage> createState() => _RecordTestPageState();
}

class _RecordTestPageState extends State<RecordTestPage> {
  List<SalesModel> record = [];
  bool isLoading = true;
  get_record() async {
    var res = await SaleHelpers.get_sales_record();
    isLoading = false;
    if (res.isNotEmpty) {
      record = res;
    }
    setState(() {});
  }

  @override
  void initState() {
    get_record();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    record.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    return Scaffold(
      appBar: AppBar(
        title: Text('Record Page'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : record.isEmpty
                ? Center(
                    child: Text('No record!!'),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: record.map((e) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.grey.shade800,
                        ),
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // date
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Text('Date'),
                                  SizedBox(width: 10),
                                  Text(
                                      e.recordDate!.toLocal().toIso8601String()),
                                  Expanded(child: Container()),
                                  Text('Order ID:  ${e.orderId}'),
                                ],
                              ),
                            ),

                            Text('Created At'),
                            SizedBox(width: 10),
                            Text(e.createdAt!.toLocal().toIso8601String()),

                            // Key
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Text('Key'),
                                  SizedBox(width: 10),
                                  Text(e.key!),
                                ],
                              ),
                            ),

                            // sold by
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Text('Sold By'),
                                  SizedBox(width: 10),
                                  Text(e.soldBy!.nickName),
                                ],
                              ),
                            ),

                            // short note
                            if (e.shortNote != null)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Text('Note'),
                                    SizedBox(width: 10),
                                    Text(e.shortNote!),
                                  ],
                                ),
                              ),

                            // items
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 4),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.brown.shade900,
                              ),
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: e.products
                                    .map((e) => Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: Colors.blue.shade700,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
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
                            SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Price: ${e.orderPrice}'),
                                Text('Quantity: ${e.totalQuantity}'),
                              ],
                            ),

                            SizedBox(height: 10),

                            Text('Sales Type : ${e.saleType}'),

                            // edited, = verified, verified date
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Text('Payment Method:  ${e.paymentMethod}'),
                                  Expanded(child: Container()),
                                  if (e.splitPaymentMethod!.isNotEmpty)
                                    Row(
                                      children: e.splitPaymentMethod!.map((pmt) {
                                        return Column(
                                          children: [
                                            // Text(pmt.paymentMethod),
                                            Text(pmt.amount.toString()),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                ],
                              ),
                            ),

                            SizedBox(height: 10),

                            // edited by
                            if (e.customer != null)
                              Row(
                                children: [
                                  Text('Customer: ${e.customer?.fullname}'),
                                ],
                              ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        await SaleHelpers.delete_sale_record(
                                            context, e.key!);
                                      },
                                      icon: Icon(Icons.delete)),
                                ],
                              ),
                            ),

                            //
                          ],
                        ),
                      );
                    }).toList(),
                  ),
      )),
    );
  }
}

class Test2Page extends StatefulWidget {
  const Test2Page({super.key});

  @override
  State<Test2Page> createState() => _Test2PageState();
}

class _Test2PageState extends State<Test2Page> {
  List<DailySalesModel> record = [];
  bool isLoading = true;

  get_record() async {
    var res = await SaleHelpers.get_daily_sales_record();
    isLoading = false;
    if (res.isNotEmpty) {
      record = res;
    }
    setState(() {});
  }

  DailySalesModel? active_rec;

  @override
  void initState() {
    get_record();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    record.sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(
        title: Text('Record Page'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : record.isEmpty
                ? Center(
                    child: Text('No record!!'),
                  )
                : Column(
                    children: [
                      Container(
                        height: 100,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: record.length,
                            itemBuilder: (context, index) {
                              DailySalesModel rec = record[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      active_rec = rec;
                                      setState(() {});
                                    },
                                    child: Text(rec.date)),
                              );
                            }),
                      ),
                      SizedBox(height: 40),
                      active_rec == null
                          ? Center(
                              child: Text('No record selected'),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: active_rec!.products.map((e) {
                                int amountSold =
                                    e.product.storePrice * e.quantitySold;
                                int balance = (e.openingQuantity +
                                        e.added +
                                        e.terminalReturn) -
                                    (e.request +
                                        e.terminalCollected +
                                        e.badProduct +
                                        e.online +
                                        e.quantitySold);
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.grey.shade800,
                                  ),
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text('Product'),
                                              Text(e.product.name.toString())
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text('Opening'),
                                              Text(e.openingQuantity.toString())
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text('added'),
                                              Text(e.added.toString())
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text('request'),
                                              Text(e.request.toString())
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text('terminalCollected'),
                                              Text(e.terminalCollected
                                                  .toString())
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text('terminalReturn'),
                                              Text(e.terminalReturn.toString())
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text('badProduct'),
                                              Text(e.badProduct.toString())
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text('online'),
                                              Text(e.online.toString())
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text('quantitySold'),
                                              Text(e.quantitySold.toString())
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text('Amount'),
                                              Text(amountSold.toString())
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text('Balance'),
                                              Text(balance.toString())
                                            ],
                                          ),
                                        ),
                                      ]),
                                );
                              }).toList(),
                            ),
                    ],
                  ),
      )),
    );
  }
}
