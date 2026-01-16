import 'package:flutter/material.dart';
import 'main.dart';

class VoiceOverlayEditScreen extends StatefulWidget {
  final String initialText;
  final Map<String, String> themeAssets;
  final AppThemeMode themeMode;

  const VoiceOverlayEditScreen({super.key, this.initialText = '', required this.themeAssets, required this.themeMode});

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            final baseWidth = 411.0;
            final baseHeight = 731.0;
            final scaleW = screenWidth / baseWidth;
            final scaleH = screenHeight / baseHeight;
            return Stack(
              children: [
                // Camera window (visual placeholder)
                Positioned(
                  left: 569 * scaleW,
                  top: 151 * scaleH,
                  width: 289 * scaleW,
                  height: 310 * scaleH,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBF7),
                      border: Border.all(color: const Color(0xFF383737), width: 2 * scaleW),
                      borderRadius: BorderRadius.circular(16 * scaleW),
                    ),
                  ),
                ),
                // Title
                Positioned(
                  left: 91.5 * scaleW,
                  top: 106 * scaleH,
                  width: 228 * scaleW,
                  height: 29 * scaleH,
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
                // Text box
                Positioned(
                  left: 34 * scaleW,
                  top: 176 * scaleH,
                  width: 343 * scaleW,
                  height: 150 * scaleH,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F2FB),
                      borderRadius: BorderRadius.circular(15 * scaleW),
                    ),
                    child: TextField(
                      controller: _textController,
                      maxLines: 8,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Edit your text here...',
                        hintStyle: TextStyle(
                          color: const Color(0xFFBBBBBB),
                          fontFamily: 'Arial Rounded MT Bold',
                          fontSize: 16 * scaleW,
                        ),
                        contentPadding: EdgeInsets.all(16 * scaleW),
                      ),
                      style: TextStyle(
                        fontSize: 16 * scaleW,
                        color: const Color(0xFF383737),
                        fontFamily: 'Arial Rounded MT Bold',
                      ),
                    ),
                  ),
                ),
                // OK button
                Positioned(
                  left: 290 * scaleW,
                  top: 305 * scaleH,
                  width: 34 * scaleW,
                  height: 16 * scaleH,
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
                          borderRadius: BorderRadius.circular(7 * scaleW),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'OK',
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
                // Cancel button
                Positioned(
                  left: 331 * scaleW,
                  top: 305 * scaleH,
                  width: 52 * scaleW,
                  height: 16 * scaleH,
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
                          borderRadius: BorderRadius.circular(7 * scaleW),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Cancel',
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
                // Logo
                Positioned(
                  left: 145 * scaleW,
                  top: 21 * scaleH,
                  width: 122 * scaleW,
                  height: 49 * scaleH,
                  child: Text(
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
                ),
                // System keyboard (visual placeholder)
                Positioned(
                  left: -1 * scaleW,
                  top: 396 * scaleH,
                  width: 411 * scaleW,
                  height: 335 * scaleH,
                  child: Container(
                    color: const Color(0xFFD9D9D9),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
