import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

/// Page that scans QR codes using the device camera.
class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

/// State for ScannerPage handling camera permission and scan results.
class _ScannerPageState extends State<ScannerPage> {
  MobileScannerController? _cameraController;
  String? scannedResult;
  bool _hasPermission = false;

  @override
  void initState() {
    // Check camera permission at startup to prepare the scanner.
    super.initState();
    _checkCameraPermission();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  /// Requests camera access and initializes the scanner when granted.
  ///
  /// Provides user feedback and a link to settings when denied.
  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.request();
    if (mounted) {
      if (status.isGranted || status.isLimited) {
        // Permission granted, initialize camera
        setState(() {
          _hasPermission = true;
          _cameraController = MobileScannerController();
        });
      } else if (status.isDenied || status.isPermanentlyDenied) {
        // Permission denied
        setState(() {
          _hasPermission = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              status.isPermanentlyDenied
                  ? "Camera permission permanently denied. Please enable it in settings"
                  : "Camera permission is required to scan QR codes",
            ),
            action: SnackBarAction(
              label: "Open Settings",
              onPressed: openAppSettings,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _hasPermission && _cameraController != null
              ? Stack(
                  children: [
                    MobileScanner(
                      controller: _cameraController!,
                      // Update the UI with the latest decoded barcode values.
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        for (final barcode in barcodes) {
                          debugPrint("Barcode found! ${barcode.rawValue}");
                          setState(() {
                            scannedResult = barcode.rawValue;
                          });
                        }
                      },
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FloatingActionButton(
                              heroTag: "torch",
                              onPressed: () => _cameraController?.toggleTorch(),
                              child: ValueListenableBuilder<MobileScannerState>(
                                valueListenable: _cameraController!,
                                builder: (context, state, child) {
                                  final torchState = state.torchState;
                                  switch (torchState) {
                                    case TorchState.off:
                                      return const Icon(
                                        Icons.flash_off,
                                        color: Colors.white,
                                      );
                                    case TorchState.on:
                                      return const Icon(
                                        Icons.flash_on,
                                        color: Colors.yellow,
                                      );
                                    case TorchState.auto:
                                      return const Icon(
                                        Icons.flash_auto,
                                        color: Colors.white70,
                                      );
                                    case TorchState.unavailable:
                                      return const Icon(
                                        Icons.flash_off,
                                        color: Colors.grey,
                                      );
                                  }
                                },
                              ),
                            ),
                            FloatingActionButton(
                              heroTag: "camera",
                              onPressed: () =>
                                  _cameraController?.switchCamera(),
                              child: const Icon(Icons.flip_camera_ios),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        size: 80,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Camera permission required',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please grant camera permission to scan QR codes',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _checkCameraPermission,
                        icon: const Icon(Icons.settings),
                        label: const Text('Grant Permission'),
                      ),
                    ],
                  ),
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Scanned Result:',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SelectableText(
                  scannedResult ?? 'Scan a QR code to see the result',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
