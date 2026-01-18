import 'package:flutter/material.dart';

import 'main.dart';

class ResultsScreen extends StatefulWidget {
  final String mood;
  final Map<String, String> themeAssets;
  final AppThemeMode themeMode;
  const ResultsScreen({super.key, required this.mood, required this.themeAssets, required this.themeMode});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  // Share button assets
  static const String shareDefault = 'assets/sharebutton_default.png';
  static const String sharePressed = 'assets/sharebutton_pressed.png';

  void _handleOpenInSpotify() {
    // TODO: Open Spotify app or link
  }

  void _handleTryAnotherMood(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _handleShare() {
    // TODO: Share functionality
  }

  @override
  Widget build(BuildContext context) {
    bool isTryMoodPressed = false;
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF7),
      body: Stack(
        children: [
          // Share button (image asset, changes on press)
          Positioned(
            left: 356,
            top: 33,
            width: 29,
            height: 29,
            child: _ShareButton(onPressed: _handleShare),
          ),
          // Try another mood button
          Positioned(
            left: 140.5,
            top: 644,
            width: 130,
            height: 23,
            child: GestureDetector(
              onTapDown: (_) => setState(() => isTryMoodPressed = true),
              onTapUp: (_) {
                setState(() => isTryMoodPressed = false);
                _handleTryAnotherMood(context);
              },
              onTapCancel: () => setState(() => isTryMoodPressed = false),
              child: Container(
                width: 130,
                height: 23,
                alignment: Alignment.center,
                child: Text(
                  'Try another mood',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: isTryMoodPressed ? const Color(0xFFD3CECE) : const Color(0xFF383737),
                    fontFamily: 'Arial',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          // Header and mood name (Figma style)
          Positioned(
            left: 55.5,
            top: 63,
            width: 300,
            height: 91,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 51,
                  child: Text(
                    'Your Mood Playlist:',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF383737),
                      fontFamily: 'Arial Rounded MT Bold',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: Center(
                    child: Text(
                      '${widget.mood} Vibes',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF383737),
                        fontFamily: 'Arial Rounded MT Bold',
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Song cards (Figma style)
          Positioned(
            left: 58.5,
            top: 164,
            width: 294,
            height: 79.8,
            child: _FigmaSongCard(songName: 'Song Name 1', artist: 'Artist 1'),
          ),
          Positioned(
            left: 58.5,
            top: 267,
            width: 294,
            height: 79.8,
            child: _FigmaSongCard(songName: 'Song Name 2', artist: 'Artist 2'),
          ),
          Positioned(
            left: 58.5,
            top: 369,
            width: 294,
            height: 79.8,
            child: _FigmaSongCard(songName: 'Song Name 3', artist: 'Artist 3'),
          ),
          Positioned(
            left: 58.5,
            top: 471,
            width: 294,
            height: 79.8,
            child: _FigmaSongCard(songName: 'Song Name 4', artist: 'Artist 4'),
          ),
          // Open in Spotify button (image asset, changes on press)
          Positioned(
            left: 73.5,
            top: 583,
            width: 264,
            height: 45,
            child: _SpotifyButton(onPressed: _handleOpenInSpotify),
          ),
        ],
      ),
    );
  }
}

// Custom Share Button widget (must be outside the class)
class _ShareButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _ShareButton({required this.onPressed});

  @override
  State<_ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<_ShareButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: SizedBox(
        width: 29,
        height: 29,
        child: Image.asset(
          _pressed ? _ResultsScreenState.sharePressed : _ResultsScreenState.shareDefault,
          width: 29,
          height: 29,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

// Custom Spotify Button widget (must be outside the class)
class _SpotifyButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _SpotifyButton({required this.onPressed});

  @override
  State<_SpotifyButton> createState() => _SpotifyButtonState();
}

class _SpotifyButtonState extends State<_SpotifyButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: SizedBox(
        width: 264,
        height: 45,
        child: Image.asset(
          _pressed ? 'assets/spotifypressed.png' : 'assets/spotifydefault.png',
          width: 264,
          height: 45,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// Figma style song card

// Figma node 23:38 style song card
class _FigmaSongCard extends StatelessWidget {
  final String songName;
  final String artist;
  const _FigmaSongCard({required this.songName, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 294,
      height: 79.8,
      decoration: BoxDecoration(
        color: const Color(0xFFDBFBFF),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          // Album art placeholder (no icon, just a blank rounded rectangle)
          Positioned(
            left: 15,
            top: 13,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFEFEEEE),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          // Song name
          Positioned(
            left: 100,
            top: 13,
            child: SizedBox(
              width: 170,
              child: Text(
                songName,
                style: const TextStyle(
                  fontFamily: 'Arial Rounded MT Bold',
                  fontSize: 20,
                  color: Color(0xFF383737),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // Artist name
          Positioned(
            left: 100,
            top: 40,
            child: SizedBox(
              width: 170,
              child: Text(
                artist,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color(0xFF383737),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
