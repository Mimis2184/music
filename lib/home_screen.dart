import 'camera_screen.dart';
import 'package:music/voice_overlay_screen.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:music/results_screen.dart';

import 'main.dart';

// Figma assets
const String imgHappy =
    'https://www.figma.com/api/mcp/asset/4f2c0b74-d1df-4ecc-b271-fb2a00e82170';
const String imgAnxious =
    'https://www.figma.com/api/mcp/asset/5a470cc2-779d-4b9b-93df-a2700a94f003';
const String imgRomantic =
    'https://www.figma.com/api/mcp/asset/290203f6-4f59-4dfe-a146-eb312738531d';
const String imgLogo =
    'https://www.figma.com/api/mcp/asset/ff332b3e-8869-46dd-8350-bc5faa2df7a9';
const String imgSad =
    'https://www.figma.com/api/mcp/asset/08a83d0e-dffe-41aa-8a23-94ceae79f049';
const String imgAngry =
    'https://www.figma.com/api/mcp/asset/fb68694e-cc40-40d9-813b-37556e259cee';
const String imgCalm =
    'https://www.figma.com/api/mcp/asset/a10cae1e-9734-48f4-b60e-1628fa79be05';

// Small camera button assets (local)
const String smallCameraNormal = 'assets/SmallCamera_regurlar_right.png';
const String smallCameraPressed = 'assets/SmallCamera_pressed_rigth.png';

// Small mic button assets (local)
const String smallMicNormal = 'assets/1.png';
const String smallMicPressed = 'assets/Variant3.png';
const String smallMicDark = 'assets/smallmic_dark.png';
const String smallMicPressedDark = 'assets/smallmicpresseddark.png';
const String smallCameraDark = 'assets/smallcamera_dark.png';
const String smallCameraPressedDark = 'assets/smallcamerapresseddark.png';

// See Suggestions button assets (local)
const String seeSuggestionsNormal = 'assets/Property 1=Default.png';
const String seeSuggestionsPressed = 'assets/Property 1=Variant2.png';

class HomeScreen extends StatefulWidget {
  final Map<String, String> themeAssets;
  final AppThemeMode themeMode;
  const HomeScreen({
    super.key,
    required this.themeAssets,
    required this.themeMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSharePressed = false;
  String? selectedMood;
  bool isSeeSuggestionsPressed = false;
  bool isCameraPressed = false;
  bool isMicPressed = false;

  void _handleMoodSelection(String mood) {
    setState(() {
      selectedMood = selectedMood == mood ? null : mood;
    });
  }

  Future<void> _persistMood(String mood) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastMood', mood);
  }

  void _handleSeeSuggestions() async {
    setState(() => isSeeSuggestionsPressed = false);
    if (selectedMood != null) {
      await _persistMood(selectedMood!);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultsScreen(
            mood: selectedMood!,
            themeAssets: widget.themeAssets,
            themeMode: widget.themeMode,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a mood first'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleCamera() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          themeAssets: widget.themeAssets,
          themeMode: widget.themeMode,
        ),
      ),
    );
  }

  void _handleMicrophone() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VoiceOverlayScreen(
          themeAssets: widget.themeAssets,
          themeMode: widget.themeMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Logo
          Positioned(
            left: 26,
            top: 12,
            child: SizedBox(
              width: 174,
              height: 174,
              child: Image.network(imgLogo, fit: BoxFit.cover),
            ),
          ),

          // Large 'moosik'
          Positioned(
            left: 189,
            top: 57,
            child: SizedBox(
              width: 187,
              height: 75,
              child: Text(
                'moosik',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w800,
                  fontSize: 55,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // Main message
          Positioned(
            left: 26,
            top: 185,
            width: 350,
            child: Text(
              'How are you feeling today?',
              style: TextStyle(
                fontFamily: 'Arial Rounded MT Bold',
                fontWeight: FontWeight.w400,
                fontSize: 24,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),

          // Mood buttons row 1
          Positioned(
            left: 34.5,
            top: 235,
            child: Row(
              children: [
                _moodButton('Happy', imgHappy, 0),
                const SizedBox(width: 30),
                _moodButton('Sad', imgSad, 1),
                const SizedBox(width: 30),
                _moodButton('Calm', imgCalm, 2),
              ],
            ),
          ),

          // Mood buttons row 2
          Positioned(
            left: 34.5,
            top: 363,
            child: Row(
              children: [
                _moodButton('Anxious', imgAnxious, 3),
                const SizedBox(width: 30),
                _moodButton('Romantic', imgRomantic, 4),
                const SizedBox(width: 30),
                _moodButton('Angry', imgAngry, 5),
              ],
            ),
          ),

          // Small mic
          Positioned(
            left: 115,
            top: 493,
            child: GestureDetector(
              onTapDown: (_) => setState(() => isMicPressed = true),
              onTapUp: (_) {
                setState(() => isMicPressed = false);
                _handleMicrophone();
              },
              onTapCancel: () => setState(() => isMicPressed = false),
              child: Column(
                children: [
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: Stack(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF312F2D)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: Center(
                            // Slightly lower visual centering
                            child: Transform.translate(
                              offset: const Offset(0, 2),
                              child: Image.asset(
                                isDark
                                    ? (isMicPressed
                                          ? smallMicPressedDark
                                          : smallMicDark)
                                    : (isMicPressed
                                          ? smallMicPressed
                                          : smallMicNormal),
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Speak',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          // Small camera
          Positioned(
            left: 240,
            top: 493,
            child: GestureDetector(
              onTapDown: (_) => setState(() => isCameraPressed = true),
              onTapUp: (_) {
                setState(() => isCameraPressed = false);
                _handleCamera();
              },
              onTapCancel: () => setState(() => isCameraPressed = false),
              child: Column(
                children: [
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: Stack(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF312F2D)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: Center(
                            // Slightly lower visual centering
                            child: Transform.translate(
                              offset: const Offset(0, 2),
                              child: Image.asset(
                                isDark
                                    ? (isCameraPressed
                                          ? smallCameraPressedDark
                                          : smallCameraDark)
                                    : (isCameraPressed
                                          ? smallCameraPressed
                                          : smallCameraNormal),
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Camera',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          // See Suggestions button
          Positioned(
            left: 61,
            top: 594,
            child: GestureDetector(
              onTapDown: (_) => setState(() => isSeeSuggestionsPressed = true),
              onTapUp: (_) => _handleSeeSuggestions(),
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
                        color: isDark ? Theme.of(context).primaryColor : null,
                        colorBlendMode: isDark ? BlendMode.srcATop : null,
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Text(
                          'See Suggestions ->',
                          style: TextStyle(
                            fontFamily: 'Arial Rounded MT Bold',
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: isDark
                                ? Theme.of(context).scaffoldBackgroundColor
                                : Colors.transparent,
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

  Widget _moodButton(String label, String imgUrl, int index) {
    final isSelected = selectedMood == label;
    return GestureDetector(
      onTap: () => _handleMoodSelection(label),
      child: Container(
        width: 94,
        height: 102,
        decoration: BoxDecoration(
          color: isSelected
              ? (Theme.of(context).brightness == Brightness.light
                    ? AppColors.lightSelectedMood
                    : AppColors.darkSelectedMood)
              : (Theme.of(context).brightness == Brightness.light
                    ? AppColors.lightButtonColor2
                    : Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 56,
              height: 56,
              child: Image.network(imgUrl, fit: BoxFit.contain),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
