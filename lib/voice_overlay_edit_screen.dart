import 'package:flutter/material.dart';
import 'main.dart';

class VoiceOverlayEditScreen extends StatefulWidget {
  final String initialText;
  final Map<String, String> themeAssets;
  final AppThemeMode themeMode;

  VoiceOverlayEditScreen({Key? key, this.initialText = '', required this.themeAssets, required this.themeMode}) : super(key: key);

  @override
  State<VoiceOverlayEditScreen> createState() => _VoiceOverlayEditScreenState();
}

class _VoiceOverlayEditScreenState extends State<VoiceOverlayEditScreen> {
  late TextEditingController _textController;
  bool isOkPressed = false;
  bool isCancelPressed = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleOK() {
    // Return the edited text to previous screen
    Navigator.of(context).pop(_textController.text);
  }

  void _handleCancel() {
    // Return null or original text without changes
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.themeMode == AppThemeMode.light ? const Color(0xFFFFFBF7) : const Color(0xFF312F2D),
      body: SafeArea(
        child: Stack(
          children: [
            // Camera window (visual placeholder)
            Positioned(
              left: 569,
              top: 151,
              width: 289,
              height: 310,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBF7),
                  border: Border.all(color: const Color(0xFF383737), width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            // Title
            const Positioned(
              left: 91.5,
              top: 106,
              width: 228,
              height: 29,
              child: Text(
                'Tell us how you feel',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF383737),
                  fontFamily: 'Arial Rounded MT Bold',
                ),
              ),
            ),
            // Text box
            Positioned(
              left: 34,
              top: 176,
              width: 343,
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F2FB),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: _textController,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Edit your text here...',
                    hintStyle: TextStyle(
                      color: Color(0xFFBBBBBB),
                      fontFamily: 'Arial Rounded MT Bold',
                    ),
                    contentPadding: EdgeInsets.all(16),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF383737),
                    fontFamily: 'Arial Rounded MT Bold',
                  ),
                ),
              ),
            ),
            // OK button
            Positioned(
              left: 290,
              top: 305,
              width: 34,
              height: 16,
              child: GestureDetector(
                onTapDown: (_) => setState(() => isOkPressed = true),
                onTapUp: (_) {
                  setState(() => isOkPressed = false);
                  _handleOK();
                },
                onTapCancel: () => setState(() => isOkPressed = false),
                child: AnimatedScale(
                  scale: isOkPressed ? 1.12 : 1.0,
                  duration: const Duration(milliseconds: 120),
                  curve: Curves.easeOut,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    decoration: BoxDecoration(
                      color: isOkPressed ? const Color(0xFF5B80A4) : const Color(0xFF4F6678),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD3CECE),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Cancel button
            Positioned(
              left: 331,
              top: 305,
              width: 52,
              height: 16,
              child: GestureDetector(
                onTapDown: (_) => setState(() => isCancelPressed = true),
                onTapUp: (_) {
                  setState(() => isCancelPressed = false);
                  _handleCancel();
                },
                onTapCancel: () => setState(() => isCancelPressed = false),
                child: AnimatedScale(
                  scale: isCancelPressed ? 1.12 : 1.0,
                  duration: const Duration(milliseconds: 120),
                  curve: Curves.easeOut,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    decoration: BoxDecoration(
                      color: isCancelPressed ? const Color(0xFF5B80A4) : const Color(0xFF4F6678),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD3CECE),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Logo
            const Positioned(
              left: 145,
              top: 21,
              width: 122,
              height: 49,
              child: Text(
                'moosik',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF383737),
                  fontFamily: 'Nunito',
                ),
              ),
            ),
            // System keyboard (visual placeholder)
            Positioned(
              left: -1,
              top: 396,
              width: 411,
              height: 335,
              child: Container(
                color: const Color(0xFFD9D9D9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
