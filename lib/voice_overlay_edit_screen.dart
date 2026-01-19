// voice_overlay_edit_screen.dart
import 'package:flutter/material.dart';
import 'main.dart';

class VoiceOverlayEditScreen extends StatefulWidget {
  final Map<String, String> themeAssets;
  final AppThemeMode themeMode;
  final String initialText;
  const VoiceOverlayEditScreen({
    super.key,
    required this.themeAssets,
    required this.themeMode,
    required this.initialText,
  });

  @override
  State<VoiceOverlayEditScreen> createState() => _VoiceOverlayEditScreenState();
}

class _VoiceOverlayEditScreenState extends State<VoiceOverlayEditScreen> {
  static const String textBoxAsset = "assets/bluetextbox.png";
  final TextEditingController _controller = TextEditingController();
  String _detectedMood = '';

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialText;
    _detectedMood = widget.initialText.trim().isEmpty
        ? ''
        : _analyzeEmotion(widget.initialText);

    _controller.addListener(() {
      setState(() {
        final t = _controller.text;
        _detectedMood = t.trim().isEmpty ? '' : _analyzeEmotion(t);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _analyzeEmotion(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('happy') ||
        lower.contains('joy') ||
        lower.contains('excited')) {
      return 'Happy';
    }
    if (lower.contains('sad') ||
        lower.contains('down') ||
        lower.contains('cry')) {
      return 'Sad';
    }
    if (lower.contains('angry') ||
        lower.contains('mad') ||
        lower.contains('furious')) {
      return 'Angry';
    }
    if (lower.contains('calm') || lower.contains('relaxed')) return 'Calm';
    if (lower.contains('anxious') || lower.contains('nervous'))
      return 'Anxious';
    if (lower.contains('romantic') || lower.contains('love')) return 'Romantic';
    return 'Neutral';
  }

  void _onOkPressed() {
    Navigator.of(
      context,
    ).pop({'text': _controller.text, 'mood': _detectedMood});
  }

  void _onCancelPressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Tell us how you feel
          Positioned(
            left: 91.5,
            top: 106,
            child: SizedBox(
              width: 228,
              height: 29,
              child: Center(
                child: Text(
                  'Tell us how you feel',
                  style: TextStyle(
                    fontFamily: 'Arial Rounded MT Bold',
                    fontWeight: FontWeight.w400,
                    fontSize: 24,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          // Blue box (editable TextField)
          Positioned(
            left: 34,
            top: 230,
            child: SizedBox(
              width: 343,
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                  // Light mode is the source of truth; in dark mode only the color changes.
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).cardColor
                      : const Color(0xFFE8F2FB),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  maxLines: 5,
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                    hintText: 'Say something...!',
                  ),
                ),
              ),
            ),
          ),

          // OK + Cancel buttons (inside the blue box)
          Positioned(
            right: 34 + 20,
            top: 350,
            child: _CancelButton(onPressed: _onCancelPressed),
          ),
          Positioned(
            right: 34 + 20 + 52 + 8,
            top: 350,
            child: _OkButton(onPressed: _onOkPressed),
          ),

          // Moosik logo (small, text only)
          Positioned(
            left: 145,
            top: 21,
            child: SizedBox(
              width: 122,
              height: 49,
              child: Center(
                child: Text(
                  'moosik',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w800,
                    fontSize: 36,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
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

// Custom OK Button widget
class _OkButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _OkButton({required this.onPressed});

  @override
  State<_OkButton> createState() => _OkButtonState();
}

class _OkButtonState extends State<_OkButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: SizedBox(
        width: 34,
        height: 16,
        child: Image.asset(
          _pressed ? 'assets/ok_pressed.png' : 'assets/ok_default.png',
          width: 34,
          height: 16,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// Custom Cancel Button widget
class _CancelButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _CancelButton({required this.onPressed});

  @override
  State<_CancelButton> createState() => _CancelButtonState();
}

class _CancelButtonState extends State<_CancelButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: SizedBox(
        width: 52,
        height: 16,
        child: Image.asset(
          _pressed ? 'assets/cancel_pressed.png' : 'assets/canceldefault.png',
          width: 52,
          height: 16,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
