import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:agriplant/utils/qrcode.dart';
import 'package:agriplant/utils/qrpainter.dart';

/// Conditional import for web
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:agriplant/utils/qrcode.dart';
import 'package:agriplant/utils/qrpainter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class QRCodeWidget extends StatefulWidget {
  final String url;

  const QRCodeWidget({Key? key, required this.url}) : super(key: key);

  @override
  _QRCodeWidgetState createState() => _QRCodeWidgetState();
}

class _QRCodeWidgetState extends State<QRCodeWidget> {
  final GlobalKey _qrKey = GlobalKey();
  QRCode? qrCode;

  @override
  void initState() {
    super.initState();
    qrCode = QRCode(widget.url);
    qrCode!.generate();
  }

  Future<void> _downloadQRCode() async {
    try {
      RenderRepaintBoundary boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Handle download based on platform
      // For web, you can use html package to trigger download
      // For mobile, you might save to gallery or files
      // Since we're avoiding external packages, here's a simplified example for web

      // Check if running on web
      if (kIsWeb) {
        // Import 'dart:html' if on web
        // Since 'dart:html' can't be imported conditionally, you need to handle it accordingly
        // Here's a simplified example assuming web

        final blob = html.Blob([pngBytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..download = 'qrcode.png'
          ..style.display = 'none';
        html.document.body!.children.add(anchor);
        anchor.click();
        html.document.body!.children.remove(anchor);
        html.Url.revokeObjectUrl(url);
      } else {
        // For mobile platforms, you would need to implement saving to device storage
        // This typically requires platform-specific code or external packages
        // Without external packages, it's complex and beyond this example's scope
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download not implemented for this platform.')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading QR code.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (qrCode == null || qrCode!.matrix == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RepaintBoundary(
          key: _qrKey,
          child: CustomPaint(
            size: Size(
              qrCode!.matrix!.length * 10.0,
              qrCode!.matrix!.length * 10.0,
            ),
            painter: QrPainter(matrix: qrCode!.matrix!),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _downloadQRCode,
          child: Text('Download QR Code'),
        ),
      ],
    );
  }
}
