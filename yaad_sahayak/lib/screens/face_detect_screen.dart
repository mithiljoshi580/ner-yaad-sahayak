import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../services/face_recognition_service.dart';
import '../services/voice_service.dart';
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
  State<FaceDetectScreen> createState() =>
      _FaceDetectScreenState();
}

class _FaceDetectScreenState extends State<FaceDetectScreen>
    with SingleTickerProviderStateMixin {
  CameraController? _cameraController;

  late FaceDetector _faceDetector;

  final FaceRecognitionService _faceRecognitionService =
      FaceRecognitionService();

  final VoiceService _voiceService = VoiceService();

  bool _isDetecting = false;
  bool _isProcessingVerification = false;

  bool _blinkDetected = false;
  bool _smileDetected = false;
  bool _livenessPassed = false;

  List<Face> _faces = [];

  late AnimationController _scanAnimationController;

  @override
  void initState() {
    super.initState();

    _scanAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.fast,
        enableContours: true,
        enableClassification: true,
      ),
    );

    _initializeCamera();
  }

  // ============================================================
  // CAMERA
  // ============================================================

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

      if (mounted) {
        setState(() {});
      }
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

  // ============================================================
  // FACE DETECTION
  // ============================================================

  Future<void> _processCameraImage(
    CameraImage image,
  ) async {
    if (_isDetecting) return;

    _isDetecting = true;

    try {
      final inputImage =
          _inputImageFromCameraImage(image);

      if (inputImage == null) {
        return;
      }

      final faces =
          await _faceDetector.processImage(
        inputImage,
      );

      if (!mounted) return;

      setState(() {
        _faces = faces;
      });

      if (faces.length == 1) {
        _checkLiveness(faces.first);
      } else {
        if (_livenessPassed ||
            _blinkDetected ||
            _smileDetected) {
          setState(() {
            _livenessPassed = false;
            _blinkDetected = false;
            _smileDetected = false;
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

  // ============================================================
  // INPUT IMAGE
  // ============================================================

  InputImage? _inputImageFromCameraImage(
    CameraImage image,
  ) {
    final camera =
        _cameraController?.description;

    if (camera == null) {
      return null;
    }

    final rotation =
        InputImageRotationValue.fromRawValue(
          camera.sensorOrientation,
        ) ??
        InputImageRotation.rotation0deg;

    final format =
        InputImageFormatValue.fromRawValue(
          image.format.raw,
        );

    if (format == null ||
        image.planes.isEmpty) {
      return null;
    }

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
        bytesPerRow:
            plane.bytesPerRow,
      ),
    );
  }

  // ============================================================
  // DEMO FACE EMBEDDING
  // ============================================================

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

  // ============================================================
  // LIVENESS
  // ============================================================

  void _checkLiveness(Face face) {
    final leftEye =
        face.leftEyeOpenProbability;

    final rightEye =
        face.rightEyeOpenProbability;

    final smile =
        face.smilingProbability;

    bool blink = false;

    if (leftEye != null &&
        rightEye != null) {
      blink =
          leftEye < 0.35 ||
          rightEye < 0.35;
    }

    bool smileDetected = false;

    if (smile != null) {
      smileDetected =
          smile > 0.65;
    }

    if (blink &&
        !_blinkDetected) {
      setState(() {
        _blinkDetected = true;
      });
    }

    if (smileDetected &&
        !_smileDetected) {
      setState(() {
        _smileDetected = true;
      });
    }

    if (_blinkDetected ||
        _smileDetected) {
      if (!_livenessPassed) {
        setState(() {
          _livenessPassed = true;
        });
      }
    }
  }

  // ============================================================
  // SAVE FACE
  // ============================================================

  Future<void> _saveFace() async {
    if (_faces.isEmpty) {
      _showMessage(
        'No Face Detected',
        Colors.red,
      );
      return;
    }

    if (_faces.length > 1) {
      _showMessage(
        'Please keep only one face in camera',
        Colors.orange,
      );
      return;
    }

    if (!_livenessPassed) {
      _showMessage(
        'Please blink or smile first',
        Colors.orange,
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
      await _faceRecognitionService
          .saveFace(
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

  // ============================================================
  // VERIFY / LINK FACE
  // ============================================================

  Future<void> _verifyFace() async {
    if (_isProcessingVerification) {
      return;
    }

    if (_faces.isEmpty) {
      _showMessage(
        'No Face Detected',
        Colors.red,
      );
      return;
    }

    if (_faces.length > 1) {
      _showMessage(
        'Multiple faces detected. Please keep only one face.',
        Colors.orange,
      );
      return;
    }

    if (!_livenessPassed) {
      _showMessage(
        'Please blink or smile for liveness check',
        Colors.orange,
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

    setState(() {
      _isProcessingVerification = true;
    });

    try {
      // ========================================================
      // LINK FACE WITH EXISTING FAMILY MEMBER
      // ========================================================

      if (widget.memberId != null &&
          widget.memberId!.isNotEmpty) {
        await _faceRecognitionService
            .saveFaceForFamilyMember(
          widget.memberId!,
          embedding,
        );

        if (!mounted) return;

        await _showSuccessAnimation(
          'Face Linked!',
          'Face successfully linked with family member.',
        );

        if (mounted) {
          Navigator.pop(
            context,
            true,
          );
        }

        return;
      }

      // ========================================================
      // AUTO IDENTIFY FAMILY MEMBER
      // ========================================================

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
        await _showFailureAnimation();

        if (!mounted) return;

        _showAddNewFamilyMemberDialog();
      }
    } catch (e) {
      debugPrint(
        'Face verification error: $e',
      );

      if (!mounted) return;

      await _showFailureAnimation();

      if (mounted) {
        _showMessage(
          'Face verification failed',
          Colors.red,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingVerification =
              false;
        });
      }
    }
  }

  // ============================================================
  // SUCCESS DIALOG
  // ============================================================

  Future<void> _showSuccessAnimation(
    String title,
    String message,
  ) async {
    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              const Color(0xFF242844),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(22),
          ),
          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color:
                    Colors.greenAccent,
                size: 80,
              ),
              const SizedBox(
                height: 18,
              ),
              Text(
                title,
                style:
                    const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                message,
                textAlign:
                    TextAlign.center,
                style:
                    const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(
                    0xFF6C3FC5,
                  ),
                  foregroundColor:
                      Colors.white,
                ),
                child:
                    const Text(
                  'Continue',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // FAILURE DIALOG
  // ============================================================

  Future<void> _showFailureAnimation() async {
    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              const Color(0xFF242844),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(22),
          ),
          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              const Icon(
                Icons.cancel,
                color:
                    Colors.redAccent,
                size: 75,
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Face Not Matched',
                style:
                    TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'No saved family member matched this face.',
                textAlign:
                    TextAlign.center,
                style:
                    TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
                child:
                    const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // MATCHED FAMILY MEMBER
  // ============================================================

  Future<void> _showMatchedFamilyMember(
    String memberId,
  ) async {
    try {
      final user =
          _faceRecognitionService
              .currentUser;

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
        useCache: true,
      );

      Map<String, dynamic>?
          matchedMember;

      for (final member
          in members) {
        if (member['memberId'] ==
            memberId) {
          matchedMember =
              member;
          break;
        }
      }

      if (!mounted) return;

      if (matchedMember ==
          null) {
        _showMessage(
          'Family member details unavailable',
          Colors.orange,
        );
        return;
      }

      final name =
          matchedMember['name']
              ?.toString() ??
          'Family Member';

      final relation =
          matchedMember['relation']
              ?.toString() ??
          'Family';

      final image =
          matchedMember['image']
              ?.toString() ??
          matchedMember['photo']
              ?.toString() ??
          '';

      final voiceNote =
          matchedMember['voiceNote']
              ?.toString() ??
          matchedMember[
                  'voiceNoteUrl']
              ?.toString() ??
          '';

      // ========================================================
      // AUTO PLAY VOICE NOTE
      // ========================================================

      if (voiceNote.isNotEmpty) {
        await _voiceService
            .playVoice(
          voiceNote,
        );
      }

      if (!mounted) return;

      await showModalBottomSheet(
        context: context,
        backgroundColor:
            const Color(0xFF181A2E),
        shape:
            const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),
        builder: (context) {
          return SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.all(
                24,
              ),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  Container(
                    width: 45,
                    height: 5,
                    decoration:
                        BoxDecoration(
                      color:
                          Colors.white30,
                      borderRadius:
                          BorderRadius
                              .circular(
                        10,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 22,
                  ),

                  const Icon(
                    Icons.check_circle,
                    color:
                        Colors.greenAccent,
                    size: 60,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  const Text(
                    'Face Matched!',
                    style:
                        TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  CircleAvatar(
                    radius: 50,
                    backgroundColor:
                        Colors.white12,
                    backgroundImage:
                        image.isNotEmpty
                            ? NetworkImage(
                                image,
                              )
                            : null,
                    child:
                        image.isEmpty
                            ? const Icon(
                                Icons.person,
                                color:
                                    Colors.white70,
                                size: 55,
                              )
                            : null,
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  Text(
                    name,
                    textAlign:
                        TextAlign.center,
                    style:
                        const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  Text(
                    relation,
                    style:
                        const TextStyle(
                      color: Colors.white70,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Container(
                    width:
                        double.infinity,
                    padding:
                        const EdgeInsets.all(
                      16,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xFF242844,
                      ),
                      borderRadius:
                          BorderRadius
                              .circular(
                        18,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.verified,
                          color:
                              Colors.greenAccent,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        const Expanded(
                          child: Text(
                            'Family member recognized',
                            style:
                                TextStyle(
                              color:
                                  Colors.white,
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (voiceNote
                      .isNotEmpty) ...[
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width:
                          double.infinity,
                      child:
                          ElevatedButton
                              .icon(
                        icon:
                            const Icon(
                          Icons.volume_up,
                        ),
                        label:
                            const Text(
                          'Play Voice Note',
                        ),
                        onPressed: () {
                          _voiceService
                              .playVoice(
                            voiceNote,
                          );
                        },
                      ),
                    ),
                  ],

                  const SizedBox(
                    height: 18,
                  ),

                  SizedBox(
                    width:
                        double.infinity,
                    height: 52,
                    child:
                        ElevatedButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                      },
                      style:
                          ElevatedButton
                              .styleFrom(
                        backgroundColor:
                            const Color(
                          0xFF6C3FC5,
                        ),
                        foregroundColor:
                            Colors.white,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            15,
                          ),
                        ),
                      ),
                      child:
                          const Text(
                        'Done',
                        style:
                            TextStyle(
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

  // ============================================================
  // ADD NEW FAMILY MEMBER
  // ============================================================

  void _showAddNewFamilyMemberDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              const Color(0xFF242844),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),
          title: const Text(
            'Face Not Matched',
            style: TextStyle(
              color: Colors.white,
              fontWeight:
                  FontWeight.bold,
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
                Navigator.pop(
                  context,
                );
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color:
                      Colors.white70,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                );

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
                    const Color(
                  0xFF6C3FC5,
                ),
                foregroundColor:
                    Colors.white,
              ),
              child:
                  const Text(
                'Add Member',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // STATUS
  // ============================================================

  String _getStatusMessage() {
    if (_isProcessingVerification) {
      return 'Verifying face...';
    }

    if (_faces.isEmpty) {
      return 'Look at the camera';
    }

    if (_faces.length > 1) {
      return 'Multiple faces detected';
    }

    if (!_livenessPassed) {
      return 'Please blink or smile';
    }

    return 'Face ready for verification';
  }

  // ============================================================
  // MESSAGE
  // ============================================================

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
            const Duration(
          seconds: 2,
        ),
      ),
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _scanAnimationController
        .dispose();

    _voiceService.dispose();

    _cameraController?.dispose();

    _faceDetector.close();

    super.dispose();
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    if (_cameraController ==
            null ||
        !_cameraController!
            .value
            .isInitialized) {
      return const Scaffold(
        backgroundColor:
            Color(0xFF10152F),
        body: Center(
          child:
              CircularProgressIndicator(),
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
          style:
              const TextStyle(
            color: Colors.white,
            fontWeight:
                FontWeight.bold,
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

                // =================================================
                // FACE BOX
                // =================================================

                CustomPaint(
                  painter:
                      FacePainter(
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

                // =================================================
                // SCANNING OVERLAY
                // =================================================

                Center(
                  child:
                      AnimatedBuilder(
                    animation:
                        _scanAnimationController,
                    builder:
                        (context, child) {
                      return Container(
                        width: 250,
                        height: 320,
                        decoration:
                            BoxDecoration(
                          border:
                              Border.all(
                            color: _livenessPassed
                                ? Colors
                                    .greenAccent
                                : Colors
                                    .white70,
                            width: 3,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            140,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  (_livenessPassed
                                          ? Colors
                                              .greenAccent
                                          : Colors
                                              .white)
                                      .withValues(
                                alpha:
                                    0.18,
                              ),
                              blurRadius:
                                  20,
                              spreadRadius:
                                  2,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 20 +
                                  (_scanAnimationController
                                          .value *
                                      270),
                              left: 20,
                              right: 20,
                              child:
                                  Container(
                                height: 2,
                                decoration:
                                    BoxDecoration(
                                  color: _livenessPassed
                                      ? Colors
                                          .greenAccent
                                      : Colors
                                          .cyanAccent,
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // =================================================
                // STATUS
                // =================================================

                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          Colors.black54,
                      borderRadius:
                          BorderRadius
                              .circular(
                        14,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                      children: [
                        Icon(
                          _faces.isEmpty
                              ? Icons
                                  .face_retouching_natural
                              : _faces.length >
                                      1
                                  ? Icons.groups
                                  : _livenessPassed
                                      ? Icons
                                          .verified
                                      : Icons
                                          .visibility,
                          color:
                              _faces.length >
                                      1
                                  ? Colors
                                      .orangeAccent
                                  : _livenessPassed
                                      ? Colors
                                          .greenAccent
                                      : Colors
                                          .white,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          child: Text(
                            _getStatusMessage(),
                            textAlign:
                                TextAlign
                                    .center,
                            style:
                                const TextStyle(
                              color:
                                  Colors.white,
                              fontSize:
                                  16,
                              fontWeight:
                                  FontWeight
                                      .w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // =================================================
                // LIVENESS STATUS
                // =================================================

                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding:
                        const EdgeInsets
                            .all(14),
                    decoration:
                        BoxDecoration(
                      color:
                          Colors.black54,
                      borderRadius:
                          BorderRadius
                              .circular(
                        16,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _blinkDetected
                              ? Icons
                                  .check_circle
                              : Icons
                                  .remove_circle_outline,
                          color:
                              _blinkDetected
                                  ? Colors
                                      .greenAccent
                                  : Colors
                                      .white54,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          'Blink',
                          style:
                              TextStyle(
                            color:
                                Colors.white,
                            fontSize:
                                14,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          _smileDetected
                              ? Icons
                                  .check_circle
                              : Icons
                                  .remove_circle_outline,
                          color:
                              _smileDetected
                                  ? Colors
                                      .greenAccent
                                  : Colors
                                      .white54,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          'Smile',
                          style:
                              TextStyle(
                            color:
                                Colors.white,
                            fontSize:
                                14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // =================================================
                // PROCESSING
                // =================================================

                if (_isProcessingVerification)
                  Container(
                    color:
                        Colors.black45,
                    child:
                        const Center(
                      child: Column(
                        mainAxisSize:
                            MainAxisSize
                                .min,
                        children: [
                          CircularProgressIndicator(
                            color:
                                Colors.white,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Verifying face...',
                            style:
                                TextStyle(
                              color:
                                  Colors.white,
                              fontSize:
                                  16,
                              fontWeight:
                                  FontWeight
                                      .w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ======================================================
          // BUTTONS
          // ======================================================

          Padding(
            padding:
                const EdgeInsets.all(
              16,
            ),
            child: Row(
              children: [
                if (!widget.verifyMode &&
                    widget.memberId ==
                        null) ...[
                  Expanded(
                    child:
                        ElevatedButton(
                      onPressed:
                          _isProcessingVerification
                              ? null
                              : _saveFace,
                      style:
                          ElevatedButton
                              .styleFrom(
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
                      child:
                          const Text(
                        'Save Face',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                ],

                Expanded(
                  child:
                      ElevatedButton(
                    onPressed:
                        _isProcessingVerification
                            ? null
                            : _verifyFace,
                    style:
                        ElevatedButton
                            .styleFrom(
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
                      _isProcessingVerification
                          ? 'Processing...'
                          : widget.memberId !=
                                  null
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

class FacePainter
    extends CustomPainter {
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
      ..color =
          Colors.greenAccent
      ..style =
          PaintingStyle.stroke
      ..strokeWidth = 3;

    for (final face
        in faces) {
      final rect =
          face.boundingBox;

      final scaleX =
          size.width /
              imageSize.width;

      final scaleY =
          size.height /
              imageSize.height;

      final left =
          rect.left * scaleX;

      final top =
          rect.top * scaleY;

      final right =
          rect.right * scaleX;

      final bottom =
          rect.bottom * scaleY;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(
            left,
            top,
            right,
            bottom,
          ),
          const Radius.circular(
            12,
          ),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant FacePainter
        oldDelegate,
  ) {
    return oldDelegate.faces !=
        faces;
  }
}