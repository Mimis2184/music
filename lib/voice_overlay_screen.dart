import 'package:flutter/material.dart';
import 'package:music/results_screen.dart';
import 'package:music/voice_overlay_edit_screen.dart';
import 'main.dart';

class VoiceOverlayScreen extends StatefulWidget {
  final Map<String, String> themeAssets;
  final AppThemeMode themeMode;
  const VoiceOverlayScreen({super.key, required this.themeAssets, required this.themeMode});

  @override
  State<VoiceOverlayScreen> createState() => _VoiceOverlayScreenState();
}

class _VoiceOverlayScreenState extends State<VoiceOverlayScreen> {
  bool isRecording = false;
  String? detectedMood;
  String transcribedText = '';
  bool isSeeSuggestionsPressed = false;
  bool isMicPressed = false;
  bool isEditPressed = false;
  bool isBackPressed = false;

  void _handleBack() {
    Navigator.of(context).pop();
  }

  static const allowedMoods = [
    'Happy', 'Sad', 'Calm', 'Anxious', 'Romantic', 'Angry'
  ];

  void _toggleRecording() {
    setState(() {
      isRecording = !isRecording;
      if (isRecording) {
        // TODO: Start voice recording
        // TODO: Detect mood from voice
        // Simulate detected mood (for demo, cycle through allowed moods)
        final idx = DateTime.now().second % allowedMoods.length;
        detectedMood = allowedMoods[idx];
        transcribedText = 'This is a placeholder for transcribed text...';
      } else {
        // TODO: Stop voice recording
      }
    });
  }

  void _handleEdit() async {
    final editedText = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => VoiceOverlayEditScreen(
          initialText: transcribedText,
          themeAssets: widget.themeAssets,
          themeMode: widget.themeMode,
        ),
      ),
    );
    if (editedText != null) {
      setState(() {
        transcribedText = editedText;
      });
    }
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
          content: Text('Please record and detect your mood first'),
          duration: Duration(seconds: 2),
        ),
      );
    }
    // Updated to ensure theme parameters are passed correctly
    // This comment is for clarity and can be removed if not needed
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
              child: SizedBox(
                width: screenWidth,
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
                              onTapDown: (_) => setState(() => isBackPressed = true),
                              onTapUp: (_) {
                                setState(() => isBackPressed = false);
                                _handleBack();
                              },
                              onTapCancel: () => setState(() => isBackPressed = false),
                              child: AnimatedScale(
                                scale: isBackPressed ? 1.15 : 1.0,
                                duration: const Duration(milliseconds: 120),
                                curve: Curves.easeOut,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 120),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(isBackPressed ? 0.25 : 0.15),
                                        blurRadius: 4 * scaleW,
                                        offset: Offset(0, 4 * scaleH),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: isBackPressed ? const Color(0xFFD3CECE) : const Color(0xFF383737),
                                    size: 24 * scaleW,
                                  ),
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
                            SizedBox(width: 24 * scaleW), // Placeholder for balance
                          ],
                        ),
                      ),

                      // "Tell us how you feel" prompt
                      Padding(
                        padding: EdgeInsets.only(bottom: 30 * scaleH),
                        child: Text(
                          'Tell us how you feel',
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

                      // Large microphone icon (animated scale + color on press)
                      GestureDetector(
                        onTapDown: (_) => setState(() => isMicPressed = true),
                        onTapUp: (_) {
                          setState(() => isMicPressed = false);
                          Future.delayed(const Duration(milliseconds: 0), _toggleRecording);
                        },
                        onTapCancel: () => setState(() => isMicPressed = false),
                        child: AnimatedScale(
                          scale: isMicPressed ? 1.12 : 1.0,
                          duration: const Duration(milliseconds: 140),
                          curve: Curves.easeOut,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 140),
                            width: 124 * scaleW,
                            height: 124 * scaleH,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isMicPressed ? const Color(0xFFFFD4D0) : const Color(0xFFE8F2FB),
                              boxShadow: isMicPressed
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF5B80A4).withOpacity(0.3),
                                        blurRadius: 12 * scaleW,
                                        offset: Offset(0, 6 * scaleH),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              Icons.mic,
                              color: isMicPressed ? const Color(0xFFFC4E50) : const Color(0xFF4F6678),
                              size: 60 * scaleW,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30 * scaleH),

                      // Transcribed text box with Edit button
                      Container(
                        width: 343 * scaleW,
                        height: 150 * scaleH,
                        padding: EdgeInsets.all(16 * scaleW),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F2FB),
                          borderRadius: BorderRadius.circular(15 * scaleW),
                        ),
                        child: Stack(
                          children: [
                            // Text content
                            Positioned(
                              left: 0,
                              top: 0,
                              right: 50 * scaleW,
                              bottom: 0,
                              child: SingleChildScrollView(
                                child: Text(
                                  transcribedText.isEmpty
                                      ? 'Tap the microphone to start speaking...'
                                      : transcribedText,
                                  style: TextStyle(
                                    fontSize: 16 * scaleW,
                                    color: const Color(0xFF383737),
                                    fontFamily: 'Arial Rounded MT Bold',
                                  ),
                                  maxLines: 8,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            // Edit button (bottom right)
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onTapDown: (_) => setState(() => isEditPressed = true),
                                onTapUp: (_) {
                                  setState(() => isEditPressed = false);
                                  _handleEdit();
                                },
                                onTapCancel: () => setState(() => isEditPressed = false),
                                child: AnimatedScale(
                                  scale: isEditPressed ? 1.12 : 1.0,
                                  duration: const Duration(milliseconds: 120),
                                  curve: Curves.easeOut,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 120),
                                    width: 34 * scaleW,
                                    height: 16 * scaleH,
                                    decoration: BoxDecoration(
                                      color: isEditPressed ? const Color(0xFF5B80A4) : const Color(0xFF4F6678),
                                      borderRadius: BorderRadius.circular(7 * scaleW),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Edit',
                                      style: TextStyle(
                                        fontSize: 10 * scaleW,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFFD3CECE),
                                        fontFamily: 'Inter',
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20 * scaleH),

                      // Detected mood display (Figma exact style)
                      if (detectedMood != null && allowedMoods.contains(detectedMood))
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

                      // See Suggestions button (animated scale + color on press)
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
              ),
            );
          },
        ),
      ),
    );
  }
}

