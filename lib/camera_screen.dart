import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  String? detectedMood;
  bool isAnalyzing = true;

  @override
  void initState() {
    super.initState();
    // Simulate analyzing
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          detectedMood = 'Happy';
          isAnalyzing = false;
        });
      }
    });
  }

  void _handleBack() {
    Navigator.of(context).pop();
  }

  void _handleSeeSuggestions() {
    // TODO: Navigate to suggestions/results screen
    print('See Suggestions tapped');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
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
                      const SizedBox(width: 24),
                    ],
                  ),
                ),

                // Analyzing text
                if (isAnalyzing)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: Text(
                      'Analyzing your expression...',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF383737),
                        fontFamily: 'Arial Rounded MT Bold',
                      ),
                    ),
                  ),

                // Camera window
                Container(
                  width: 289,
                  height: 310,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBF7),
                    border: Border.all(
                      color: const Color(0xFF383737),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isAnalyzing ? Icons.videocam : Icons.check_circle,
                          size: 64,
                          color: isAnalyzing
                              ? const Color(0xFFD3CECE)
                              : const Color(0xFF4CAF50),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          isAnalyzing ? 'Analyzing...' : 'Ready!',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF383737),
                            fontFamily: 'Arial Rounded MT Bold',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Detected mood display
                if (detectedMood != null && !isAnalyzing)
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
        ),
      ),
    );
  }
}
