// voice_overlay_screen.dart
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'results_screen.dart';
import 'voice_overlay_edit_screen.dart';
import 'main.dart';

class VoiceOverlayScreen extends StatefulWidget {
  final Map<String, String> themeAssets;
  final AppThemeMode themeMode;
  const VoiceOverlayScreen({
    super.key,
    required this.themeAssets,
    required this.themeMode,
  });

  @override
  State<VoiceOverlayScreen> createState() => _VoiceOverlayScreenState();
}

class _VoiceOverlayScreenState extends State<VoiceOverlayScreen> {
  bool _micPressed = false;
  bool _arrowPressed = false;
  bool _seeSuggestionsPressed = false;
  bool _editPressed = false;

  late stt.SpeechToText _speech;
  bool _speechAvailable = false;

  String _transcribedText = '';
  String _detectedMood = '';
  bool _isListening = false;

  bool get _hasText => _transcribedText.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    final available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'notListening' || status == 'done') {
          if (mounted) setState(() => _isListening = false);
        }
      },
      onError: (error) {
        if (mounted) setState(() => _isListening = false);
      },
    );
    if (mounted) {
      setState(() {
        _speechAvailable = available;
      });
    }
  }

  void _startListening() async {
    if (!_speechAvailable) {
      await _initSpeech();
    }
    if (!_speechAvailable) return;

    // Start fresh while pressed
    setState(() {
      _isListening = true;
      _transcribedText = '';
      _detectedMood = '';
    });

    _speech.listen(
      localeId: 'en_US',
      partialResults: true,
      listenMode: stt.ListenMode.dictation,
      onResult: (result) {
        final text = result.recognizedWords;
        setState(() {
          _transcribedText = text;
          _detectedMood = _analyzeEmotion(text);
        });
      },
    );
  }

  void _stopListening() async {
    await _speech.stop();
    if (mounted) {
      setState(() => _isListening = false);
    }
  }

  String _analyzeEmotion(String text) {
    // Simple keyword-based emotion detection (English keywords)
    final lower = text.toLowerCase();
    if (lower.contains('happy') ||
        lower.contains('joy') ||
        lower.contains('excited'))
      return 'Happy';
    if (lower.contains('sad') ||
        lower.contains('down') ||
        lower.contains('cry'))
      return 'Sad';
    if (lower.contains('angry') ||
        lower.contains('mad') ||
        lower.contains('furious'))
      return 'Angry';
    if (lower.contains('calm') || lower.contains('relaxed')) return 'Calm';
    if (lower.contains('anxious') || lower.contains('nervous'))
      return 'Anxious';
    if (lower.contains('romantic') || lower.contains('love')) return 'Romantic';
    return 'Neutral';
  }

  Future<void> _editText() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VoiceOverlayEditScreen(
          themeAssets: widget.themeAssets,
          themeMode: widget.themeMode,
          initialText: _transcribedText,
        ),
      ),
    );

    if (result != null && result is Map) {
      final newText = (result['text'] ?? '') as String;
      final newMood = (result['mood'] ?? '') as String;

      setState(() {
        _transcribedText = newText;
        _detectedMood = newText.trim().isEmpty
            ? ''
            : (newMood.isNotEmpty ? newMood : _analyzeEmotion(newText));
      });
    }
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Assets
    final String arrowDefault = 'assets/arrow_default.png';
    final String arrowPressed = 'assets/Property 1=ArrowBackPressed.png';

    final String micDefault = 'assets/micdef.png';
    final String micPressed = 'assets/micpre.png';

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

          // Full title (wider so it doesn't get cut)
          Positioned(
            left: 91.5,
            top: 21 + 49 + 8,
            child: SizedBox(
              width: 228,
              height: 28,
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
                ),
              ),
            ),
          ),

          // See Suggestions button (disabled until we have text)
          Positioned(
            left: 61,
            top: 576,
            child: Opacity(
              opacity: _hasText ? 1.0 : 0.4,
              child: IgnorePointer(
                ignoring: !_hasText,
                child: GestureDetector(
                  onTapDown: (_) =>
                      setState(() => _seeSuggestionsPressed = true),
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
                  onTapCancel: () =>
                      setState(() => _seeSuggestionsPressed = false),
                  child: SizedBox(
                    width: 289,
                    height: 58,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(29),
                          child: Image.asset(
                            _seeSuggestionsPressed
                                ? seeSuggestionsPressed
                                : seeSuggestionsNormal,
                            width: 289,
                            height: 58,
                            fit: BoxFit.cover,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? const Color(0xFF2D547A)
                                : null,
                            colorBlendMode:
                                Theme.of(context).brightness == Brightness.dark
                                ? BlendMode.srcATop
                                : null,
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
                                  color: const Color(0xFFFFFBF7),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Big Microphone: listens while pressed
          ...(() {
            const double defaultBoxW = 124.0;
            const double defaultBoxH = 124.0;
            const double defaultImgW = 124.0;
            const double defaultImgH = 124.0;

            const double pressedBoxW = 180.0;
            const double pressedBoxH = 180.0;
            const double pressedImgW = 140.0;
            const double pressedImgH = 140.0;

            const double defaultLeft = 91.5 + 228 / 2 - defaultBoxW / 2;
            const double defaultTop = 106 + 29 + 10;
            const double centerX = defaultLeft + defaultBoxW / 2;
            const double centerY = defaultTop + defaultBoxH / 2;

            final double boxW = _micPressed ? pressedBoxW : defaultBoxW;
            final double boxH = _micPressed ? pressedBoxH : defaultBoxH;
            final double imgW = _micPressed ? pressedImgW : defaultImgW;
            final double imgH = _micPressed ? pressedImgH : defaultImgH;

            return [
              Positioned(
                left: centerX - boxW / 2,
                top: centerY - boxH / 2,
                child: GestureDetector(
                  onTapDown: (_) {
                    setState(() => _micPressed = true);
                    if (!_isListening) _startListening();
                  },
                  onTapUp: (_) {
                    setState(() => _micPressed = false);
                    if (_isListening) _stopListening();
                  },
                  onTapCancel: () {
                    setState(() => _micPressed = false);
                    if (_isListening) _stopListening();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    width: boxW,
                    height: boxH,
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (Theme.of(context).brightness == Brightness.dark)
                          Image.asset(
                            'assets/Ellipse 1.png',
                            width: boxW,
                            height: boxH,
                            fit: BoxFit.contain,
                            color: const Color(0xFF727475),
                            colorBlendMode: BlendMode.srcIn,
                          ),
                        if (_micPressed)
                          Image.asset(
                            micPressed,
                            width: imgW,
                            height: imgH,
                            fit: BoxFit.contain,
                          )
                        else if (Theme.of(context).brightness ==
                            Brightness.dark)
                          Image.asset(
                            'assets/BigMic_darkmode.png',
                            width: imgW,
                            height: imgH,
                            fit: BoxFit.contain,
                          )
                        else
                          Image.asset(
                            micDefault,
                            width: imgW,
                            height: imgH,
                            fit: BoxFit.contain,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          })(),

          // Text box (display only - no typing here)
          Positioned(
            left: 34,
            top: 325,
            child: SizedBox(
              width: 343,
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF727475)
                      : const Color(0xFFE8F2FB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 18.0,
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SingleChildScrollView(
                      child: Text(
                        _hasText ? _transcribedText : 'Say something...!',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: _hasText
                              ? (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black)
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Detected Mood box (only show after we have text)
          if (_hasText)
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

          // Edit button
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
        ],
      ),
    );
  }
}
