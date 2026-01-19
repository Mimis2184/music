import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:music/results_screen.dart';

import 'main.dart';

// Assets for camera screen
const String seeSuggestionsNormal = 'assets/Property 1=Default.png';
const String seeSuggestionsPressed = 'assets/Property 1=Variant2.png';

class CameraScreen extends StatefulWidget {
  final Map<String, String> themeAssets;
  final AppThemeMode themeMode;

  const CameraScreen({
    super.key,
    required this.themeAssets,
    required this.themeMode,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _arrowPressed = false;

  static const allowedMoods = [
    'Happy',
    'Sad',
    'Calm',
    'Anxious',
    'Romantic',
    'Angry',
  ];

  String? detectedMood;
  bool isAnalyzing = false;
  bool isSeeSuggestionsPressed = false;

  Uint8List? _photoBytes; // captured photo bytes for preview
  String? _capturedPath; // local file path for ML Kit (Android/iOS)

  CameraController? _cameraController;
  bool _isCameraReady = false;

  FaceDetector? _faceDetector;
  bool _faceFound = false;

  @override
  void initState() {
    super.initState();

    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true, // smilingProbability
        enableContours: false,
        enableLandmarks: false,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initCamera();
    });
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final front = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        front,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await controller.initialize();

      if (!mounted) return;
      setState(() {
        _cameraController = controller;
        _isCameraReady = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isCameraReady = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera init error: $e')),
      );
    }
  }

  void _handleBack() {
    Navigator.of(context).maybePop();
  }

  Future<void> _takePhoto() async {
    try {
      final controller = _cameraController;
      if (controller == null || !_isCameraReady) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera not ready')),
        );
        return;
      }

      final XFile file = await controller.takePicture();
      final bytes = await file.readAsBytes();

      if (!mounted) return;
      setState(() {
        _photoBytes = bytes;
        _capturedPath = file.path;
        detectedMood = null;
        _faceFound = false;
        isAnalyzing = true;
      });

      await _analyzeCapturedPhoto();
    } catch (e) {
      if (!mounted) return;
      setState(() => isAnalyzing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera capture error: $e')),
      );
    }
  }

  Future<void> _analyzeCapturedPhoto() async {

    if (kIsWeb) {
      if (!mounted) return;
      setState(() {
        detectedMood = 'Calm';
        isAnalyzing = false;
        _faceFound = true;
      });
      return;
    }

    final path = _capturedPath;
    if (path == null) {
      if (!mounted) return;
      setState(() => isAnalyzing = false);
      return;
    }

    final inputImage = InputImage.fromFilePath(path);
    final faces = await _faceDetector!.processImage(inputImage);

    if (!mounted) return;

    if (faces.isEmpty) {
      setState(() {
        _faceFound = false;
        detectedMood = 'Anxious'; // fallback ��� �� ��������� �� flow
        isAnalyzing = false;
      });
      return;
    }

    final mood = _inferMoodFromFace(faces.first);

    setState(() {
      _faceFound = true;
      detectedMood = mood;
      isAnalyzing = false;
    });
  }

  String _inferMoodFromFace(Face face) {
    final s = face.smilingProbability;
    if (s == null) return 'Calm';
    if (s >= 0.75) return 'Happy';
    if (s <= 0.25) return 'Sad';
    return 'Calm';
  }

  void _handleSeeSuggestions() {
    if (detectedMood != null && allowedMoods.contains(detectedMood)) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultsScreen(
            mood: detectedMood!,
            themeAssets: widget.themeAssets,
            themeMode: widget.themeMode,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please wait for mood detection'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Small 'moosik' title
          Positioned(
            left: 145,
            top: 21,
            child: SizedBox(
              width: 122,
              height: 49,
              child: Text(
                'moosik',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w800,
                  fontSize: 36,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // Title
          Positioned(
            left: 34,
            top: 102,
            child: SizedBox(
              width: 343,
              height: 26,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Analyzing your expression...',
                    style: TextStyle(
                      fontFamily: 'Arial Rounded MT Bold',
                      fontWeight: FontWeight.w400,
                      fontSize: 24,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ),
          ),

          // Camera window (tap to capture / retake)
          Positioned(
            left: 61,
            top: 151,
            child: GestureDetector(
              onTap: _photoBytes == null ? _takePhoto : null,
              child: Container(
                width: 289,
                height: 310,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _photoBytes != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.memory(_photoBytes!, fit: BoxFit.cover),
                            if (isAnalyzing)
                              Container(
                                color: Colors.black.withOpacity(0.25),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Analyzing...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (!isAnalyzing && _faceFound)
                              Container(
                                color: Colors.black.withOpacity(0.10),
                                alignment: Alignment.topCenter,
                                padding: const EdgeInsets.only(top: 10),
                                child: const Text(
                                  'Face detected!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        )
                      : (_isCameraReady && _cameraController != null)
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                CameraPreview(_cameraController!),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.35),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: const Text(
                                        'Tap to capture',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Arial Rounded MT Bold',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    'Opening camera...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
                                      fontFamily: 'Arial Rounded MT Bold',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                ),
              ),
            ),
          ),

          // Detected mood display
          if (detectedMood != null &&
              !isAnalyzing &&
              allowedMoods.contains(detectedMood))
            Positioned(
              left: 55.5,
              top: 498,
              child: Container(
                width: 300,
                height: 44,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 27),
                      child: Text(
                        'Detected mood:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontFamily: 'Arial Rounded MT Bold',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 27),
                      child: Text(
                        detectedMood!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.primary,
                          fontFamily: 'Arial Rounded MT Bold',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // See Suggestions button
          Positioned(
            left: 61,
            top: 579,
            child: GestureDetector(
              onTapDown: (_) => setState(() => isSeeSuggestionsPressed = true),
              onTapUp: (_) {
                setState(() => isSeeSuggestionsPressed = false);
                _handleSeeSuggestions();
              },
              onTapCancel: () =>
                  setState(() => isSeeSuggestionsPressed = false),
              child: SizedBox(
                width: 289,
                height: 58,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(29),
                      child: Image.asset(
                        isSeeSuggestionsPressed
                            ? seeSuggestionsPressed
                            : seeSuggestionsNormal,
                        width: 289,
                        height: 58,
                        fit: BoxFit.cover,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF2D547A)
                            : null,
                        colorBlendMode:
                            Theme.of(context).brightness == Brightness.dark
                                ? BlendMode.srcATop
                                : null,
                      ),
                    ),
                    if (Theme.of(context).brightness == Brightness.dark)
                      const Positioned.fill(
                        child: Center(
                          child: Text(
                            'See Suggestions ?',
                            style: TextStyle(
                              fontFamily: 'Arial Rounded MT Bold',
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Color(0xFF312F2D),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Back arrow (on top)
          Positioned(
            left: 25,
            top: 0,
            child: SafeArea(
              bottom: false,
              child: GestureDetector(
                onTap: _handleBack,
                onTapDown: (_) => setState(() => _arrowPressed = true),
                onTapUp: (_) => setState(() => _arrowPressed = false),
                onTapCancel: () => setState(() => _arrowPressed = false),
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    _arrowPressed
                        ? 'assets/Property 1=ArrowBackPressed.png'
                        : 'assets/arrow_default.png',
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}