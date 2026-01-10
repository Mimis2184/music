import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  void _handleOpenInSpotify() {
    // TODO: Open Spotify app or link
    print('Open in Spotify tapped');
  }

  void _handleTryAnotherMood() {
    Navigator.of(context).pop();
  }

  void _handleShare() {
    // TODO: Share functionality
    print('Share tapped');
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
                // Header
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your Mood Playlist:',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF383737),
                          fontFamily: 'Arial Rounded MT Bold',
                        ),
                      ),
                      GestureDetector(
                        onTap: _handleShare,
                        child: const Icon(
                          Icons.share,
                          color: Color(0xFF383737),
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Text(
                    'Happy Vibes',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF383737),
                      fontFamily: 'Arial Rounded MT Bold',
                    ),
                  ),
                ),

                // Song recommendations
                _SongCard(
                  songName: 'Song Name 1',
                  artist: 'Artist 1',
                  imagePlaceholder: '??',
                ),
                const SizedBox(height: 20),
                _SongCard(
                  songName: 'Song Name 2',
                  artist: 'Artist 2',
                  imagePlaceholder: '??',
                ),
                const SizedBox(height: 20),
                _SongCard(
                  songName: 'Song Name 3',
                  artist: 'Artist 3',
                  imagePlaceholder: '??',
                ),
                const SizedBox(height: 20),
                _SongCard(
                  songName: 'Song Name 4',
                  artist: 'Artist 4',
                  imagePlaceholder: '??',
                ),
                const SizedBox(height: 40),

                // Open in Spotify button
                GestureDetector(
                  onTap: _handleOpenInSpotify,
                  child: Container(
                    width: 264,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5B80A4),
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
                const SizedBox(height: 20),

                // Try another mood button
                GestureDetector(
                  onTap: _handleTryAnotherMood,
                  child: const Text(
                    'Try another mood',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF383737),
                      fontFamily: 'Arial',
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
