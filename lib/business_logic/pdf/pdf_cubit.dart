import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:mafroshat_tech/data/models/category.dart';
import 'package:mafroshat_tech/data/models/order.dart';
import 'package:mafroshat_tech/data/models/order_item.dart';
import 'package:mafroshat_tech/data/models/product.dart';
import 'package:meta/meta.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
part 'pdf_state.dart';

class PdfCubit extends Cubit<PdfState> {
  PdfCubit() : super(PdfInitial());
  static getPdf({Order? order}) async {
    var memoryImage = MemoryImage(
      (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List(),
    );
    var temp = order ??
        Order(
            orderId: 1,
            dateTime: DateTime.now(),
            discount: 200,
            clinentName: 'معاذ سلامه سعودي',
            sellerId: 1,
            orderItems: List.generate(
                4,
                (index) => OrderItem(
                    product: Product(
                        code: 1,
                        title: '$index منتج',
                        payementPrice: 50 * (index + 1),
                        sellPrices: 50 * (index + 1),
                        amount: 100,
                        category: Category(id: 1, title: 'مفروشات')),
                    quantity: index)));
    final font = await PdfGoogleFonts.nunitoBold();
    final pdf = Document();
    final Uint8List fontData =
        File('assets/fonts/cario/Cairo-Medium.ttf').readAsBytesSync();
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());
    Text Function(String, [double?]) function =
        (String text, [double? fontSize]) => Text(text,
            style: TextStyle(font: ttf, fontSize: fontSize),
            textDirection: TextDirection.rtl);
    pdf.addPage(Page(
        margin: EdgeInsets.all(3),
        pageFormat: PdfPageFormat(PdfPageFormat.mm * 70, double.infinity),
        textDirection: TextDirection.rtl,
        build: (Context context) {
          return Center(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Row(children: [
                function("رقم الفاتورة:  ${temp.orderId}"),
                Column(children: [
                  Image(memoryImage,
                      fit: BoxFit.contain, height: 100, width: 100),
                  Text('مفروشات تك',
                      style: TextStyle(font: ttf),
                      textDirection: TextDirection.rtl)
                ]),
              ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
              Center(
                child: function("الفاتورة"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  function("اسم العميل", 10),
                  function(temp.clinentName, 10),
                ].reversed.toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  function("التاريخ", 10),
                  function(
                      DateFormat.yMMMEd()
                          .add_jms()
                          .format(temp.dateTime)
                          .toString(),
                      10),
                ].reversed.toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  function("كود البائع", 10),
                  function(temp.sellerId.toString(), 10),
                ].reversed.toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  function("اسم المنتج", 10),
                  function("العدد", 10),
                  function("السعر", 10),
                  function("الاجمالي", 10),
                ].reversed.toList(),
              ),
              Divider(),
              ...temp.orderItems
                  .map((e) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              flex: 3, child: function(e.product.title, 10)),
                          Expanded(
                              flex: 1,
                              child: function(e.quantity.toString(), 10)),
                          Expanded(
                              flex: 1,
                              child: function(
                                  e.product.sellPrices.toString(), 10)),
                          Expanded(
                              flex: 1,
                              child: function(
                                  (e.quantity * e.product.sellPrices)
                                      .toString(),
                                  10)),
                        ].reversed.toList(),
                      ))
                  .toList(),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  function("المجموع", 10),
                  function("${temp.getTotoal().toString()}" + " جنية", 10),
                ].reversed.toList(),
              ),
              if (temp.discount != 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    function("الخصم", 10),
                    function(temp.discount.toString(), 10),
                  ].reversed.toList(),
                ),
              if (temp.discount != 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    function("الاجمالي بعد الخصم ", 10),
                    function((temp.getTotoal() - temp.discount).toString(), 10),
                  ].reversed.toList(),
                ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  function("العنوان ", 6),
                  function("طلعت جامعة القاهره بجوار مستودع الانابيب", 6),
                ].reversed.toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  function("صفحة الفيسبوك", 6),
                  Text('www.facebook.com/tech.furniture.store',
                      style: TextStyle(fontSize: 6)),
                ].reversed.toList(),
              ),
            ]),
          ); // Center
        })); // Page
    final file = File("example.pdf");
    var file2 = await file.writeAsBytes(await pdf.save());
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
