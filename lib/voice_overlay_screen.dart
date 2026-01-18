import 'package:flutter/material.dart';

import 'results_screen.dart';
import 'voice_overlay_edit_screen.dart';

import 'main.dart';

class VoiceOverlayScreen extends StatefulWidget {
  final Map<String, String> themeAssets;
  final AppThemeMode themeMode;
  const VoiceOverlayScreen({super.key, required this.themeAssets, required this.themeMode});

  @override
  State<VoiceOverlayScreen> createState() => _VoiceOverlayScreenState();
}

class _VoiceOverlayScreenState extends State<VoiceOverlayScreen> {
  bool _micPressed = false;
  bool _arrowPressed = false;
  bool _seeSuggestionsPressed = false;
  bool _editPressed = false;
  @override
  Widget build(BuildContext context) {
    // Asset URLs from Figma
      final String arrowDefault = 'assets/arrow_default.png';
      final String arrowPressed = 'assets/Property 1=ArrowBackPressed.png';
      // Use local assets for mic
      final String micDefault = 'assets/micdef.png';
      final String micPressed = 'assets/micpre.png';
      final String seeSuggestionsNormal = 'assets/Property 1=Default.png';
      final String seeSuggestionsPressed = 'assets/Property 1=Variant2.png';
      final String imgTextBox = "https://www.figma.com/api/mcp/asset/cbbbe656-6609-4d84-9838-28860074c579";

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF7),
      body: Stack(
        children: [
          // Back arrow
          Positioned(
            left: 25,
            top: 26,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
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
                  _arrowPressed ? arrowPressed : arrowDefault,
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // See Suggestions button
          Positioned(
            left: 61,
            top: 576,
            child: GestureDetector(
              onTapDown: (_) => setState(() => _seeSuggestionsPressed = true),
              onTapUp: (_) {
                setState(() => _seeSuggestionsPressed = false);
                // Navigate to ResultsScreen with a default mood (e.g., 'Happy')
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ResultsScreen(
                      mood: 'Happy', // or any default mood you want
                      themeAssets: widget.themeAssets,
                      themeMode: widget.themeMode,
                    ),
                  ),
                );
              },
              onTapCancel: () => setState(() => _seeSuggestionsPressed = false),
              child: SizedBox(
                width: 289,
                height: 58,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(29),
                  child: Image.asset(
                    _seeSuggestionsPressed ? seeSuggestionsPressed : seeSuggestionsNormal,
                    width: 289,
                    height: 58,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          // Big Microphone
          Positioned(
            left: 143.5,
            top: 168,
            child: GestureDetector(
              onTapDown: (_) => setState(() => _micPressed = true),
              onTapUp: (_) => setState(() => _micPressed = false),
              onTapCancel: () => setState(() => _micPressed = false),
              child: SizedBox(
                width: 124,
                height: 124,
                child: Image.asset(
                  _micPressed ? micPressed : micDefault,
                  width: 124,
                  height: 124,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // Detected Mood box
          Positioned(
            left: 55.5,
            top: 499,
            child: Container(
              width: 300,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F2FB),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: const [
                  SizedBox(width: 27),
                  Text(
                    'Detected mood: ',
                    style: TextStyle(
                      fontFamily: 'Arial Rounded MT Bold',
                      fontSize: 20,
                      color: Color(0xFF383737),
                    ),
                  ),
                  Text(
                    'Happy',
                    style: TextStyle(
                      fontFamily: 'Arial Rounded MT Bold',
                      fontSize: 20,
                      color: Color(0xFF615690),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Blue text box (local asset, matches Figma prototype exactly)
          Positioned(
            left: 34,
            top: 325,
            child: SizedBox(
              width: 343,
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/bluetextbox.png',
                  width: 343,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // "Tell us how you feel"
          Positioned(
            left: 91.5,
            top: 106,
            child: SizedBox(
              width: 228,
              height: 29,
              child: const Center(
                child: Text(
                  'Tell us how you feel',
                  style: TextStyle(
                    fontFamily: 'Arial Rounded MT Bold',
                    fontWeight: FontWeight.w400,
                    fontSize: 24,
                    color: Color(0xFF383737),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          // Edit button (image asset, changes on press)
          Positioned(
            left: 325,
            top: 453,
            child: GestureDetector(
              onTapDown: (_) => setState(() => _editPressed = true),
              onTapUp: (_) {
                setState(() => _editPressed = false);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VoiceOverlayEditScreen(
                      themeAssets: widget.themeAssets,
                      themeMode: widget.themeMode,
                    ),
                  ),
                );
              },
              onTapCancel: () => setState(() => _editPressed = false),
              child: SizedBox(
                width: 34,
                height: 16,
                child: Image.asset(
                  _editPressed ? 'assets/edit2.png' : 'assets/edit1.png',
                  width: 34,
                  height: 16,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // ...existing code...
          // Moosik logo (small)
          Positioned(
            left: 145,
            top: 21,
            child: Container(
              width: 122,
              height: 49,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/moosik(small).png',
                width: 122,
                height: 49,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
