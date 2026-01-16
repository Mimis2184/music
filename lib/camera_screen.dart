import 'package:flutter/material.dart';
import 'package:music/results_screen.dart';
import 'main.dart';

class CameraScreen extends StatefulWidget {
  final Map<String, String> themeAssets;
  final AppThemeMode themeMode;
  const CameraScreen({super.key, required this.themeAssets, required this.themeMode});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
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
      backgroundColor: widget.themeMode == AppThemeMode.light ? const Color(0xFFFFFBF7) : const Color(0xFF312F2D),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            final baseWidth = 411.0;
            final baseHeight = 731.0;
            final scaleW = screenWidth / baseWidth;
            final scaleH = screenHeight / baseHeight;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20 * scaleW),
                child: Column(
                  children: [
                    // Header with back button and title
                    Padding(
                      padding: EdgeInsets.only(top: 20 * scaleH, bottom: 30 * scaleH),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: _handleBack,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 4 * scaleW,
                                    offset: Offset(0, 4 * scaleH),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: const Color(0xFF383737),
                                size: 24 * scaleW,
                              ),
                            ),
                          ),
                          Text(
                            'moosik',
                            style: TextStyle(
                              fontSize: 36 * scaleW,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF383737),
                              fontFamily: 'Nunito',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: 24 * scaleW),
                        ],
                      ),
                    ),

                    // Analyzing text
                    if (isAnalyzing)
                      Padding(
                        padding: EdgeInsets.only(bottom: 30 * scaleH),
                        child: Text(
                          'Analyzing your expression...',
                          style: TextStyle(
                            fontSize: 24 * scaleW,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF383737),
                            fontFamily: 'Arial Rounded MT Bold',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    // Camera window
                    Container(
                      width: 289 * scaleW,
                      height: 310 * scaleH,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBF7),
                        border: Border.all(
                          color: const Color(0xFF383737),
                          width: 2 * scaleW,
                        ),
                        borderRadius: BorderRadius.circular(16 * scaleW),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isAnalyzing ? Icons.videocam : Icons.check_circle,
                              size: 64 * scaleW,
                              color: isAnalyzing
                                  ? const Color(0xFFD3CECE)
                                  : const Color(0xFF4CAF50),
                            ),
                            SizedBox(height: 16 * scaleH),
                            Text(
                              isAnalyzing ? 'Analyzing...' : 'Ready!',
                              style: TextStyle(
                                fontSize: 18 * scaleW,
                                color: const Color(0xFF383737),
                                fontFamily: 'Arial Rounded MT Bold',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40 * scaleH),

                    // Detected mood display (Figma exact style)
                    if (detectedMood != null && !isAnalyzing && allowedMoods.contains(detectedMood))
                      Container(
                        width: 300 * scaleW,
                        height: 44 * scaleH,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F2FB),
                          borderRadius: BorderRadius.circular(8 * scaleW),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 27 * scaleW),
                              child: Text(
                                'Detected mood:',
                                style: TextStyle(
                                  fontSize: 20 * scaleW,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF383737),
                                  fontFamily: 'Arial Rounded MT Bold',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 27 * scaleW),
                              child: Text(
                                detectedMood!,
                                style: TextStyle(
                                  fontSize: 20 * scaleW,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF615690),
                                  fontFamily: 'Arial Rounded MT Bold',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 40 * scaleH),

                    // See Suggestions button
                    GestureDetector(
                      onTapDown: (_) => setState(() => isSeeSuggestionsPressed = true),
                      onTapUp: (_) {
                        setState(() => isSeeSuggestionsPressed = false);
                        _handleSeeSuggestions();
                      },
                      onTapCancel: () => setState(() => isSeeSuggestionsPressed = false),
                      child: AnimatedScale(
                        scale: isSeeSuggestionsPressed ? 1.03 : 1.0,
                        duration: const Duration(milliseconds: 120),
                        curve: Curves.easeOut,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 120),
                          width: 289 * scaleW,
                          height: 58 * scaleH,
                          decoration: BoxDecoration(
                            color: isSeeSuggestionsPressed ? const Color(0xFF3F5F78) : const Color(0xFF5B80A4),
                            borderRadius: BorderRadius.circular(29 * scaleW),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'See Suggestions!',
                            style: TextStyle(
                              color: const Color(0xFFFFFBF7),
                              fontSize: 22 * scaleW,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30 * scaleH),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
