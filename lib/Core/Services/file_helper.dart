import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class FileHelper {
  /// Converts an asset (e.g., 'images/avatars/3D/boy3D.png') to a File
  static Future<File> assetToFile(String assetPath) async {
    // Load the image bytes from assets
    final byteData = await rootBundle.load(assetPath);

    // Create a temporary file in the app's cache directory
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/${assetPath.split('/').last}');

    // Write the bytes to the file
    await file.writeAsBytes(
      byteData.buffer.asUint8List(),
      flush: true,
    );

    return file;
  }
}
