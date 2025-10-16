import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';

/// Page that generates a QR code from text input and allows saving it.
class GeneratorPage extends StatefulWidget {
  const GeneratorPage({super.key});

  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

/// State for GeneratorPage managing input, preview, and save workflow.
class _GeneratorPageState extends State<GeneratorPage> {
  String qrData = "Hello World!";
  final TextEditingController _textEditingController = TextEditingController();
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isSaving = false;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  /// Captures the rendered QR code and saves it to the gallery.
  ///
  /// Requests the necessary permission, shows user feedback via SnackBars,
  /// and toggles a saving indicator while work is in progress.
  Future<void> _saveQRCode() async {
    if (qrData.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter some text to generate a QR code"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Request storage permission
      final status = await Permission.photos.request();

      if (status.isDenied) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "Storage permission is required to save QR code",
            ),
            action: SnackBarAction(
              label: "Settings",
              onPressed: () => openAppSettings(),
            ),
          ),
        );
        setState(() {
          _isSaving = false;
        });
        return;
      }

      // Capture the QR code as an image
      final Uint8List? imageBytes = await _screenshotController.capture();

      if (imageBytes == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to capture QR code"),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isSaving = false;
        });
        return;
      }

      // Save to gallery using gal
      await Gal.putImageBytes(imageBytes, album: "QR Codes");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("QR code saved to gallery successfully!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              labelText: "Enter Data for QR code",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: Icon(Icons.text_fields),
            ),
            onChanged: (text) {
              setState(() {
                qrData = text;
              });
            },
          ),
          SizedBox(height: 20),
          Expanded(
            child: Center(
              child: qrData.isEmpty
                  ? Text("Enter some text to generate a QR code")
                  : Screenshot(
                      controller: _screenshotController,
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(20),
                        child: QrImageView(
                          data: qrData,
                          version: QrVersions.auto,
                          size: 200.0,
                          gapless: true,
                          dataModuleStyle: QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.circle,
                            color: Colors.black,
                          ),
                          eyeStyle: QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _isSaving ? null : _saveQRCode,
            icon: _isSaving
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(Icons.save),
            label: Text(_isSaving ? "Saving..." : "Save QR code to Gallery"),
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
