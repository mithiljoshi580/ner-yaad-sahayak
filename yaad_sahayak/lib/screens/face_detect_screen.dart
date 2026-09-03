import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectScreen extends StatefulWidget {
  const FaceDetectScreen({super.key});

  @override
  State<FaceDetectScreen> createState() => _FaceDetectScreenState();
}

class _FaceDetectScreenState extends State<FaceDetectScreen> {
  CameraController? _cameraController;
  late FaceDetector _faceDetector;
  bool _isDetecting = false;
  List<Face> _faces = [];

  @override
  void initState() {
    super.initState();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.fast,
        enableContours: true,
      ),
    );
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
      );
      await _cameraController!.initialize();
      if (!mounted) return;
      await _cameraController!.startImageStream(_processCameraImage);
      setState(() {});
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isDetecting) return;
    _isDetecting = true;
    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage != null) {
        final faces = await _faceDetector.processImage(inputImage);
        if (mounted) {
          setState(() => _faces = faces);
        }
      }
    } catch (e) {
      debugPrint('Detection error: $e');
    } finally {
      _isDetecting = false;
    }
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    final camera = _cameraController?.description;
    if (camera == null) return null;

    final rotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation) ?? InputImageRotation.rotation0deg;
    final format = InputImageFormatValue.fromRawValue(image.format.raw);

    if (format == null || (Platform.isAndroid && format != InputImageFormat.nv21 && format != InputImageFormat.yuv420 && format != InputImageFormat.yuv420)) {
      return null;
    }

    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Face Detection')),
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_cameraController!),
          CustomPaint(
            painter: FacePainter(
              faces: _faces,
              imageSize: Size(
                _cameraController!.value.previewSize!.height,
                _cameraController!.value.previewSize!.width,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  final List<Face> faces;
  final Size imageSize;
  FacePainter({required this.faces, required this.imageSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (final face in faces) {
      final rect = face.boundingBox;
      final scaleX = size.width / imageSize.width;
      final scaleY = size.height / imageSize.height;

      final left = rect.left * scaleX;
      final top = rect.top * scaleY;
      final right = rect.right * scaleX;
      final bottom = rect.bottom * scaleY;

      canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), paint);
    }
  }
  @override
  bool shouldRepaint(covariant FacePainter oldDelegate) {
    return oldDelegate.faces != faces;
  }
}