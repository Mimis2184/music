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
  // Local Figma asset
  static const String shareIconProto = 'assets/share_icon_proto.png';

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
    bool isOpenSpotifyPressed = false;
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF7),
      body: Stack(
        children: [
          // Share button (Figma asset)
          Positioned(
            left: 356,
            top: 33,
            width: 29,
            height: 29,
            child: GestureDetector(
              onTap: _handleShare,
              child: Container(
                width: 29,
                height: 29,
                decoration: const BoxDecoration(),
                child: Image.asset(
                  shareIconProto,
                  fit: BoxFit.contain,
                ),
              ),
            ),
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
          // Open in Spotify button (Figma style)
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
              child: Container(
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
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
