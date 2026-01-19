import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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

  late stt.SpeechToText _speech;
  final TextEditingController _textController = TextEditingController();
  String _transcribedText = '';
  String _detectedMood = 'Happy';
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _textController.addListener(() {
      final text = _textController.text;
      // Keep _transcribedText in sync with what the user types.
      _transcribedText = text;
      // Detect emotion from the English text and update the UI.
      final mood = _analyzeEmotion(text);
      if (mood != _detectedMood) {
        setState(() => _detectedMood = mood);
      }
    });
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          final words = result.recognizedWords;
          // Update both the controller (what user sees/edits) and our backing field.
          _textController.text = words;
          _textController.selection = TextSelection.fromPosition(
            TextPosition(offset: _textController.text.length),
          );
          setState(() {
            _transcribedText = words;
            _detectedMood = _analyzeEmotion(words);
          });
        },
      );
    }
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  String _analyzeEmotion(String text) {
    // Simple keyword-based emotion detection
    final lower = text.toLowerCase();
    if (lower.contains('happy') || lower.contains('joy') || lower.contains('excited')) return 'Happy';
    if (lower.contains('sad') || lower.contains('down') || lower.contains('cry')) return 'Sad';
    if (lower.contains('angry') || lower.contains('mad') || lower.contains('furious')) return 'Angry';
    if (lower.contains('calm') || lower.contains('relaxed')) return 'Calm';
    if (lower.contains('anxious') || lower.contains('nervous')) return 'Anxious';
    if (lower.contains('romantic') || lower.contains('love')) return 'Romantic';
    return 'Neutral';
  }

  Future<void> _editText() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VoiceOverlayEditScreen(
          themeAssets: widget.themeAssets,
          themeMode: widget.themeMode,
          initialText: _textController.text,
        ),
      ),
    );
    if (result != null && result is Map) {
      String text = result['text'] ?? '';
      String mood = result['mood'] ?? _extractMoodFromText(text);
      setState(() {
        _textController.text = text;
        _textController.selection = TextSelection.fromPosition(TextPosition(offset: _textController.text.length));
        _transcribedText = text;
        _detectedMood = mood;
      });
    }
  }
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String _extractMoodFromText(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('happy')) return 'Happy';
    if (lower.contains('sad')) return 'Sad';
    if (lower.contains('anxious')) return 'Anxious';
    if (lower.contains('romantic')) return 'Romantic';
    if (lower.contains('angry')) return 'Angry';
    if (lower.contains('calm')) return 'Calm';
    return 'Neutral';
  }

  @override
  Widget build(BuildContext context) {
    // Asset URLs from Figma
      final String arrowDefault = 'assets/arrow_default.png';
      final String arrowPressed = 'assets/Property 1=ArrowBackPressed.png';
      // Use local assets for mic (always the same regardless of theme)
      final String micDefault = 'assets/BigMIC_default.png';
      final String micPressed = 'assets/BigMic_pressed_right.png';
      final String seeSuggestionsNormal = 'assets/Property 1=Default.png';
      final String seeSuggestionsPressed = 'assets/Property 1=Variant2.png';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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

          // 'moosik' logo or text depending on theme
          if (widget.themeMode == AppThemeMode.dark)
            Positioned(
              left: 145,
              top: 21,
              child: SizedBox(
                width: 122,
                height: 49,
                child: Image.asset(
                  'assets/moosic_dark.png',
                  width: 122,
                  height: 49,
                  fit: BoxFit.contain,
                ),
              ),
            )
          else
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

          // 'Tell us how you feel' text under moosik, matching moosik color
          Positioned(
  left: 0,
  right: 0,
  top: 21 + 49 + 8, // 8px gap below logo/text
  child: Center(
    child: Text(
      'Tell us how you feel',
      style: TextStyle(
        fontFamily: 'Arial Rounded MT Bold',
        fontWeight: FontWeight.w400,
        fontSize: 18,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
    ),
  ),
),







          // See Suggestions button (light mode: revert to previous custom style)
          Positioned(
            left: 61,
            top: 576,
            child: GestureDetector(
              onTapDown: (_) => setState(() => _seeSuggestionsPressed = true),
              onTapUp: (_) {
                setState(() => _seeSuggestionsPressed = false);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ResultsScreen(
                      mood: _detectedMood,
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
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(29),
                      child: Image.asset(
                        Theme.of(context).brightness == Brightness.dark
                            ? (_seeSuggestionsPressed ? seeSuggestionsPressed : seeSuggestionsNormal)
                            : (_seeSuggestionsPressed ? seeSuggestionsPressed : seeSuggestionsNormal),
                        width: 289,
                        height: 58,
                        fit: BoxFit.cover,
                        color: Theme.of(context).brightness == Brightness.dark ? Color(0xFF2D547A) : null,
                        colorBlendMode: Theme.of(context).brightness == Brightness.dark ? BlendMode.srcATop : null,
                      ),
                    ),
                    if (Theme.of(context).brightness == Brightness.dark)
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            'See Suggestions->',
                            style: TextStyle(
                              fontFamily: 'Arial Rounded MT Bold',
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Color(0xFFFFFBF7), // light color for dark mode
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // Big Microphone with Ellipse effect when pressed (centered, independent box/img sizes)
          ...(() {
            // Default and pressed sizes for the mic
            const double defaultSize = 124.0;
            const double pressedSize = 140.0;
            // Center coordinates (from previous logic)
            const double defaultLeft = 91.5 + 228/2 - defaultSize/2;
            const double defaultTop  = 106 + 29 + 10;
            const double centerX = defaultLeft + defaultSize/2;
            const double centerY = defaultTop  + defaultSize/2;
            final double micSize = _micPressed ? pressedSize : defaultSize;
            return [
              Positioned(
                left: centerX - micSize/2,
                top: centerY - micSize/2,
                child: GestureDetector(
                  onTapDown: (_) {
                    setState(() => _micPressed = true);
                    _startListening();
                  },
                  onTapUp: (_) {
                    setState(() => _micPressed = false);
                    _stopListening();
                  },
                  onTapCancel: () {
                    setState(() => _micPressed = false);
                    _stopListening();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    width: micSize,
                    height: micSize,
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (Theme.of(context).brightness == Brightness.dark)
                          Image.asset(
                            'assets/Ellipse 1.png',
                            width: micSize,
                            height: micSize,
                            fit: BoxFit.contain,
                            color: Color(0xFF727475),
                            colorBlendMode: BlendMode.srcIn,
                          ),
                        if (_micPressed)
                          Image.asset(
                            micPressed,
                            width: micSize,
                            height: micSize,
                            fit: BoxFit.contain,
                          )
                        else if (Theme.of(context).brightness == Brightness.dark)
                          Image.asset(
                            'assets/BigMic_darkmode.png',
                            width: micSize,
                            height: micSize,
                            fit: BoxFit.contain,
                          )
                        else
                          Image.asset(
                            micDefault,
                            width: micSize,
                            height: micSize,
                            fit: BoxFit.contain,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          })(),
          // Detected Mood box
          Positioned(
            left: 55.5,
            top: 499,
            child: Container(
              width: 300,
              height: 44,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF727475)
                    : Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 27),
                  Text(
                    'Detected mood: ',
                    style: TextStyle(
                      fontFamily: 'Arial Rounded MT Bold',
                      fontSize: 20,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFFEFEFEF)
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  Text(
                    _detectedMood,
                    style: TextStyle(
                      fontFamily: 'Arial Rounded MT Bold',
                      fontSize: 20,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF9076FE)
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Text box: color #E8F2FB in light mode, original in dark mode
          if (widget.themeMode == AppThemeMode.light)
            Positioned(
              left: 34,
              top: 325,
              child: SizedBox(
                width: 343,
                height: 150,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F2FB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                    child: TextField(
                      controller: _textController,
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.top,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                        hintText: 'Say something...!',
                        hintStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          else
            Positioned(
              left: 34,
              top: 325,
              child: SizedBox(
                width: 343,
                height: 150,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF727475),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                    child: TextField(
                      controller: _textController,
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.top,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                        hintText: 'Say something...!',
                        hintStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.white70,
                        ),
                      ),
                    ),
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
                _editText();
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
          // (Removed old logo box, replaced with styled text above)
        ],
      ),
    );
  }
}
