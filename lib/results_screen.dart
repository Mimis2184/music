import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
//import 'package:nfc_manager/nfc_manager.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';
import 'home_screen.dart';
import 'app_state.dart';

// Open in Spotify button assets (background only, no text)
const String openSpotifyBgDefault = 'assets/spotifydefault.png';
const String openSpotifyBgPressed = 'assets/spotifypressed.png';

class ResultsScreen extends StatefulWidget {
  final String mood;
  final Map<String, String> themeAssets;
  final AppThemeMode themeMode;
  const ResultsScreen({
    super.key,
    required this.mood,
    required this.themeAssets,
    required this.themeMode,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  // Share button assets
  static const String shareDefault = 'assets/sharebutton_default.png';
  static const String sharePressed = 'assets/sharebutton_pressed.png';

  bool _isTryMoodPressed = false;

  /* ================= NFC SHARE ================= */

  // NOTE:
  // Εδώ κρατάμε το "παλιό" NFC writing implementation ως σχόλια.
  // Το αφαιρέσαμε από dependencies γιατί έσπαγε το release build (Kotlin compile issue).
  // Αν το ξαναβάλετε στο μέλλον, κάνετε uncomment import + function + κουμπί.
  //
  //Future<void> _shareViaNfc() async {
  //  final available = await NfcManager.instance.isAvailable();
  //  if (!available) {
  //    _showSnack('NFC not available on this device');
  //    return;
  //  }
  //
  //  _showSnack('Touch another phone to share playlist');
  //
  //  final uri = Uri.parse('https://moosik.app/playlist?mood=${widget.mood}');
  //
  //  NfcManager.instance.startSession(
  //    onDiscovered: (tag) async {
  //      try {
  //        final ndef = Ndef.from(tag);
  //        if (ndef == null || !ndef.isWritable) {
  //          _showSnack('NFC tag not writable');
  //          return;
  //        }
  //
  //        final message = NdefMessage([NdefRecord.createUri(uri)]);
  //
  //        await ndef.write(message);
  //        _showSnack('Playlist shared via NFC!');
  //      } catch (_) {
  //        _showSnack('NFC write failed');
  //      } finally {
  //        NfcManager.instance.stopSession();
  //      }
  //    },
  //  );
  //}

  // “Σύγχρονη” υλοποίηση Axis 3 (χωρίς NFC plugin):
  // Μοιραζόμαστε deep-link URL. Αν η εφαρμογή είναι εγκατεστημένη ανοίγει ResultsScreen,
  // αλλιώς (θεωρητικά) θα οδηγούσε σε Play Store / website.
  void _handleTapToOpenShare() {
    final link = Uri.parse(
      'https://moosik.app/playlist?mood=${Uri.encodeComponent(widget.mood)}',
    ).toString();

    Share.share(link, subject: 'Moosik Tap-to-open');
  }

  void _showSnack(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  /* ================= SPOTIFY ================= */

  void _handleOpenInSpotify() async {
    String url = '';
    if (widget.mood == 'Happy') {
      url =
          'https://open.spotify.com/playlist/4Fh0313D3PitYzICKHhZ7r?si=32b6fb1eede94416';
    } else if (widget.mood == 'Sad') {
      url =
          'https://open.spotify.com/album/2N1ab00YnjAe9TBxtg7YGx?si=_XOELIsgSouVVf19QZNqaQ';
    } else if (widget.mood == 'Calm') {
      url =
          'https://open.spotify.com/playlist/4hRuPiX2bzpPzfVTqVCrRe?si=96f0ddd76f264308';
    } else if (widget.mood == 'Angry') {
      url =
          'https://open.spotify.com/playlist/1rxPW5NOclEZX9V1mxwd0i?si=09ac684f8c0949bd';
    } else if (widget.mood == 'Romantic') {
      url =
          'https://open.spotify.com/playlist/37i9dQZF1EVGJJ3r00UGAt?si=7c4d556fe4af4d27';
    } else if (widget.mood == 'Anxious') {
      url =
          'https://open.spotify.com/playlist/1OvEwx07iqXhhDVB4AlVmo?si=d483e9244c2b46b7';
    }

    if (url.isEmpty) return;

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  Future<void> _handleTryAnotherMood(BuildContext context) async {
    await context.read<AppState>().setMood(null);

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          themeAssets: widget.themeAssets,
          themeMode: widget.themeMode,
        ),
      ),
      (route) => false,
    );
  }

  void _handleShare() {
    String url = '';
    if (widget.mood == 'Happy') {
      url =
          'https://open.spotify.com/playlist/4Fh0313D3PitYzICKHhZ7r?si=32b6fb1eede94416';
    } else if (widget.mood == 'Sad') {
      url =
          'https://open.spotify.com/album/2N1ab00YnjAe9TBxtg7YGx?si=_XOELIsgSouVVf19QZNqaQ';
    } else if (widget.mood == 'Calm') {
      url =
          'https://open.spotify.com/playlist/4hRuPiX2bzpPzfVTqVCrRe?si=96f0ddd76f264308';
    } else if (widget.mood == 'Angry') {
      url =
          'https://open.spotify.com/playlist/1rxPW5NOclEZX9V1mxwd0i?si=09ac684f8c0949bd';
    } else if (widget.mood == 'Romantic') {
      url =
          'https://open.spotify.com/playlist/37i9dQZF1EVGJJ3r00UGAt?si=7c4d556fe4af4d27';
    } else if (widget.mood == 'Anxious') {
      url =
          'https://open.spotify.com/playlist/1OvEwx07iqXhhDVB4AlVmo?si=d483e9244c2b46b7';
    }

    if (url.isNotEmpty) {
      Share.share(url, subject: 'Moosik playlist');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // 🔹 "Tap-to-open" button (TOP RIGHT, δίπλα στο Share)
          // Στο UI το δείχνουμε ως NFC-icon, αλλά λειτουργικά κάνει share deep link.
          Positioned(
            left: 320, // δίπλα στο share (share είναι 356)
            top: 33,
            width: 29,
            height: 29,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.nfc,
                size: 24,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              onPressed: _handleTapToOpenShare,
              tooltip: 'Tap-to-open share',
            ),
          ),

          // Share button
          Positioned(
            left: 356,
            top: 33,
            width: 29,
            height: 29,
            child: _ShareButton(onPressed: _handleShare),
          ),

          // --------- ΟΛΑ ΤΑ ΥΠΟΛΟΙΠΑ ΜΕΝΟΥΝ ΑΚΡΙΒΩΣ ΙΔΙΑ ---------

          // Try another mood button
          Positioned(
            left: 140.5,
            top: 644,
            width: 130,
            height: 23,
            child: GestureDetector(
              onTapDown: (_) => setState(() => _isTryMoodPressed = true),
              onTapUp: (_) {
                setState(() => _isTryMoodPressed = false);
                _handleTryAnotherMood(context);
              },
              onTapCancel: () => setState(() => _isTryMoodPressed = false),
              child: Container(
                width: 130,
                height: 23,
                alignment: Alignment.center,
                child: Text(
                  'Try another mood',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: _isTryMoodPressed
                        ? Theme.of(context).disabledColor
                        : Theme.of(context).textTheme.bodyLarge?.color,
                    fontFamily: 'Arial',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),

          // Header and mood name
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
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
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
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
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
          if (widget.mood == 'Happy') ...[
            Positioned(
              left: 58.5,
              top: 164,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(
                songName: 'Sunroof',
                artist: 'Nicky Youre, hey daisyy',
              ),
            ),
            Positioned(
              left: 58.5,
              top: 267,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(
                songName: 'Espresso',
                artist: 'Sabrina Carpenter',
              ),
            ),
            Positioned(
              left: 58.5,
              top: 369,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(
                songName: 'HOT TO GO!',
                artist: 'Chappell Roan',
              ),
            ),
            Positioned(
              left: 58.5,
              top: 471,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(
                songName: 'CAN\'T STOP THE FEELING!',
                artist: 'Justin Timberlake',
              ),
            ),
          ] else if (widget.mood == 'Sad') ...[
            Positioned(
              left: 58.5,
              top: 164,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(songName: 'Breathe Me', artist: 'Sia'),
            ),
            Positioned(
              left: 58.5,
              top: 267,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(
                songName: 'Stone Cold',
                artist: 'Demi Lovato',
              ),
            ),
            Positioned(
              left: 58.5,
              top: 369,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(
                songName: 'Read All About It, Pt. III',
                artist: 'Emeli Sand?',
              ),
            ),
            Positioned(
              left: 58.5,
              top: 471,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(
                songName: 'Beautiful Scars',
                artist: 'Maximillian',
              ),
            ),
          ] else if (widget.mood == 'Calm') ...[
            Positioned(
              left: 58.5,
              top: 164,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(
                songName: 'Matches',
                artist: 'Cash Cash, ROZES',
              ),
            ),
            Positioned(
              left: 58.5,
              top: 267,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(
                songName: 'Congratulations',
                artist: 'Post Malone, Quavo',
              ),
            ),
            Positioned(
              left: 58.5,
              top: 369,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(songName: 'Passionfruit', artist: 'Drake'),
            ),
            Positioned(
              left: 58.5,
              top: 471,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(songName: 'Location', artist: 'Khalid'),
            ),
          ] else if (widget.mood == 'Angry') ...[
            Positioned(
              left: 58.5,
              top: 164,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(
                songName: 'abcdefu (angrier)',
                artist: 'GAYLE',
              ),
            ),
            Positioned(
              left: 58.5,
              top: 267,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(
                songName: 'this is what heartbreak feels like',
                artist: 'JVKE',
              ),
            ),
            Positioned(
              left: 58.5,
              top: 369,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(songName: 'IDGAF', artist: 'Dua Lipa'),
            ),
            Positioned(
              left: 58.5,
              top: 471,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(
                songName: '10 Things I Hate About You',
                artist: 'Leah Kate',
              ),
            ),
          ] else if (widget.mood == 'Romantic') ...[
            Positioned(
              left: 58.5,
              top: 164,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(
                songName: 'Help Yourself to Me',
                artist: 'Madrugada',
              ),
            ),
            Positioned(
              left: 58.5,
              top: 267,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(
                songName: 'Fill The Void (with Lily Rose Depp, Ramsey)',
                artist: 'The Weeknd, Lily-Rose Depp, Ramsey',
              ),
            ),
            Positioned(
              left: 58.5,
              top: 369,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(
                songName: 'Visions of Gideon',
                artist: 'Sufjan Stevens',
              ),
            ),
            Positioned(
              left: 58.5,
              top: 471,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(songName: 'LOVE YOU LESS', artist: 'Joji'),
            ),
          ] else if (widget.mood == 'Anxious') ...[
            Positioned(
              left: 58.5,
              top: 164,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(
                songName: 'Every Little Cell - Equanimous Edit',
                artist: 'The Great Medicine Show, Naya, Equanimous',
              ),
            ),
            Positioned(
              left: 58.5,
              top: 267,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(
                songName: 'Holding Space',
                artist: 'Mayyadda',
              ),
            ),
            Positioned(
              left: 58.5,
              top: 369,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(
                songName: 'Sharing an Umbrella',
                artist: 'Hentaidesu',
              ),
            ),
            Positioned(
              left: 58.5,
              top: 471,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(
                songName: "I'll Keep You Safe",
                artist: 'sagun, Shiloh Dynasty',
              ),
            ),
          ] else ...[
            Positioned(
              left: 58.5,
              top: 164,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(
                songName: 'Song Name 1',
                artist: 'Artist 1',
              ),
            ),
            Positioned(
              left: 58.5,
              top: 267,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(
                songName: 'Song Name 2',
                artist: 'Artist 2',
              ),
            ),
            Positioned(
              left: 58.5,
              top: 369,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(
                songName: 'Song Name 3',
                artist: 'Artist 3',
              ),
            ),
            Positioned(
              left: 58.5,
              top: 471,
              width: 294,
              height: 79.8,
              child: _FigmaSongCard(
                songName: 'Song Name 4',
                artist: 'Artist 4',
              ),
            ),
          ],

          // Open in Spotify button
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

// Custom Share Button widget
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
          _pressed
              ? _ResultsScreenState.sharePressed
              : _ResultsScreenState.shareDefault,
          width: 29,
          height: 29,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

// Custom Spotify Button widget
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
    final isLight = Theme.of(context).brightness == Brightness.light;

    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Image.asset(
              _pressed ? openSpotifyBgPressed : openSpotifyBgDefault,
              width: 264,
              height: 52,
              fit: BoxFit.cover,
              color: isLight ? null : Theme.of(context).primaryColor,
              colorBlendMode: isLight ? null : BlendMode.srcATop,
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Text(
                'Open in Spotify ->',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  letterSpacing: 0.5,
                  color: isLight
                      ? Colors.transparent
                      : Theme.of(context).scaffoldBackgroundColor,
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
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 15,
            top: 13,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          Positioned(
            left: 100,
            top: 13,
            child: SizedBox(
              width: 170,
              child: Text(
                songName,
                style: TextStyle(
                  fontFamily: 'Arial Rounded MT Bold',
                  fontSize: 20,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Positioned(
            left: 100,
            top: 40,
            child: SizedBox(
              width: 170,
              child: Text(
                artist,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
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
