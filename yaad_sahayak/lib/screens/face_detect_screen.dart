import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../services/face_recognition_service.dart';

class FaceDetectScreen extends StatefulWidget {
  final bool verifyMode;

  const FaceDetectScreen({
    super.key,
    this.verifyMode = false,
  });

  @override
  State<FaceDetectScreen> createState() => _FaceDetectScreenState();
}

class _FaceDetectScreenState extends State<FaceDetectScreen> {
  CameraController? _cameraController;
  late FaceDetector _faceDetector;

  final FaceRecognitionService _faceRecognitionService =
      FaceRecognitionService();

  bool _isDetecting = false;
  bool _isProcessingButton = false;

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

  // ================= CAMERA INITIALIZATION =================

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        debugPrint('No camera found');
        return;
      }

      final frontCamera = cameras.firstWhere(
        (camera) =>
            camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );

      await _cameraController!.initialize();

      if (!mounted) return;

      await _cameraController!.startImageStream(
        _processCameraImage,
      );

      setState(() {});
    } catch (e) {
      debugPrint('Camera error: $e');

      if (mounted) {
        _showMessage(
          'Camera Error: $e',
          Colors.red,
        );
      }
    }
  }

  // ================= FACE DETECTION =================

  Future<void> _processCameraImage(
    CameraImage image,
  ) async {
    if (_isDetecting) return;

    _isDetecting = true;

    try {
      final inputImage =
          _inputImageFromCameraImage(image);

      if (inputImage != null) {
        final faces =
            await _faceDetector.processImage(inputImage);

        if (mounted) {
          setState(() {
            _faces = faces;
          });
        }
      }
    } catch (e) {
      debugPrint('Detection error: $e');
    } finally {
      _isDetecting = false;
    }
  }

  // ================= CONVERT CAMERA IMAGE =================

  InputImage? _inputImageFromCameraImage(
    CameraImage image,
  ) {
    final camera = _cameraController?.description;

    if (camera == null) return null;

    final rotation =
        InputImageRotationValue.fromRawValue(
              camera.sensorOrientation,
            ) ??
            InputImageRotation.rotation0deg;

    final format =
        InputImageFormatValue.fromRawValue(
      image.format.raw,
    );

    if (format == null) return null;

    if (image.planes.isEmpty) return null;

    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(
          image.width.toDouble(),
          image.height.toDouble(),
        ),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  // ================= CREATE FACE DATA =================

  List<double> _getCurrentFaceEmbedding() {
    if (_faces.isEmpty) {
      return [];
    }

    final face = _faces.first;
    final box = face.boundingBox;

    // Normalize face position and size.
    // This is still a demo embedding, not real biometric recognition.

    final cameraSize =
        _cameraController?.value.previewSize;

    if (cameraSize == null) {
      return [];
    }

    final imageWidth = cameraSize.height;
    final imageHeight = cameraSize.width;

    return [
      box.left / imageWidth,
      box.top / imageHeight,
      box.width / imageWidth,
      box.height / imageHeight,
    ];
  }

  // ================= SAVE FACE =================

  Future<void> _saveFace() async {
    if (_isProcessingButton) return;

    if (_faces.isEmpty) {
      _showMessage(
        'Please show your face clearly',
        Colors.red,
      );
      return;
    }

    setState(() {
      _isProcessingButton = true;
    });

    try {
      final embedding =
          _getCurrentFaceEmbedding();

      if (embedding.isEmpty) {
        _showMessage(
          'Unable to read face',
          Colors.red,
        );
        return;
      }

      await _faceRecognitionService
          .saveFace(embedding);

      _showMessage(
        'Face Saved Successfully!',
        Colors.green,
      );
    } catch (e) {
      _showMessage(
        'Error saving face',
        Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingButton = false;
        });
      }
    }
  }

  // ================= VERIFY FACE =================

  Future<void> _verifyFace() async {
    if (_isProcessingButton) return;

    if (_faces.isEmpty) {
      _showMessage(
        'Please show your face clearly',
        Colors.red,
      );
      return;
    }

    setState(() {
      _isProcessingButton = true;
    });

    try {
      final embedding =
          _getCurrentFaceEmbedding();

      if (embedding.isEmpty) {
        _showMessage(
          'Unable to read face',
          Colors.red,
        );
        return;
      }

      final savedFace =
          await _faceRecognitionService.getSavedFace();

      if (savedFace == null) {
        _showMessage(
          'No saved face found. Please save your face first.',
          Colors.orange,
        );
        return;
      }

      final isVerified =
          await _faceRecognitionService
              .recognizeFace(embedding);

      if (isVerified) {
        _showMessage(
          'Face Verified Successfully! ✓',
          Colors.green,
        );

        await Future.delayed(
          const Duration(seconds: 1),
        );

        if (mounted) {
          Navigator.pop(context, true);
        }
      } else {
        _showMessage(
          'Face Not Matched. Try again.',
          Colors.red,
        );
      }
    } catch (e) {
      debugPrint('Verification error: $e');

      _showMessage(
        'Verification error',
        Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingButton = false;
        });
      }
    }
  }

  // ================= MESSAGE =================

  void _showMessage(
    String message,
    Color color,
  ) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ================= DISPOSE =================

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector.close();

    super.dispose();
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.verifyMode
              ? 'Verify Face'
              : 'Face Registration',
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // CAMERA SECTION

          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(
                  _cameraController!,
                ),

                CustomPaint(
                  painter: FacePainter(
                    faces: _faces,
                    imageSize: Size(
                      _cameraController!
                          .value
                          .previewSize!
                          .height,
                      _cameraController!
                          .value
                          .previewSize!
                          .width,
                    ),
                  ),
                ),

                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding:
                        const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: Text(
                      _faces.isEmpty
                          ? 'No face detected'
                          : 'Face detected ✓',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // BUTTON SECTION

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if (!widget.verifyMode)
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: _isProcessingButton
                          ? null
                          : _saveFace,
                      icon: const Icon(
                        Icons.save,
                      ),
                      label: const Text(
                        'Save My Face',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),

                if (!widget.verifyMode)
                  const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: _isProcessingButton
                        ? null
                        : _verifyFace,
                    icon: _isProcessingButton
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.face,
                          ),
                    label: Text(
                      _isProcessingButton
                          ? 'Please wait...'
                          : 'Verify Face',
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= FACE PAINTER =================

class FacePainter extends CustomPainter {
  final List<Face> faces;
  final Size imageSize;

  FacePainter({
    required this.faces,
    required this.imageSize,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (final face in faces) {
      final rect = face.boundingBox;

      final scaleX =
          size.width / imageSize.width;

      final scaleY =
          size.height / imageSize.height;

      final left = rect.left * scaleX;
      final top = rect.top * scaleY;
      final right = rect.right * scaleX;
      final bottom = rect.bottom * scaleY;

      canvas.drawRect(
        Rect.fromLTRB(
          left,
          top,
          right,
          bottom,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant FacePainter oldDelegate,
  ) {
    return oldDelegate.faces != faces;
  }
}