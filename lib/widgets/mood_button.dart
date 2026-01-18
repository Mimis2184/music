import 'package:flutter/material.dart';

import 'package:music/main.dart';

class MoodButton extends StatelessWidget {
  final String label;
  final String defaultEmojiUrl;
  final String pressedEmojiUrl;
  final bool isSelected;
  final VoidCallback onTap;
  final double width;
  final double height;
  final Map<String, String>? themeAssets;
  final AppThemeMode? themeMode;

  const MoodButton({
    super.key,
    required this.label,
    required this.defaultEmojiUrl,
    required this.pressedEmojiUrl,
    required this.isSelected,
    required this.onTap,
    this.width = 94,
    this.height = 102,
    this.themeAssets,
    this.themeMode,
  });

  @override
  Widget build(BuildContext context) {
    // Use theme assets for background if provided
    Color? bgColor;
    if (themeMode != null && themeAssets != null) {
      if (themeMode == AppThemeMode.light) {
        bgColor = isSelected ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.secondaryContainer;
      } else {
        bgColor = isSelected ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.secondaryContainer;
      }
    } else {
      bgColor = isSelected ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.secondaryContainer;
    }

    Color textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

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
                color: bgColor,
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
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
