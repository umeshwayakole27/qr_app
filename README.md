# QR App

A Flutter application for generating and scanning QR codes with a modern, user-friendly interface.

## Overview

QR App is a cross-platform mobile application built with Flutter that provides two essential QR code functionalities: generating custom QR codes from text and scanning existing QR codes using your device's camera. The app features Material Design 3 styling with automatic light/dark theme support.

## Getting Started

### Prerequisites
- Flutter SDK 3.9.2 or higher
- Dart SDK
- Android Studio or Xcode for mobile development
- A physical device or emulator with camera support (for scanning features)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd qr_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Permissions

The app requires the following permissions:

**Android (android/app/src/main/AndroidManifest.xml):**
- `CAMERA` - For scanning QR codes
- `WRITE_EXTERNAL_STORAGE` / `READ_MEDIA_IMAGES` - For saving QR codes to gallery

**iOS (ios/Runner/Info.plist):**
- `NSCameraUsageDescription` - For scanning QR codes
- `NSPhotoLibraryAddUsageDescription` - For saving QR codes to gallery

## Features

See [features.md](features.md) for a detailed list of all application features.

## Dependencies

- **qr_flutter** (^4.1.0) - QR code generation
- **mobile_scanner** (^7.1.2) - QR code scanning
- **screenshot** (^3.0.0) - Capturing widgets as images
- **gal** (^2.3.2) - Saving images to device gallery
- **permission_handler** (^12.0.1) - Managing runtime permissions

## Project Structure

```
lib/
├── main.dart              # App entry point and configuration
└── pages/
    ├── home_page.dart     # Main navigation container
    ├── generator_page.dart # QR code generation interface
    └── scanner_page.dart   # QR code scanning interface
```

## Usage

### Generating QR Codes
1. Navigate to the "Generate" tab
2. Enter your desired text in the input field
3. Preview the generated QR code in real-time
4. Tap "Save QR code to Gallery" to save it to your device

### Scanning QR Codes
1. Navigate to the "Scan" tab
2. Grant camera permission if prompted
3. Point your camera at a QR code
4. The decoded result will appear at the bottom of the screen
5. Use the torch button for low-light conditions
6. Use the camera switch button to change cameras

## Building for Release

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## License

This project is open source and available under the MIT License.
