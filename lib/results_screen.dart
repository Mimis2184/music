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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            final baseWidth = 411.0;
            final baseHeight = 731.0;
            final scaleW = screenWidth / baseWidth;
            final scaleH = screenHeight / baseHeight;
            return SingleChildScrollView(
              child: SizedBox(
                height: screenHeight,
                child: Stack(
                  children: [
                    // Share button
                    Positioned(
                      left: 356 * scaleW,
                      top: 33 * scaleH,
                      width: 29 * scaleW,
                      height: 29 * scaleH,
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
                            width: 29 * scaleW,
                            height: 29 * scaleH,
                            decoration: const BoxDecoration(),
                            child: Image.network(
                              'https://www.figma.com/api/mcp/asset/fa859a6b-9365-4249-abf4-bd16d0ff4188',
                              color: isSharePressed ? const Color(0xFFD3CECE) : const Color(0xFF383737),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Header and mood name
                    Positioned(
                      left: 55.5 * scaleW,
                      top: 63 * scaleH,
                      width: 300 * scaleW,
                      height: 91 * scaleH,
                      child: Stack(
                        children: [
                          // Header text
                          Positioned(
                            left: 0,
                            top: 0,
                            right: 0,
                            height: 51 * scaleH,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Your Mood Playlist:',
                                style: TextStyle(
                                  fontSize: 32 * scaleW,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF383737),
                                  fontFamily: 'Arial Rounded MT Bold',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          // Mood name (centered below)
                          Positioned(
                            left: 52 * scaleW,
                            top: 41 * scaleH,
                            width: 196 * scaleW,
                            height: 50 * scaleH,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '${widget.mood} Vibes',
                                style: TextStyle(
                                  fontSize: 32 * scaleW,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF383737),
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
                    // Song cards
                    Positioned(
                      left: 58.5 * scaleW,
                      top: 164 * scaleH,
                      width: 294 * scaleW,
                      height: 79.8 * scaleH,
                      child: _SongCard(songName: 'Song Name 1', artist: 'Artist 1', imagePlaceholder: '??', scaleW: scaleW, scaleH: scaleH),
                    ),
                    Positioned(
                      left: 58.5 * scaleW,
                      top: 267 * scaleH,
                      width: 294 * scaleW,
                      height: 79.8 * scaleH,
                      child: _SongCard(songName: 'Song Name 2', artist: 'Artist 2', imagePlaceholder: '??', scaleW: scaleW, scaleH: scaleH),
                    ),
                    Positioned(
                      left: 58.5 * scaleW,
                      top: 369 * scaleH,
                      width: 294 * scaleW,
                      height: 79.8 * scaleH,
                      child: _SongCard(songName: 'Song Name 3', artist: 'Artist 3', imagePlaceholder: '??', scaleW: scaleW, scaleH: scaleH),
                    ),
                    Positioned(
                      left: 58.5 * scaleW,
                      top: 471 * scaleH,
                      width: 294 * scaleW,
                      height: 79.8 * scaleH,
                      child: _SongCard(songName: 'Song Name 4', artist: 'Artist 4', imagePlaceholder: '??', scaleW: scaleW, scaleH: scaleH),
                    ),
                    // Open in Spotify button
                    Positioned(
                      left: 73.5 * scaleW,
                      top: 583 * scaleH,
                      width: 264 * scaleW,
                      height: 45 * scaleH,
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
                            width: 264 * scaleW,
                            height: 45 * scaleH,
                            decoration: BoxDecoration(
                              color: isOpenSpotifyPressed ? const Color(0xFF3F5F78) : const Color(0xFF5B80A4),
                              borderRadius: BorderRadius.circular(50 * scaleW),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Open in Spotify?',
                              style: TextStyle(
                                color: const Color(0xFFFFFBF7),
                                fontSize: 22 * scaleW,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Try another mood button
                    Positioned(
                      left: 140.5 * scaleW,
                      top: 644 * scaleH,
                      width: 130 * scaleW,
                      height: 23 * scaleH,
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
                            width: 130 * scaleW,
                            height: 23 * scaleH,
                            alignment: Alignment.center,
                            child: Text(
                              'Try another mood',
                              style: TextStyle(
                                fontSize: 16 * scaleW,
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
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SongCard extends StatelessWidget {
  final String songName;
  final String artist;
  final String imagePlaceholder;
  final double scaleW;
  final double scaleH;

  const _SongCard({
    required this.songName,
    required this.artist,
    required this.imagePlaceholder,
    required this.scaleW,
    required this.scaleH,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 294 * scaleW,
      padding: EdgeInsets.all(16 * scaleW),
      decoration: BoxDecoration(
        color: const Color(0xFFDBFBFF),
        borderRadius: BorderRadius.circular(15 * scaleW),
      ),
      child: Row(
        children: [
          // Album art placeholder
          Container(
            width: 70 * scaleW,
            height: 70 * scaleH,
            decoration: BoxDecoration(
              color: const Color(0xFFEFEEEE),
              borderRadius: BorderRadius.circular(15 * scaleW),
            ),
            child: Center(
              child: Text(
                imagePlaceholder,
                style: TextStyle(fontSize: 32 * scaleW),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(width: 16 * scaleW),
          // Song info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  songName,
                  style: TextStyle(
                    fontSize: 20 * scaleW,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF383737),
                    fontFamily: 'Arial Rounded MT Bold',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8 * scaleH),
                Text(
                  artist,
                  style: TextStyle(
                    fontSize: 16 * scaleW,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF383737),
                    fontFamily: 'Inter',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
