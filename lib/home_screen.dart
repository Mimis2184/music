import 'package:flutter/material.dart';
import 'package:music/camera_screen.dart';
import 'package:music/voice_overlay_screen.dart';
import 'package:music/results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedMood;

  // Emoji image URLs from Figma (node 113:694)
  final String happyEmoji = "https://www.figma.com/api/mcp/asset/49bce041-d4e5-4d99-913a-489693b69a98";
  final String sadEmoji = "https://www.figma.com/api/mcp/asset/9a5fbb22-65e1-4662-909d-69fc52da8608";
  final String calmEmoji = "https://www.figma.com/api/mcp/asset/26c79ce0-7b4b-42e7-9ff3-62a49c4e1499";
  final String anxiousEmoji = "https://www.figma.com/api/mcp/asset/b9a5d021-5c74-4bc4-b30f-0b70f46770ff";
  final String romanticEmoji = "https://www.figma.com/api/mcp/asset/8aefac17-8445-4f28-bc67-b524152b6968";
  final String angryEmoji = "https://www.figma.com/api/mcp/asset/175790ec-2ebc-4df1-b694-6d6723acdd7e";
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
          builder: (context) => const ResultsScreen(),
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CameraScreen(),
      ),
    );
  }

  void _handleMicrophone() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const VoiceOverlayScreen(),
      ),
    );
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
                            _MoodButtonWithImage(
                              mood: 'Happy',
                              imageUrl: happyEmoji,
                              isSelected: selectedMood == 'Happy',
                              onPressed: () => _handleMoodSelection('Happy'),
                            ),
                            _MoodButtonWithImage(
                              mood: 'Sad',
                              imageUrl: sadEmoji,
                              isSelected: selectedMood == 'Sad',
                              onPressed: () => _handleMoodSelection('Sad'),
                            ),
                            _MoodButtonWithImage(
                              mood: 'Calm',
                              imageUrl: calmEmoji,
                              isSelected: selectedMood == 'Calm',
                              onPressed: () => _handleMoodSelection('Calm'),
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
                            _MoodButtonWithImage(
                              mood: 'Anxious',
                              imageUrl: anxiousEmoji,
                              isSelected: selectedMood == 'Anxious',
                              onPressed: () => _handleMoodSelection('Anxious'),
                            ),
                            _MoodButtonWithImage(
                              mood: 'Romantic',
                              imageUrl: romanticEmoji,
                              isSelected: selectedMood == 'Romantic',
                              onPressed: () => _handleMoodSelection('Romantic'),
                            ),
                            _MoodButtonWithImage(
                              mood: 'Angry',
                              imageUrl: angryEmoji,
                              isSelected: selectedMood == 'Angry',
                              onPressed: () => _handleMoodSelection('Angry'),
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
                            _ActionButton(
                              icon: Icons.mic,
                              label: 'Speak',
                              onPressed: _handleMicrophone,
                            ),
                            _ActionButton(
                              icon: Icons.camera_alt,
                              label: 'Camera',
                              onPressed: _handleCamera,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // See Suggestions button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 61),
                        child: GestureDetector(
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

class _MoodButtonWithImage extends StatelessWidget {
  final String mood;
  final String imageUrl;
  final bool isSelected;
  final VoidCallback onPressed;

  const _MoodButtonWithImage({
    required this.mood,
    required this.imageUrl,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 94,
        height: 102,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8D4FF) : const Color(0xFFDBFBFF),
          borderRadius: BorderRadius.circular(28),
          border: isSelected
              ? Border.all(color: const Color(0xFF5B80A4), width: 2)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF5B80A4).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Emoji image from Figma
            SizedBox(
              width: 56,
              height: 56,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to emoji text if image fails
                  return Center(
                    child: Text(
                      _getEmojiText(mood),
                      style: const TextStyle(fontSize: 40),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              mood,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF383737),
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getEmojiText(String mood) {
    switch (mood) {
      case 'Happy':
        return '??';
      case 'Sad':
        return '??';
      case 'Calm':
        return '??';
      case 'Anxious':
        return '??';
      case 'Romantic':
        return '??';
      case 'Angry':
        return '??';
      default:
        return '??';
    }
  }
}

class _MoodButton extends StatelessWidget {
  final String mood;
  final String emoji;
  final bool isSelected;
  final VoidCallback onPressed;

  const _MoodButton({
    required this.mood,
    required this.emoji,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 94,
        height: 102,
        decoration: BoxDecoration(
          color: const Color(0xFFDBFBFF),
          borderRadius: BorderRadius.circular(28),
          border: isSelected
              ? Border.all(color: const Color(0xFF5B80A4), width: 2)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF5B80A4).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 8),
            Text(
              mood,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF383737),
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFD3CECE),
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFD3CECE),
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF383737),
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
