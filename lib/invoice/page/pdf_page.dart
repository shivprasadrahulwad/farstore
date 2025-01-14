import 'dart:io';
import 'package:farstore/invoice/api/pdf_api.dart' as pdf ;
import 'package:farstore/invoice/api/pdf_invoice_api.dart' as invoice;
import 'package:farstore/invoice/api/pdf_invoice_api.dart';
import 'package:farstore/invoice/model/customer.dart';
import 'package:farstore/invoice/model/invoice.dart';
import 'package:farstore/invoice/model/supplier.dart';
import 'package:farstore/invoice/widgets/button_widget.dart';
import 'package:farstore/invoice/widgets/title_widget.dart';
import 'package:flutter/material.dart';

class PdfPage extends StatefulWidget {
  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Invoice PDF'),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const TitleWidget(
                  icon: Icons.picture_as_pdf,
                  text: 'Generate Invoice',
                ),
                const SizedBox(height: 48),
                ButtonWidget(
                  text: 'Invoice PDF',
                  onClicked: () async {
  final date = DateTime.now();
  final dueDate = date.add(const Duration(days: 7));

  final invoice = Invoice(
    supplier: const Supplier(
      name: 'Sarah Field',
      address: 'Sarah Street 9, Beijing, China',
      paymentInfo: 'https://paypal.me/sarahfieldzz',
    ),
    customer: const Customer(
      name: 'Apple Inc.',
      address: 'Apple Street, Cupertino, CA 95014',
    ),
    info: InvoiceInfo(
      date: date,
      dueDate: dueDate,
      description: 'My description...',
      number: '${DateTime.now().year}-9999',
    ),
    items: [
      InvoiceItem(
        description: 'Coffee',
        date: DateTime.now(),
        quantity: 3,
        vat: 0.19,
        unitPrice: 5.99,
      ),
      InvoiceItem(
        description: 'Water',
        date: DateTime.now(),
        quantity: 8,
        vat: 0.19,
        unitPrice: 0.99,
      ),
    ],
  );

  // Generate the PDF asynchronously and assign it
  final File pdfFile = await PdfInvoiceApi.generate(invoice); // Await here

  // Now open the generated PDF file
  await PdfApi.openFile(pdfFile);
},

                ),
              ],
            ),
          ),
        ),
      );
}