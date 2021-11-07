import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:trackngo/models/BoxInfo.dart';

class BoxPrint extends StatelessWidget {
  BoxInfo box;
  BoxPrint(BoxInfo bx) {
    box = bx;
  }

  final GlobalKey<State<StatefulWidget>> _printKey = GlobalKey();

  void _printScreen() {
    Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
      final doc = pw.Document();

      // Create a DataMatrix barcode
      final dm = pw.Barcode.code128(useCode128A: true);

      final svg = dm.toSvg(box.id, width: 200, height: 200);

      final image = await WidgetWraper.fromKey(
        key: _printKey,
        pixelRatio: 2.0,
      );

      doc.addPage(pw.Page(
          pageFormat: format,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Expanded(
                child: pw.Image(image),
              ),
            );
          }));

      return doc.save();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RepaintBoundary(
              key: _printKey,
              child: BarcodeWidget(
                barcode: Barcode.code128(
                    useCode128A: true), // Barcode type and settings
                data: box.id, // Content
                width: 350,
                height: 200,
                style: TextStyle(fontSize: 25),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.print),
        onPressed: _printScreen,
      ),
    );
  }
}
