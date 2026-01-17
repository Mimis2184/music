
import 'package:flutter/material.dart';
import 'package:music/results_screen.dart';
import 'main.dart';


// Figma assets for camera screen prototype
const String arrowBackImg = 'https://www.figma.com/api/mcp/asset/b648d1ff-574f-43ab-8dd7-4eaffcff844e';
const String seeSuggestionsNormal = 'assets/Property 1=Default.png';
const String seeSuggestionsPressed = 'assets/Property 1=Variant2.png';

class CameraScreen extends StatefulWidget {
  final Map<String, String> themeAssets;
  final AppThemeMode themeMode;
  const CameraScreen({super.key, required this.themeAssets, required this.themeMode});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
    bool _arrowPressed = false;
  static const allowedMoods = [
    'Happy', 'Sad', 'Calm', 'Anxious', 'Romantic', 'Angry'
  ];
  String? detectedMood;
  bool isAnalyzing = true;
  bool isSeeSuggestionsPressed = false;

  @override
  void initState() {
    super.initState();
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF7),
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
                  _arrowPressed ? 'assets/Property 1=ArrowBackPressed.png' : 'assets/arrow_default.png',
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
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w800,
                  fontSize: 36,
                  color: Color(0xFF383737),
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
                style: const TextStyle(
                  fontFamily: 'Arial Rounded MT Bold',
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                  color: Color(0xFF383737),
                ),
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // Camera window (centered)
          Positioned(
            left: 61,
            top: 151,
            child: Container(
              width: 289,
              height: 310,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF7),
                border: Border.all(
                  color: const Color(0xFF383737),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isAnalyzing ? Icons.videocam : Icons.check_circle,
                      size: 64,
                      color: isAnalyzing ? const Color(0xFFD3CECE) : const Color(0xFF4CAF50),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isAnalyzing ? 'Analyzing...' : 'Ready!',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF383737),
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
          // Detected mood display
          if (detectedMood != null && !isAnalyzing && allowedMoods.contains(detectedMood))
            Positioned(
              left: 55.5,
              top: 498,
              child: Container(
                width: 300,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F2FB),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 27),
                      child: Text(
                        'Detected mood:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF383737),
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
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF615690),
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
              onTapCancel: () => setState(() => isSeeSuggestionsPressed = false),
              child: SizedBox(
                width: 289,
                height: 58,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(29),
                  child: Image.asset(
                    isSeeSuggestionsPressed ? seeSuggestionsPressed : seeSuggestionsNormal,
                    width: 289,
                    height: 58,
                    fit: BoxFit.cover,
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
