// // import 'dart:io';
// // import 'package:farstore/constants/utils.dart';
// // import 'package:farstore/invoice/api/pdf_api.dart';
// // import 'package:farstore/invoice/model/customer.dart';
// // import 'package:farstore/invoice/model/invoice.dart';
// // import 'package:farstore/invoice/model/supplier.dart';
// // import 'package:pdf/pdf.dart';
// // import 'package:pdf/widgets.dart' as pw;
// // import 'package:pdf/widgets.dart';

// // class PdfInvoiceApi {
// //   static Future<Future<File>> generate(Invoice invoice) async {
// //     final pdf = Document();

// //     pdf.addPage(MultiPage(
// //       build: (context) => [
// //         buildHeader(invoice),
// //         SizedBox(height: 3 * PdfPageFormat.cm),
// //         buildTitle(invoice),
// //         buildInvoice(invoice),
// //         Divider(),
// //         buildTotal(invoice),
// //       ],
// //       footer: (context) => buildFooter(invoice),
// //     ));

// //     return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
// //   }

// //   static Widget buildHeader(Invoice invoice) => Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           SizedBox(height: 1 * PdfPageFormat.cm),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               buildSupplierAddress(invoice.supplier),
// //               Container(
// //                 height: 50,
// //                 width: 50,
// //                 child: BarcodeWidget(
// //                   barcode: Barcode.qrCode(),
// //                   data: invoice.info.number,
// //                 ),
// //               ),
// //             ],
// //           ),
// //           SizedBox(height: 1 * PdfPageFormat.cm),
// //           Row(
// //             crossAxisAlignment: CrossAxisAlignment.end,
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               buildCustomerAddress(invoice.customer),
// //               buildInvoiceInfo(invoice.info),
// //             ],
// //           ),
// //         ],
// //       );

// //   static Widget buildCustomerAddress(Customer customer) => Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold)),
// //           Text(customer.address),
// //         ],
// //       );

// //   static Widget buildInvoiceInfo(InvoiceInfo info) {
// //     final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
// //     final titles = <String>[
// //       'Invoice Number:',
// //       'Invoice Date:',
// //       'Payment Terms:',
// //       'Due Date:'
// //     ];
// //     final data = <String>[
// //       info.number,
// //       Utils.formatDate(info.date),
// //       paymentTerms,
// //       Utils.formatDate(info.dueDate),
// //     ];

// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: List.generate(titles.length, (index) {
// //         final title = titles[index];
// //         final value = data[index];

// //         return buildText(title: title, value: value, width: 200);
// //       }),
// //     );
// //   }

// //   static Widget buildSupplierAddress(Supplier supplier) => Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold)),
// //           SizedBox(height: 1 * PdfPageFormat.mm),
// //           Text(supplier.address),
// //         ],
// //       );

// //   static Widget buildTitle(Invoice invoice) => Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             'INVOICE',
// //             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// //           ),
// //           SizedBox(height: 0.8 * PdfPageFormat.cm),
// //           Text(invoice.info.description),
// //           SizedBox(height: 0.8 * PdfPageFormat.cm),
// //         ],
// //       );

// //   static Widget buildInvoice(Invoice invoice) {
// //     final headers = [
// //       'Description',
// //       'Date',
// //       'Quantity',
// //       'Unit Price',
// //       'VAT',
// //       'Total'
// //     ];
// //     final data = invoice.items.map((item) {
// //       final total = item.unitPrice * item.quantity * (1 + item.vat);

// //       return [
// //         item.description,
// //         Utils.formatDate(item.date),
// //         '${item.quantity}',
// //         '\$ ${item.unitPrice}',
// //         '${item.vat} %',
// //         '\$ ${total.toStringAsFixed(2)}',
// //       ];
// //     }).toList();

// //     return Table.fromTextArray(
// //       headers: headers,
// //       data: data,
// //       border: null,
// //       headerStyle: TextStyle(fontWeight: FontWeight.bold),
// //       headerDecoration: BoxDecoration(color: PdfColors.grey300),
// //       cellHeight: 30,
// //       cellAlignments: {
// //         0: Alignment.centerLeft,
// //         1: Alignment.centerRight,
// //         2: Alignment.centerRight,
// //         3: Alignment.centerRight,
// //         4: Alignment.centerRight,
// //         5: Alignment.centerRight,
// //       },
// //     );
// //   }

// //   static Widget buildTotal(Invoice invoice) {
// //     final netTotal = invoice.items
// //         .map((item) => item.unitPrice * item.quantity)
// //         .reduce((item1, item2) => item1 + item2);
// //     final vatPercent = invoice.items.first.vat;
// //     final vat = netTotal * vatPercent;
// //     final total = netTotal + vat;

