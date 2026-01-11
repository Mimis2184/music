import 'package:flutter/material.dart';

class MoodButton extends StatelessWidget {
  final String label;
  final String defaultEmojiUrl;
  final String pressedEmojiUrl;
  final bool isSelected;
  final VoidCallback onTap;
  final double width;
  final double height;

  const MoodButton({
    super.key,
    required this.label,
    required this.defaultEmojiUrl,
    required this.pressedEmojiUrl,
    required this.isSelected,
    required this.onTap,
    this.width = 94,
    this.height = 102,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            // Background container
            Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFCBB1E5) // Purple when selected
                    : const Color(0xFFDBFBFF), // Light blue when not selected
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            // Inner shadow effect when selected/pressed
            if (isSelected)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: const Offset(0, 4),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            // Emoji icon
            Positioned(
              left: width * 0.2021,
              top: height * 0.098,
              width: width * 0.5958,
              height: height * 0.3529,
              child: Image.network(
                isSelected ? pressedEmojiUrl : defaultEmojiUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.emoji_emotions,
                    color: Colors.grey,
                  );
                },
              ),
            ),
            // Label text
            Positioned(
              left: 0,
              right: 0,
              bottom: height * 0.108,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color(0xFF383737),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
