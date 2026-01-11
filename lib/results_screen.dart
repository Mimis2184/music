import 'package:flutter/material.dart';
import 'main.dart';


class ResultsScreen extends StatefulWidget {
  final String mood;
  final Map<String, String> themeAssets;
  final AppThemeMode themeMode;
  ResultsScreen({Key? key, required this.mood, required this.themeAssets, required this.themeMode}) : super(key: key);

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {

  void _handleOpenInSpotify() {
    // TODO: Open Spotify app or link
    print('Open in Spotify tapped');
  }

  void _handleTryAnotherMood(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _handleShare() {
    // TODO: Share functionality
    print('Share tapped');
  }

  @override
  Widget build(BuildContext context) {
    bool isTryMoodPressed = false;
    bool isSharePressed = false;
    bool isOpenSpotifyPressed = false;
    return Scaffold(
      backgroundColor: widget.themeMode == AppThemeMode.light ? const Color(0xFFFFFBF7) : const Color(0xFF312F2D),
      body: SafeArea(
        child: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height, // Responsive height to prevent overflow
              child: Stack(
                children: [
                  // ...existing code...
                  Positioned(
                    left: 356,
                    top: 33,
                    width: 29,
                    height: 29,
                    child: GestureDetector(
                      onTapDown: (_) => setState(() => isSharePressed = true),
                      onTapUp: (_) {
                        setState(() => isSharePressed = false);
                        _handleShare();
                      },
                      onTapCancel: () => setState(() => isSharePressed = false),
                      child: AnimatedScale(
                        scale: isSharePressed ? 1.12 : 1.0,
                        duration: const Duration(milliseconds: 120),
                        curve: Curves.easeOut,
                        child: Container(
                          width: 29,
                          height: 29,
                          decoration: const BoxDecoration(),
                          child: Image.network(
                            'https://www.figma.com/api/mcp/asset/fa859a6b-9365-4249-abf4-bd16d0ff4188',
                            color: isSharePressed ? const Color(0xFFD3CECE) : const Color(0xFF383737),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // ...existing code...
                  Positioned(
                    left: 55.5,
                    top: 63,
                    width: 300,
                    height: 91,
                    child: Stack(
                      children: [
                        // Header text
                        const Positioned(
                          left: 0,
                          top: 0,
                          right: 0,
                          height: 51,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Your Mood Playlist:',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF383737),
                                fontFamily: 'Arial Rounded MT Bold',
                              ),
                            ),
                          ),
                        ),
                        // Mood name (centered below)
                        Positioned(
                          left: 52,
                          top: 41,
                          width: 196,
                          height: 50,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              widget.mood + ' Vibes',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF383737),
                                fontFamily: 'Arial Rounded MT Bold',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ...existing code...
                  Positioned(
                    left: 58.5,
                    top: 164,
                    width: 294,
                    height: 79.8,
                    child: _SongCard(songName: 'Song Name 1', artist: 'Artist 1', imagePlaceholder: '??'),
                  ),
                  Positioned(
                    left: 58.5,
                    top: 267,
                    width: 294,
                    height: 79.8,
                    child: _SongCard(songName: 'Song Name 2', artist: 'Artist 2', imagePlaceholder: '??'),
                  ),
                  Positioned(
                    left: 58.5,
                    top: 369,
                    width: 294,
                    height: 79.8,
                    child: _SongCard(songName: 'Song Name 3', artist: 'Artist 3', imagePlaceholder: '??'),
                  ),
                  Positioned(
                    left: 58.5,
                    top: 471,
                    width: 294,
                    height: 79.8,
                    child: _SongCard(songName: 'Song Name 4', artist: 'Artist 4', imagePlaceholder: '??'),
                  ),
                  // ...existing code...
                  Positioned(
                    left: 73.5,
                    top: 583,
                    width: 264,
                    height: 45,
                    child: GestureDetector(
                      onTapDown: (_) => setState(() => isOpenSpotifyPressed = true),
                      onTapUp: (_) {
                        setState(() => isOpenSpotifyPressed = false);
                        _handleOpenInSpotify();
                      },
                      onTapCancel: () => setState(() => isOpenSpotifyPressed = false),
                      child: AnimatedScale(
                        scale: isOpenSpotifyPressed ? 1.03 : 1.0,
                        duration: const Duration(milliseconds: 120),
                        curve: Curves.easeOut,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 120),
                          width: 264,
                          height: 45,
                          decoration: BoxDecoration(
                            color: isOpenSpotifyPressed ? const Color(0xFF3F5F78) : const Color(0xFF5B80A4),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Open in Spotify?',
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
                  ),
                  // ...existing code...
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
                      child: AnimatedScale(
                        scale: isTryMoodPressed ? 1.08 : 1.0,
                        duration: const Duration(milliseconds: 120),
                        curve: Curves.easeOut,
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
                          ),
                        ),
                      ),
                    ),
                  ),
                  // ...existing code...
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SongCard extends StatelessWidget {
  final String songName;
  final String artist;
  final String imagePlaceholder;

  const _SongCard({
    required this.songName,
    required this.artist,
    required this.imagePlaceholder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 294,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFDBFBFF),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          // Album art placeholder
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFEFEEEE),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                imagePlaceholder,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Song info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  songName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF383737),
                    fontFamily: 'Arial Rounded MT Bold',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  artist,
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
        ],
      ),
    );
  }
}
