import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:music/results_screen.dart';
import 'main.dart';

import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

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
  bool isAnalyzing = false;
  bool isSeeSuggestionsPressed = false;

  final ImagePicker _picker = ImagePicker();

  Uint8List? _photoBytes; // για εμφάνιση (δουλεύει και σε web)
  String? _photoPath; // για ML Kit (Android/iOS)
  FaceDetector? _faceDetector;
  bool _faceFound = false;

  @override
  void initState() {
    super.initState();

    // Enable classification ώστε να έχουμε smilingProbability
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        enableContours: false,
        enableLandmarks: false,
      ),
    );

    // Ανοίγει native camera μόλις μπει στο screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _takePhoto();
    });
  }

  void _handleBack() {
    Navigator.of(context).pop();
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 95,
      );

      // Αν ακυρώσει ο χρήστης, απλά μένουμε στο screen (ή αν θες μπορείς να κάνεις pop)
      if (file == null) return;

      final bytes = await file.readAsBytes();

      if (!mounted) return;
      setState(() {
        _photoBytes = bytes;
        _photoPath = file.path;
        detectedMood = null;
        _faceFound = false;
        isAnalyzing = true;
      });

      await _analyzePickedPhoto();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera error: $e')),
      );
    }
  }

  Future<void> _analyzePickedPhoto() async {
    // ML Kit face detection δεν δουλεύει πραγματικά στο web με fromFilePath.
    if (kIsWeb) {
      if (!mounted) return;
      setState(() {
        detectedMood = 'Calm';
        isAnalyzing = false;
        _faceFound = true;
      });
      return;
    }

    final path = _photoPath;
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
        // Αν δεν βρει πρόσωπο, δίνουμε ένα mood που υπάρχει στη λίστα ώστε να συνεχίσει το flow
        detectedMood = 'Anxious';
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

    // Απλός κανόνας (ρεαλιστικά το ML Kit face_detection δεν “βγάζει” Angry/Romantic κλπ)
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
    _faceDetector?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Back arrow
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
                textAlign: TextAlign.left,
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

          // Camera window -> τώρα δείχνει τη ΦΩΤΟ (tap για retake)
          Positioned(
            left: 61,
            top: 151,
            child: GestureDetector(
              onTap: _takePhoto, // retake με tap στο πλαίσιο
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
                            Image.memory(
                              _photoBytes!,
                              fit: BoxFit.cover,
                            ),
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
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.photo_camera,
                                size: 64,
                                color: Theme.of(context).disabledColor,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Tap to take a photo',
                                style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      Theme.of(context).textTheme.bodyLarge?.color,
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
        ],
      ),
    );
  }
}
