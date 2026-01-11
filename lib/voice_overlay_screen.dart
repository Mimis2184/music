import 'package:flutter/material.dart';
import 'package:music/results_screen.dart';

class VoiceOverlayScreen extends StatefulWidget {
  const VoiceOverlayScreen({super.key});

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
        builder: (context) => VoiceOverlayEditScreen(initialText: transcribedText),
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
          builder: (context) => ResultsScreen(mood: detectedMood!),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Header with back button and title
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 30),
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
                                        blurRadius: 4,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: isBackPressed ? const Color(0xFFD3CECE) : const Color(0xFF383737),
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            const Text(
                              'moosik',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF383737),
                                fontFamily: 'Nunito',
                              ),
                            ),
                            const SizedBox(width: 24), // Placeholder for balance
                          ],
                        ),
                      ),

                      // "Tell us how you feel" prompt
                      const Padding(
                        padding: EdgeInsets.only(bottom: 30),
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
                            width: 124,
                            height: 124,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isMicPressed ? const Color(0xFFFFD4D0) : const Color(0xFFE8F2FB),
                              boxShadow: isMicPressed
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF5B80A4).withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              Icons.mic,
                              color: isMicPressed ? const Color(0xFFFC4E50) : const Color(0xFF4F6678),
                              size: 60,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Transcribed text box with Edit button
                      Container(
                        width: 343,
                        height: 150,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F2FB),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Stack(
                          children: [
                            // Text content
                            Positioned(
                              left: 0,
                              top: 0,
                              right: 50,
                              bottom: 0,
                              child: SingleChildScrollView(
                                child: Text(
                                  transcribedText.isEmpty
                                      ? 'Tap the microphone to start speaking...'
                                      : transcribedText,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF383737),
                                    fontFamily: 'Arial Rounded MT Bold',
                                  ),
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
                                    width: 34,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: isEditPressed ? const Color(0xFF5B80A4) : const Color(0xFF4F6678),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Edit',
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Detected mood display (Figma exact style)
                      if (detectedMood != null && allowedMoods.contains(detectedMood))
                        Container(
                          width: 300,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F2FB),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 27,
                                top: 10,
                                child: Text(
                                  'Detected mood:',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF383737),
                                    fontFamily: 'Arial Rounded MT Bold',
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 190,
                                top: 10,
                                child: Text(
                                  detectedMood!,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF615690),
                                    fontFamily: 'Arial Rounded MT Bold',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 40),

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

class VoiceOverlayEditScreen extends StatelessWidget {
  final String initialText;

  const VoiceOverlayEditScreen({super.key, required this.initialText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Transcribed Text'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: initialText),
              maxLines: null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Edit your transcribed text here...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Handle save action
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
