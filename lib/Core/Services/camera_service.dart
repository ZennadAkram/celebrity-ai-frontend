import 'package:camera/camera.dart';

class CameraService {
  static List<CameraDescription>? cameras;

  static Future<void> initCameras() async {
    cameras = await availableCameras();
  }
}
