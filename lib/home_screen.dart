import 'package:flutter/material.dart';
import 'package:music/camera_screen.dart';
import 'package:music/voice_overlay_screen.dart';
import 'package:music/results_screen.dart';
import 'package:music/widgets/mood_button.dart';
import 'package:music/widgets/action_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedMood;
  bool isCameraPressed = false;
  bool isMicPressed = false;
  bool isSeeSuggestionsPressed = false;

  // Emoji image URLs from Figma (node 113:694) - Default states
  final String happyEmoji = "https://www.figma.com/api/mcp/asset/5bdf8c50-be7e-4f1c-a838-b02f2dd6cb1f";
  final String sadEmoji = "https://www.figma.com/api/mcp/asset/218ebb61-9fad-4f25-b0c3-0c0e301e2196";
  final String calmEmoji = "https://www.figma.com/api/mcp/asset/05456a95-690a-4eea-b1f6-e6ac76107c1e";
  final String anxiousEmoji = "https://www.figma.com/api/mcp/asset/a2623142-b131-4a87-abfc-2f0776a41ba0";
  final String romanticEmoji = "https://www.figma.com/api/mcp/asset/f515bee9-44d2-447f-98e9-3f241d68a6cd";
  final String angryEmoji = "https://www.figma.com/api/mcp/asset/45fb0bbe-2949-4ed7-b06b-57658881e3d1";
  
  // Emoji image URLs from Figma assets page (node 23:35) - Pressed states
  final String happyEmojiPressed = "https://www.figma.com/api/mcp/asset/8528c9cf-e174-44af-9af2-5d995a7d3881";
  final String sadEmojiPressed = "https://www.figma.com/api/mcp/asset/c2faef8d-3ffb-4499-a03f-eba24061723b";
  final String calmEmojiPressed = "https://www.figma.com/api/mcp/asset/5cc43946-f52c-47e3-aba4-efdb757c7daf";
  final String anxiousEmojiPressed = "https://www.figma.com/api/mcp/asset/a1adf183-971a-4be6-a7b1-dfa3f2ac4ba3";
  final String romanticEmojiPressed = "https://www.figma.com/api/mcp/asset/38f8d12b-1219-4a11-8211-011a1bc87adb";
  final String angryEmojiPressed = "https://www.figma.com/api/mcp/asset/e64da4d8-a142-41c4-b875-79c993711461";
  
  final String logoUrl = "https://www.figma.com/api/mcp/asset/74fffb3f-7f87-4bdc-a8d1-82eb6a82c753";

  void _handleMoodSelection(String mood) {
    setState(() {
      selectedMood = selectedMood == mood ? null : mood;
    });
  }

  void _handleSeeSuggestions() {
    if (selectedMood != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultsScreen(mood: selectedMood!),
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
    // Clear the pressed visual immediately on release, then navigate.
    setState(() {
      isCameraPressed = false;
    });
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CameraScreen(),
      ),
    ).then((_) {
      setState(() {
        isCameraPressed = false;
      });
    });
  }

  void _handleMicrophone() {
    // Clear the pressed visual immediately on release, then navigate.
    setState(() {
      isMicPressed = false;
    });
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const VoiceOverlayScreen(),
      ),
    ).then((_) {
      setState(() {
        isMicPressed = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 411,
            child: Stack(
              children: [
                // Logo
                Positioned(
                  left: 26,
                  top: 12,
                  child: SizedBox(
                    width: 174,
                    height: 174,
                    child: Image.network(
                      logoUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),
                ),

                // App name "moosik"
                const Positioned(
                  left: 189,
                  top: 61,
                  child: Text(
                    'moosik',
                    style: TextStyle(
                      fontSize: 55,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF383737),
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),

                // Main content
                Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: Column(
                    children: [
                      // Title
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 48),
                        child: Text(
                          'How are you feeling today?',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF383737),
                            fontFamily: 'Arial Rounded MT Bold',
                          ),
                        ),
                      ),
                      const SizedBox(height: 35),

                      // First row of moods
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 34),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MoodButton(
                              label: 'Happy',
                              defaultEmojiUrl: happyEmoji,
                              pressedEmojiUrl: happyEmojiPressed,
                              isSelected: selectedMood == 'Happy',
                              onTap: () => _handleMoodSelection('Happy'),
                            ),
                            MoodButton(
                              label: 'Sad',
                              defaultEmojiUrl: sadEmoji,
                              pressedEmojiUrl: sadEmojiPressed,
                              isSelected: selectedMood == 'Sad',
                              onTap: () => _handleMoodSelection('Sad'),
                            ),
                            MoodButton(
                              label: 'Calm',
                              defaultEmojiUrl: calmEmoji,
                              pressedEmojiUrl: calmEmojiPressed,
                              isSelected: selectedMood == 'Calm',
                              onTap: () => _handleMoodSelection('Calm'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Second row of moods
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 34),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MoodButton(
                              label: 'Anxious',
                              defaultEmojiUrl: anxiousEmoji,
                              pressedEmojiUrl: anxiousEmojiPressed,
                              isSelected: selectedMood == 'Anxious',
                              onTap: () => _handleMoodSelection('Anxious'),
                            ),
                            MoodButton(
                              label: 'Romantic',
                              defaultEmojiUrl: romanticEmoji,
                              pressedEmojiUrl: romanticEmojiPressed,
                              isSelected: selectedMood == 'Romantic',
                              onTap: () => _handleMoodSelection('Romantic'),
                            ),
                            MoodButton(
                              label: 'Angry',
                              defaultEmojiUrl: angryEmoji,
                              pressedEmojiUrl: angryEmojiPressed,
                              isSelected: selectedMood == 'Angry',
                              onTap: () => _handleMoodSelection('Angry'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Action buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 115),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ActionButton(
                              label: 'Speak',
                              iconDefault: Image.network(
                                'https://www.figma.com/api/mcp/asset/6b99acdd-8e3b-4063-8145-4f252bf24fb0', // Figma node 23:35 mic default
                                width: 24,
                                height: 24,
                              ),
                              iconPressed: Image.network(
                                'https://www.figma.com/api/mcp/asset/59d5b492-9efe-4b34-be46-21bde88e2e38', // Figma node 23:35 mic pressed
                                width: 28,
                                height: 28,
                              ),
                              isPressed: isMicPressed,
                              pressedColor: const Color(0xFFFFD4D0), // Figma pressed color
                              onTapDown: () => setState(() => isMicPressed = true),
                              onTapUp: _handleMicrophone,
                              onTapCancel: () => setState(() => isMicPressed = false),
                              pressedScale: 1.12,
                            ),
                            ActionButton(
                              label: 'Camera',
                              iconDefault: Image.network(
                                'https://www.figma.com/api/mcp/asset/6b99acdd-8e3b-4063-8145-4f252bf24fb0', // Figma node 23:35 camera default
                                width: 24,
                                height: 24,
                              ),
                              iconPressed: Image.network(
                                'https://www.figma.com/api/mcp/asset/747d3524-0cf8-4068-b649-23654a3e0883', // Figma node 23:35 camera pressed
                                width: 28,
                                height: 28,
                              ),
                              isPressed: isCameraPressed,
                              pressedColor: const Color(0xFFFFD4D0), // Match mic pressed color
                              onTapDown: () => setState(() => isCameraPressed = true),
                              onTapUp: _handleCamera,
                              onTapCancel: () => setState(() => isCameraPressed = false),
                              pressedScale: 1.12,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // See Suggestions button (animated scale + color on press)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 61),
                        child: GestureDetector(
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
                              width: 289,
                              height: 58,
                              decoration: BoxDecoration(
                                color: isSeeSuggestionsPressed ? const Color(0xFF3F5F78) : const Color(0xFF5B80A4),
                                borderRadius: BorderRadius.circular(29),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'See Suggestions!',
                                style: TextStyle(
                                  color: Color(0xFFFFFBF7),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
