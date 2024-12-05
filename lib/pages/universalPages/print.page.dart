import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class PrintPage extends StatefulWidget {
  final PrintModel print;
  const PrintPage({super.key, required this.print});

  @override
  State<PrintPage> createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: Container(
        width: 300,
        child: PdfPreview(
          build: (format) => _generatePdf(format, 'Cart'),
        ),
      ),
    );
  }

  var main = pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold);
  var label = pw.TextStyle(fontSize: 16);

  Future<Uint8List> _generatePdf(
    PdfPageFormat format,
    String title,
  ) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) => win_build(widget.print),
      ),
    );

    return pdf.save();
  }

  // windows build
  pw.Widget win_build(PrintModel print) {
    var value = NumberFormat("#,###", "en_US");
    return pw.Padding(
      padding: pw.EdgeInsets.all(2),
      child: pw.Column(
        children: [
          // header
          pw.Row(
            children: [
              // label
              pw.Container(
                width: 50,
                height: 50,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
              ),
              pw.SizedBox(width: 10),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Heritage Fitness & Wellness Centre', style: pw.TextStyle(
                      fontSize: 24, 
                      fontWeight: pw.FontWeight.bold,
                    )),

                    pw.SizedBox(height: 4),

                    pw.Text('...supporting lifestyle of fitness and sound health', style: pw.TextStyle(
                      fontSize: 11,
                      fontStyle: pw.FontStyle.italic,
                    )),
                  ],
                ),
              ),
            ],
          ),

          pw.Divider(),

          pw.SizedBox(height: 30),

          // receipt id
          pw.Row(
            children: [
              // label
              pw.Text('Receipt ID: ', style: label),
              pw.SizedBox(width: 5),
              pw.Text(print.receipt_id, style: main),
            ],
          ),

          pw.SizedBox(height: 10),

          // date
          pw.Row(
            children: [
              // label
              pw.Text('Date: ', style: label),
              pw.SizedBox(width: 5),
              pw.Text(print.date, style: main),
            ],
          ),

          pw.SizedBox(height: 25),
          // cleint id
          pw.Row(
            children: [
              // label
              pw.Text('Client ID: ', style: label),
              pw.SizedBox(width: 5),
              pw.Text(print.client_id, style: main),
            ],
          ),

          pw.SizedBox(height: 10),

          // client name
          pw.Row(
            children: [
              // label
              pw.Text('Client Name: ', style: label),
              pw.SizedBox(width: 5),
              pw.Expanded(child: pw.Text(print.client_name, style: main)),
            ],
          ),

          pw.SizedBox(height: 10),

          // subscription_plan
          pw.Row(
            children: [
              // label
              pw.Text('Subscription Plan: ', style: label),
              pw.SizedBox(width: 5),
              pw.Expanded(child: pw.Text(print.subscription_plan, style: main)),
            ],
          ),

          pw.SizedBox(height: 10),

          // subscription_type
          pw.Row(
            children: [
              // label
              pw.Text('Subscription Type: ', style: label),
              pw.SizedBox(width: 5),
              pw.Expanded(child: pw.Text(print.subscription_type, style: main)),
            ],
          ),

          pw.SizedBox(height: 10),

          // expiry date
          pw.Row(
            children: [
              // label
              pw.Text('Expiry Date: ', style: label),
              pw.SizedBox(width: 5),
              pw.Expanded(child: pw.Text(print.expiry_date, style: main)),
            ],
          ),

          pw.SizedBox(height: 10),

          // extras
          pw.Row(
            children: [
              // label
              pw.Text('Extra Activities: ', style: label),
              pw.SizedBox(width: 5),
              pw.Expanded(
                child: pw.Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children:
                      print.extras.map((e) => pw.Text(e, style: main)).toList(),
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 10),

          // amount
          pw.Row(
            children: [
              // label
              pw.Text('Total Amount: ', style: label),
              pw.SizedBox(width: 5),
              pw.Expanded(
                  child: pw.Text(value.format(print.amount), style: main)),
            ],
          ),

          pw.SizedBox(height: 10),

          // amount_in_words
          pw.Row(
            children: [
              // label
              pw.SizedBox(width: 80),
              pw.Expanded(child: pw.Text(print.amount_in_words, style: main)),
            ],
          ),

          pw.SizedBox(height: 10),

          pw.SizedBox(height: 30),
          pw.Center(child: pw.Text('Thanks for your Patronage'))
        ],
      ),
    );
  }

  //
}

class PrintModel {
  String date;
  String receipt_id;
  String client_id;
  String client_name;
  String subscription_plan;
  String subscription_type;
  List<String> extras;
  int amount;
  String amount_in_words;
  String expiry_date;

  PrintModel({
    required this.date,
    required this.receipt_id,
    required this.client_id,
    required this.client_name,
    required this.subscription_plan,
    required this.subscription_type,
    required this.extras,
    required this.amount,
    required this.amount_in_words,
    required this.expiry_date,
  });
}