// //     return Container(
// //       alignment: Alignment.centerRight,
// //       child: Row(
// //         children: [
// //           Spacer(flex: 6),
// //           Expanded(
// //             flex: 4,
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 buildText(
// //                   title: 'Net total',
// //                   value: Utils.formatPrice(netTotal),
// //                   unite: true,
// //                 ),
// //                 buildText(
// //                   title: 'Vat ${vatPercent * 100} %',
// //                   value: Utils.formatPrice(vat),
// //                   unite: true,
// //                 ),
// //                 Divider(),
// //                 buildText(
// //                   title: 'Total amount due',
// //                   titleStyle: TextStyle(
// //                     fontSize: 14,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                   value: Utils.formatPrice(total),
// //                   unite: true,
// //                 ),
// //                 SizedBox(height: 2 * PdfPageFormat.mm),
// //                 Container(height: 1, color: PdfColors.grey400),
// //                 SizedBox(height: 0.5 * PdfPageFormat.mm),
// //                 Container(height: 1, color: PdfColors.grey400),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   static Widget buildFooter(Invoice invoice) => Column(
// //         crossAxisAlignment: CrossAxisAlignment.center,
// //         children: [
// //           Divider(),
// //           SizedBox(height: 2 * PdfPageFormat.mm),
// //           buildSimpleText(title: 'Address', value: invoice.supplier.address),
// //           SizedBox(height: 1 * PdfPageFormat.mm),
// //           buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
// //         ],
// //       );

// //   static buildSimpleText({
// //     required String title,
// //     required String value,
// //   }) {
// //     final style = TextStyle(fontWeight: FontWeight.bold);

// //     return Row(
// //       mainAxisSize: MainAxisSize.min,
// //       crossAxisAlignment: pw.CrossAxisAlignment.end,
// //       children: [
// //         Text(title, style: style),
// //         SizedBox(width: 2 * PdfPageFormat.mm),
// //         Text(value),
// //       ],
// //     );
// //   }

// //   static buildText({
// //     required String title,
// //     required String value,
// //     double width = double.infinity,
// //     TextStyle? titleStyle,
// //     bool unite = false,
// //   }) {
// //     final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

// //     return Container(
// //       width: width,
// //       child: Row(
// //         children: [
// //           Expanded(child: Text(title, style: style)),
// //           Text(value, style: unite ? style : null),
// //         ],
// //       ),
// //     );
// //   }
// // }


// import 'dart:io';
// import 'package:farstore/constants/utils.dart';
// import 'package:farstore/invoice/api/pdf_api.dart';
// import 'package:farstore/invoice/model/customer.dart';
// import 'package:farstore/invoice/model/invoice.dart';
// import 'package:farstore/invoice/model/supplier.dart';
// import 'package:flutter/services.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/widgets.dart';

// class PdfInvoiceApi {
//   static Future<File> generate(Invoice invoice) async {
//     final pdf = Document();

//     // Load custom font
//     final ttf = await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
//     final font = pw.Font.ttf(ttf);

//     pdf.addPage(MultiPage(
//       build: (context) => [
//         buildHeader(invoice, font),
//         SizedBox(height: 3 * PdfPageFormat.cm),
//         buildTitle(invoice, font),
//         buildInvoice(invoice, font),
//         Divider(),
//         buildTotal(invoice, font),
//       ],
//       footer: (context) => buildFooter(invoice, font),
//     ));

//     return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
//   }

//   static Widget buildHeader(Invoice invoice, pw.Font font) => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 1 * PdfPageFormat.cm),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               buildSupplierAddress(invoice.supplier, font),
//               Container(
//                 height: 50,
//                 width: 50,
//                 child: BarcodeWidget(
//                   barcode: Barcode.qrCode(),
//                   data: invoice.info.number,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 1 * PdfPageFormat.cm),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               buildCustomerAddress(invoice.customer, font),
//               buildInvoiceInfo(invoice.info, font),
//             ],
//           ),
//         ],
//       );

//   static Widget buildCustomerAddress(Customer customer, pw.Font font) => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold, font: font)),
//           Text(customer.address, style: TextStyle(font: font)),
//         ],
//       );

//   static Widget buildInvoiceInfo(InvoiceInfo info, pw.Font font) {
//     final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
//     final titles = <String>[
//       'Invoice Number:',
//       'Invoice Date:',
//       'Payment Terms:',
//       'Due Date:'
//     ];
//     final data = <String>[
//       info.number,
//       Utils.formatDate(info.date),
//       paymentTerms,
//       Utils.formatDate(info.dueDate),
//     ];

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: List.generate(titles.length, (index) {
//         final title = titles[index];
//         final value = data[index];

//         return buildText(title: title, value: value, width: 200, font: font);
//       }),
//     );
//   }

//   static Widget buildSupplierAddress(Supplier supplier, pw.Font font) => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold, font: font)),
//           SizedBox(height: 1 * PdfPageFormat.mm),
//           Text(supplier.address, style: TextStyle(font: font)),
//         ],
//       );

//   static Widget buildTitle(Invoice invoice, pw.Font font) => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'INVOICE',
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, font: font),
//           ),
//           SizedBox(height: 0.8 * PdfPageFormat.cm),
//           Text(invoice.info.description, style: TextStyle(font: font)),
//           SizedBox(height: 0.8 * PdfPageFormat.cm),
//         ],
//       );

//   static Widget buildInvoice(Invoice invoice, pw.Font font) {
//     final headers = [
//       'Description',
//       'Date',
//       'Quantity',
//       'Unit Price',
//       'VAT',
//       'Total'
//     ];
//     final data = invoice.items.map((item) {
//       final total = item.unitPrice * item.quantity * (1 + item.vat);

//       return [
//         item.description,
//         Utils.formatDate(item.date),
//         '${item.quantity}',
//         '\$ ${item.unitPrice}',
//         '${item.vat} %',
//         '\$ ${total.toStringAsFixed(2)}',
//       ];
//     }).toList();

//     return Table.fromTextArray(
//       headers: headers,
//       data: data,
//       border: null,
//       headerStyle: TextStyle(fontWeight: FontWeight.bold, font: font),
//       headerDecoration: BoxDecoration(color: PdfColors.grey300),
//       cellHeight: 30,
//       cellAlignments: {
//         0: Alignment.centerLeft,
//         1: Alignment.centerRight,
//         2: Alignment.centerRight,
//         3: Alignment.centerRight,
//         4: Alignment.centerRight,
//         5: Alignment.centerRight,
//       },
//       cellStyle: TextStyle(font: font), // Set font for cell content
//     );
//   }

//   static Widget buildTotal(Invoice invoice, pw.Font font) {
//     final netTotal = invoice.items
//         .map((item) => item.unitPrice * item.quantity)
//         .reduce((item1, item2) => item1 + item2);
//     final vatPercent = invoice.items.first.vat;
//     final vat = netTotal * vatPercent;
//     final total = netTotal + vat;

//     return Container(
//       alignment: Alignment.centerRight,
//       child: Row(
//         children: [
//           Spacer(flex: 6),
//           Expanded(
//             flex: 4,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 buildText(
//                   title: 'Net total',
//                   value: Utils.formatPrice(netTotal),
//                   unite: true,
//                   font: font,
//                 ),
//                 buildText(
//                   title: 'Vat ${vatPercent * 100} %',
//                   value: Utils.formatPrice(vat),
//                   unite: true,
//                   font: font,
//                 ),
//                 Divider(),
//                 buildText(
//                   title: 'Total amount due',
//                   titleStyle: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     font: font,
//                   ),
//                   value: Utils.formatPrice(total),
//                   unite: true,
//                   font: font,
//                 ),
//                 SizedBox(height: 2 * PdfPageFormat.mm),
//                 Container(height: 1, color: PdfColors.grey400),
//                 SizedBox(height: 0.5 * PdfPageFormat.mm),
//                 Container(height: 1, color: PdfColors.grey400),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   static Widget buildFooter(Invoice invoice, pw.Font font) => Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Divider(),
//           SizedBox(height: 2 * PdfPageFormat.mm),
//           buildSimpleText(title: 'Address', value: invoice.supplier.address, font: font),
//           SizedBox(height: 1 * PdfPageFormat.mm),
//           buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo, font: font),
//         ],
//       );

//   static buildSimpleText({
//     required String title,
//     required String value,
//     required pw.Font font,
//   }) {
//     final style = TextStyle(fontWeight: FontWeight.bold, font: font);

//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: pw.CrossAxisAlignment.end,
//       children: [
//         Text(title, style: style),
//         SizedBox(width: 2 * PdfPageFormat.mm),
//         Text(value, style: TextStyle(font: font)), // Apply the font here as well
//       ],
//     );
//   }

//   static buildText({
//     required String title,
//     required String value,
//     double width = double.infinity,
//     TextStyle? titleStyle,
//     bool unite = false,
//     required pw.Font font,
//   }) {
//     final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold, font: font);

//     return Container(
//       width: width,
//       child: Row(
//         children: [
//           Expanded(child: Text(title, style: style)),
//           Text(value, style: unite ? style : TextStyle(font: font)), // Use the font here as well
//         ],
//       ),
//     );
//   }
// }



import 'dart:io';
import 'package:farstore/constants/utils.dart';
import 'package:farstore/invoice/api/pdf_api.dart';
import 'package:farstore/invoice/model/customer.dart';
import 'package:farstore/invoice/model/invoice.dart';
import 'package:farstore/invoice/model/supplier.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

// class PdfInvoiceApi {
//   static Future<File> generate(Invoice invoice) async {
//     final pdf = Document();

//     // Load a Unicode-compatible font (Noto Sans in this example)
//     final fontData = await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
//     final ttf = pw.Font.ttf(fontData);

//     pdf.addPage(MultiPage(
//       build: (context) => [
//         buildHeader(invoice, ttf),
//         SizedBox(height: 3 * PdfPageFormat.cm),
//         buildTitle(invoice, ttf),
//         buildInvoice(invoice, ttf),
//         Divider(),
//         buildTotal(invoice, ttf),
//       ],
//       footer: (context) => buildFooter(invoice, ttf),
//     ));

//     return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
//   }

//   static Widget buildHeader(Invoice invoice, pw.Font ttf) => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 1 * PdfPageFormat.cm),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               buildSupplierAddress(invoice.supplier, ttf),
//               Container(
//                 height: 50,
//                 width: 50,
//                 child: BarcodeWidget(
//                   barcode: Barcode.qrCode(),
//                   data: invoice.info.number,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 1 * PdfPageFormat.cm),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               buildCustomerAddress(invoice.customer, ttf),
//               buildInvoiceInfo(invoice.info, ttf),
//             ],
//           ),
//         ],
//       );

//   // Update other methods to use the custom font
//   // For example:

//   static Widget buildCustomerAddress(Customer customer, pw.Font ttf) => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(customer.name, style: TextStyle(font: ttf, fontWeight: FontWeight.bold)),
//           Text(customer.address, style: TextStyle(font: ttf)),
//         ],
//       );

//   // ... Update all other methods to use the custom font (ttf) ...

//   static Widget buildTotal(Invoice invoice, pw.Font ttf) {
//     final netTotal = invoice.items
//         .map((item) => item.unitPrice * item.quantity)
//         .reduce((item1, item2) => item1 + item2);
//     final vatPercent = invoice.items.first.vat;
//     final vat = netTotal * vatPercent;
//     final total = netTotal + vat;

//     return Container(
//       alignment: Alignment.centerRight,
//       child: Row(
//         children: [
//           Spacer(flex: 6),
//           Expanded(
//             flex: 4,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 buildText(
//                   title: 'Net total',
//                   value: Utils.formatPrice(netTotal),
//                   unite: true,
//                   ttf: ttf,
//                 ),
//                 buildText(
//                   title: 'Vat ${vatPercent * 100} %',
//                   value: Utils.formatPrice(vat),
//                   unite: true,
//                   ttf: ttf,
//                 ),
//                 Divider(),
//                 buildText(
//                   title: 'Total amount due',
//                   titleStyle: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     font: ttf,
//                   ),
//                   value: Utils.formatPrice(total),
//                   unite: true,
//                   ttf: ttf,
//                 ),
//                 SizedBox(height: 2 * PdfPageFormat.mm),
//                 Container(height: 1, color: PdfColors.grey400),
//                 SizedBox(height: 0.5 * PdfPageFormat.mm),
//                 Container(height: 1, color: PdfColors.grey400),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   static buildText({
//     required String title,
//     required String value,
//     double width = double.infinity,
//     TextStyle? titleStyle,
//     bool unite = false,
//     required pw.Font ttf,
//   }) {
//     final style = titleStyle ?? TextStyle(font: ttf, fontWeight: FontWeight.bold);

//     return Container(
//       width: width,
//       child: Row(
//         children: [
//           Expanded(child: Text(title, style: style)),
//           Text(value, style: unite ? style : TextStyle(font: ttf)),
//         ],
//       ),
//     );
//   }
// }



import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class PdfInvoiceApi {
  static late pw.Font regularFont;
  static late pw.Font boldFont;
  static late pw.Font italicFont;
  static late pw.Font boldItalicFont;
  static late pw.ThemeData myTheme;

  static Future<void> init() async {
    regularFont = pw.Font.ttf(await rootBundle.load('assets/fonts/OpenSans-Regular.ttf'));
    boldFont = pw.Font.ttf(await rootBundle.load('assets/fonts/OpenSans-Bold.ttf'));
    italicFont = pw.Font.ttf(await rootBundle.load('assets/fonts/OpenSans-Italic.ttf'));
    boldItalicFont = pw.Font.ttf(await rootBundle.load('assets/fonts/OpenSans-BoldItalic.ttf'));

    myTheme = pw.ThemeData.withFont(
      base: regularFont,
      bold: boldFont,
      italic: italicFont,
      boldItalic: boldItalicFont,
    );
  }

  static Future<File> generate(Invoice invoice) async {
    await init();  // Initialize fonts before generating the PDF

    final pdf = pw.Document(theme: myTheme);

    pdf.addPage(pw.MultiPage(
      build: (context) => [
        buildHeader(invoice),
        pw.SizedBox(height: 3 * PdfPageFormat.cm),
        // buildTitle(invoice),
        buildInvoice(invoice),
        pw.Divider(),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static pw.Widget buildHeader(Invoice invoice) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(height: 1 * PdfPageFormat.cm),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(invoice.supplier),
              pw.Container(
                height: 50,
                width: 50,
                child: pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: invoice.info.number,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 1 * PdfPageFormat.cm),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice.customer),
              buildInvoiceInfo(invoice.info),
            ],
          ),
        ],
      );

  static pw.Widget buildCustomerAddress(Customer customer) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(customer.name, style: pw.TextStyle(font: boldFont, fontWeight: pw.FontWeight.bold)),
      pw.Text(customer.address, style: pw.TextStyle(font: regularFont)),
    ],
  );

  static pw.Widget buildSupplierAddress(Supplier supplier) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(supplier.name, style: pw.TextStyle(font: boldFont, fontWeight: pw.FontWeight.bold)),
      pw.Text(supplier.address, style: pw.TextStyle(font: regularFont)),
    ],
  );

  static pw.Widget buildInvoice(Invoice invoice) {
    final headers = [
      'Description',
      'Date',
      'Quantity',
      'Unit Price',
      'VAT',
      'Total'
    ];
    final data = invoice.items.map((item) {
      final total = item.unitPrice * item.quantity * (1 + item.vat);
      return [
        item.description,
        Utils.formatDate(item.date),
        '${item.quantity}',
        '\$ ${item.unitPrice}',
        '${item.vat}',
        '\$ ${total.toStringAsFixed(2)}',
      ];
    }).toList();

    return pw.Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: pw.TextStyle(font: boldFont, fontWeight: pw.FontWeight.bold),
      cellStyle: pw.TextStyle(font: regularFont),
      headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerRight,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
      },
    );
  }
  static pw.Widget buildTotal(Invoice invoice) {
    final netTotal = invoice.items
        .map((item) => item.unitPrice * item.quantity)
        .reduce((item1, item2) => item1 + item2);
    final vatPercent = invoice.items.first.vat;
    final vat = netTotal * vatPercent;
    final total = netTotal + vat;

    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Row(
        children: [
          pw.Spacer(flex: 6),
          pw.Expanded(
            flex: 4,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Net total',
                  value: Utils.formatPrice(netTotal),
                  unite: true,
                ),
                buildText(
                  title: 'VAT ${vatPercent * 100} %',
                  value: Utils.formatPrice(vat),
                  unite: true,
                ),
                pw.Divider(),
                buildText(
                  title: 'Total amount due',
                  titleStyle: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  value: Utils.formatPrice(total),
                  unite: true,
                ),
                pw.SizedBox(height: 2 * PdfPageFormat.mm),
                pw.Container(height: 1, color: PdfColors.grey400),
                pw.SizedBox(height: 0.5 * PdfPageFormat.mm),
                pw.Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    pw.TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? pw.TextStyle(fontWeight: pw.FontWeight.bold);

    return pw.Container(
      width: width,
      child: pw.Row(
        children: [
          pw.Expanded(child: pw.Text(title, style: style)),
          pw.Text(value, style: unite ? style : null),
        ],
      ),
    );
  }

  static pw.Widget buildFooter(Invoice invoice) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Divider(),
          pw.SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: 'Address', value: invoice.supplier.address),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = pw.TextStyle(fontWeight: pw.FontWeight.bold);

    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Text(title, style: style),
        pw.SizedBox(width: 2 * PdfPageFormat.mm),
        pw.Text(value),
      ],
    );
  }

  static pw.Widget buildInvoiceInfo(InvoiceInfo info) {
    final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
      'Payment Terms:',
      'Due Date:'
    ];
    final data = <String>[
      info.number,
      Utils.formatDate(info.date),
      paymentTerms,
      Utils.formatDate(info.dueDate),
    ];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(
          title: title,
          value: value,
          width: 200,
        );
      }),
    );
  }
}

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required pw.Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future<void> openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}
