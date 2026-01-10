import 'package:flutter/material.dart';

class VoiceOverlayScreen extends StatefulWidget {
  const VoiceOverlayScreen({super.key});

  @override
  State<VoiceOverlayScreen> createState() => _VoiceOverlayScreenState();
}

class _VoiceOverlayScreenState extends State<VoiceOverlayScreen> {
  bool isRecording = false;
  String? detectedMood;
  String transcribedText = '';

  void _handleBack() {
    Navigator.of(context).pop();
  }

  void _toggleRecording() {
    setState(() {
      isRecording = !isRecording;
      if (isRecording) {
        // TODO: Start voice recording
        // TODO: Detect mood from voice
        detectedMood = 'Happy'; // Placeholder
        transcribedText = 'This is a placeholder for transcribed text...';
      } else {
        // TODO: Stop voice recording
      }
    });
  }

  void _handleEdit() {
    // TODO: Edit transcribed text
    print('Edit tapped');
  }

  void _handleSeeSuggestions() {
    // TODO: Navigate to suggestions based on mood
    print('See Suggestions tapped');
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
                              onTap: _handleBack,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 4,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Color(0xFF383737),
                                  size: 24,
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

                      // Large microphone icon
                      GestureDetector(
                        onTap: _toggleRecording,
                        child: Container(
                          width: 124,
                          height: 124,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFE8F2FB),
                            boxShadow: isRecording
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF5B80A4)
                                          .withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(
                            Icons.mic,
                            color: const Color(0xFF4F6678),
                            size: 60,
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
                                onTap: _handleEdit,
                                child: Container(
                                  width: 34,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4F6678),
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Detected mood display
                      if (detectedMood != null)
                        Container(
                          width: 300,
                          height: 44,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F2FB),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'Detected mood: ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF383737),
                                  fontFamily: 'Arial Rounded MT Bold',
                                ),
                              ),
                              Text(
                                detectedMood!,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF615690),
                                  fontFamily: 'Arial Rounded MT Bold',
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 40),

                      // See Suggestions button
                      GestureDetector(
                        onTap: _handleSeeSuggestions,
                        child: Container(
                          width: 289,
                          height: 58,
                          decoration: BoxDecoration(
                            color: const Color(0xFF5B80A4),
                            borderRadius: BorderRadius.circular(29),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'See Suggestions?',
                            style: TextStyle(
                              color: Color(0xFFFFFBF7),
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
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
