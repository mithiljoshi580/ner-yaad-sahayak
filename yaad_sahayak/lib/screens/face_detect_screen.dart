import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../services/face_recognition_service.dart';
import 'add_family_member_screen.dart';

class FaceDetectScreen extends StatefulWidget {
  final bool verifyMode;
  final String? memberId;

  const FaceDetectScreen({
    super.key,
    this.verifyMode = false,
    this.memberId,
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

  // ------------------------------------------------------------
  // CAMERA INITIALIZATION
  // ------------------------------------------------------------

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        _showMessage(
          'No camera found',
          Colors.red,
        );
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
          'Camera error',
          Colors.red,
        );
      }
    }
  }

  // ------------------------------------------------------------
  // FACE DETECTION
  // ------------------------------------------------------------

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isDetecting) return;

    _isDetecting = true;

    try {
      final inputImage =
          _inputImageFromCameraImage(image);

      if (inputImage != null) {
        final faces =
            await _faceDetector.processImage(
          inputImage,
        );

        if (mounted) {
          setState(() {
            _faces = faces;
          });
        }
      }
    } catch (e) {
      debugPrint(
        'Detection error: $e',
      );
    } finally {
      _isDetecting = false;
    }
  }

  // ------------------------------------------------------------
  // CONVERT CAMERA IMAGE
  // ------------------------------------------------------------

  InputImage? _inputImageFromCameraImage(
    CameraImage image,
  ) {
    final camera =
        _cameraController?.description;

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

  // ------------------------------------------------------------
  // DEMO FACE EMBEDDING
  // ------------------------------------------------------------

  List<double> _getCurrentFaceEmbedding() {
    if (_faces.isEmpty) {
      return [];
    }

    final face = _faces.first;
    final box = face.boundingBox;

    return [
      box.left,
      box.top,
      box.width,
      box.height,
    ];
  }

  // ------------------------------------------------------------
  // SAVE FACE - DAY 2
  // ------------------------------------------------------------

  Future<void> _saveFace() async {
    if (_faces.isEmpty) {
      _showMessage(
        'No Face Detected',
        Colors.red,
      );
      return;
    }

    final embedding =
        _getCurrentFaceEmbedding();

    try {
      await _faceRecognitionService.saveFace(
        embedding,
      );

      _showMessage(
        'Face Saved Successfully',
        Colors.green,
      );
    } catch (e) {
      debugPrint(
        'Save face error: $e',
      );

      _showMessage(
        'Unable to save face',
        Colors.red,
      );
    }
  }

  // ------------------------------------------------------------
  // VERIFY / LINK FACE - DAY 3
  // ------------------------------------------------------------

  Future<void> _verifyFace() async {
    if (_faces.isEmpty) {
      _showMessage(
        'No Face Detected',
        Colors.red,
      );
      return;
    }

    final embedding =
        _getCurrentFaceEmbedding();

    if (embedding.isEmpty) {
      _showMessage(
        'Unable to detect face',
        Colors.red,
      );
      return;
    }

    try {
      // --------------------------------------------------------
      // CASE 1:
      // VERIFY FACE FOR EXISTING FAMILY MEMBER
      // --------------------------------------------------------

      if (widget.memberId != null &&
          widget.memberId!.isNotEmpty) {
        await _faceRecognitionService
            .saveFaceForFamilyMember(
          widget.memberId!,
          embedding,
        );

        if (!mounted) return;

        _showMessage(
          'Face linked with family member',
          Colors.green,
        );

        await Future.delayed(
          const Duration(milliseconds: 800),
        );

        if (mounted) {
          Navigator.pop(context, true);
        }

        return;
      }

      // --------------------------------------------------------
      // CASE 2:
      // AUTO IDENTIFY FAMILY MEMBER
      // --------------------------------------------------------

      final matchedMemberId =
          await _faceRecognitionService
              .identifyFamilyMember(
        embedding,
      );

      if (!mounted) return;

      if (matchedMemberId != null) {
        await _showMatchedFamilyMember(
          matchedMemberId,
        );
      } else {
        _showAddNewFamilyMemberDialog();
      }
    } catch (e) {
      debugPrint(
        'Face verification error: $e',
      );

      if (!mounted) return;

      _showMessage(
        'Face verification failed',
        Colors.red,
      );
    }
  }

  // ------------------------------------------------------------
  // SHOW MATCHED FAMILY MEMBER
  // ------------------------------------------------------------

  Future<void> _showMatchedFamilyMember(
    String memberId,
  ) async {
    try {
      final user =
          _faceRecognitionService.currentUser;

      if (user == null) {
        _showMessage(
          'User not logged in',
          Colors.red,
        );
        return;
      }

      final members =
          await _faceRecognitionService
              .getAllSavedFaces(
        user.uid,
      );

      Map<String, dynamic>? matchedMember;

      for (final member in members) {
        if (member['memberId'] == memberId) {
          matchedMember = member;
          break;
        }
      }

      if (!mounted) return;

      if (matchedMember == null) {
        _showMessage(
          'Family member found but details unavailable',
          Colors.orange,
        );
        return;
      }

      final name =
          matchedMember['name']?.toString() ??
              'Family Member';

      final relation =
          matchedMember['relation']?.toString() ??
              'Family';

      final image =
          matchedMember['image']?.toString() ??
              matchedMember['photo']?.toString() ??
              '';

      final voiceNote =
          matchedMember['voiceNote']?.toString() ??
              matchedMember['voiceNoteUrl']
                  ?.toString() ??
              '';

      await showModalBottomSheet(
        context: context,
        backgroundColor:
            const Color(0xFF181A2E),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),
        builder: (context) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 22),

                  CircleAvatar(
                    radius: 50,
                    backgroundColor:
                        Colors.white12,
                    backgroundImage:
                        image.isNotEmpty
                            ? NetworkImage(image)
                            : null,
                    child: image.isEmpty
                        ? const Icon(
                            Icons.person,
                            color: Colors.white70,
                            size: 55,
                          )
                        : null,
                  ),

                  const SizedBox(height: 16),

                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    relation,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 22),

                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFF242844),
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.verified,
                          color: Colors.greenAccent,
                          size: 30,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Family member recognized',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (voiceNote.isNotEmpty) ...[
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.volume_up,
                        ),
                        label: const Text(
                          'Play Voice Note',
                        ),
                        onPressed: () {
                          // Voice playback can be connected
                          // through VoiceService here.
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(
                          0xFF6C3FC5,
                        ),
                        foregroundColor:
                            Colors.white,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            15,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      debugPrint(
        'Member details error: $e',
      );

      if (mounted) {
        _showMessage(
          'Unable to load family details',
          Colors.red,
        );
      }
    }
  }

  // ------------------------------------------------------------
  // ADD NEW FAMILY MEMBER DIALOG
  // ------------------------------------------------------------

  void _showAddNewFamilyMemberDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              const Color(0xFF242844),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),
          title: const Text(
            'Face Not Matched',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'This face is not linked with any family member.\n\n'
            'Do you want to add this person as a new family member?',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddFamilyMemberScreen(),
                  ),
                );
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF6C3FC5),
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Add Member',
              ),
            ),
          ],
        );
      },
    );
  }

  // ------------------------------------------------------------
  // MESSAGE
  // ------------------------------------------------------------

  void _showMessage(
    String message,
    Color color,
  ) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration:
            const Duration(seconds: 2),
      ),
    );
  }

  // ------------------------------------------------------------
  // DISPOSE
  // ------------------------------------------------------------

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null ||
        !_cameraController!
            .value
            .isInitialized) {
      return const Scaffold(
        backgroundColor:
            Color(0xFF10152F),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          const Color(0xFF10152F),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF10152F),
        elevation: 0,
        title: Text(
          widget.memberId != null
              ? 'Link Family Face'
              : widget.verifyMode
                  ? 'Verify Face'
                  : 'Face Detection',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
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
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          Colors.black54,
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                    ),
                    child: Text(
                      _faces.isEmpty
                          ? 'Look at the camera'
                          : '${_faces.length} face detected',
                      textAlign:
                          TextAlign.center,
                      style:
                          const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.all(16),
            child: Row(
              children: [
                if (!widget.verifyMode &&
                    widget.memberId == null) ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveFace,
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(
                          0xFF2E8B57,
                        ),
                        foregroundColor:
                            Colors.white,
                        minimumSize:
                            const Size(
                          0,
                          52,
                        ),
                      ),
                      child: const Text(
                        'Save Face',
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),
                ],

                Expanded(
                  child: ElevatedButton(
                    onPressed: _verifyFace,
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(
                        0xFF6C3FC5,
                      ),
                      foregroundColor:
                          Colors.white,
                      minimumSize:
                          const Size(
                        0,
                        52,
                      ),
                    ),
                    child: Text(
                      widget.memberId != null
                          ? 'Link Face'
                          : 'Verify Face',
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

// ============================================================
// FACE PAINTER
// ============================================================

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

      final left =
          rect.left * scaleX;

      final top =
          rect.top * scaleY;

      final right =
          rect.right * scaleX;

      final bottom =
          rect.bottom * scaleY;

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