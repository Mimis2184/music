import 'package:flutter/material.dart';
import 'package:music/results_screen.dart';
import 'main.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:flutter/foundation.dart';

// Figma assets for camera screen prototype
const String arrowBackImg =
    'https://www.figma.com/api/mcp/asset/b648d1ff-574f-43ab-8dd7-4eaffcff844e';
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
  bool isAnalyzing = true;
  bool isSeeSuggestionsPressed = false;

  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  FaceDetector? _faceDetector;
  bool _faceFound = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: false,
        enableLandmarks: false,
      ),
    );
    // Simulate analyzing
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        final idx = DateTime.now().second % allowedMoods.length;
        setState(() {
          detectedMood = allowedMoods[idx];
          isAnalyzing = false;
        });
      }
    });
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController = CameraController(
        _cameras![0],
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
      // Start streaming images to face detector
      _cameraController!.startImageStream((image) {
        if (mounted) {
          _processCameraImage(image);
        }
      });
    }
  }

  void _handleBack() {
    Navigator.of(context).pop();
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

  void _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final Size imageSize = Size(
      image.width.toDouble(),
      image.height.toDouble(),
    );
    final camera = _cameras![0];
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
        InputImageRotation.rotation0deg;
    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw) ??
        InputImageFormat.nv21;
    final metadata = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation,
      format: inputImageFormat,
      bytesPerRow: image.planes[0].bytesPerRow,
    );
    final inputImage = InputImage.fromBytes(bytes: bytes, metadata: metadata);
    final faces = await _faceDetector!.processImage(inputImage);
    setState(() {
      _faceFound = faces.isNotEmpty;
    });
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
          // Back arrow button (same as voice overlay)
          Positioned(
            left: 25,
            top: 26,
            child: GestureDetector(
              onTap: _handleBack,
              onTapDown: (_) => setState(() => _arrowPressed = true),
              onTapUp: (_) => setState(() => _arrowPressed = false),
              onTapCancel: () => setState(() => _arrowPressed = false),
              child: Container(
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
          // Small 'moosik' title (top center)
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
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // Analyzing your expression text (large and readable, like prototype)
          Positioned(
            left: 34,
            top: 102,
            child: SizedBox(
              width: 343,
              height: 26,
              child: Text(
                'Analyzing your expression...',
                style: TextStyle(
                  fontFamily: 'Arial Rounded MT Bold',
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // Camera window (centered, with camera preview and face detection overlay)
          Positioned(
            left: 61,
            top: 151,
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
                child: _isCameraInitialized && _cameraController != null
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          CameraPreview(_cameraController!),
                          if (_faceFound)
                            Container(
                              color: Colors.black.withOpacity(0.2),
                              alignment: Alignment.center,
                              child: Text(
                                'Face detected!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
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
                              Icons.videocam,
                              size: 64,
                              color: Theme.of(context).disabledColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Initializing camera...',
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.color,
                                fontFamily: 'Arial Rounded MT Bold',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // See Suggestions button (same as HomeScreen)
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
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            'See Suggestions ?',
                            style: TextStyle(
                              fontFamily: 'Arial Rounded MT Bold',
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: const Color(0xFF312F2D),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}