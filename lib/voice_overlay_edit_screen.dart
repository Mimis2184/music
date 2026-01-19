import 'package:flutter/material.dart';

import 'main.dart';

class VoiceOverlayEditScreen extends StatefulWidget {
	final Map<String, String> themeAssets;
	final AppThemeMode themeMode;
	final String initialText;
	const VoiceOverlayEditScreen({super.key, required this.themeAssets, required this.themeMode, required this.initialText});

	@override
	State<VoiceOverlayEditScreen> createState() => _VoiceOverlayEditScreenState();
}

class _VoiceOverlayEditScreenState extends State<VoiceOverlayEditScreen> {
		void _onOkPressed() {
			Navigator.of(context).pop({'text': _mirroredText, 'mood': _detectedMood});
		}
	static const String textBoxAsset = "assets/bluetextbox.png";
	final TextEditingController _controller = TextEditingController();
	String _mirroredText = '';
	String _detectedMood = 'Happy';

	void _onCancelPressed() {
		Navigator.of(context).pop();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Theme.of(context).scaffoldBackgroundColor,
			body: Stack(
				children: [
					// Camera window (bordered box)
					Positioned(
						left: 57,
						top: 151,
						child: Container(
							width: 289,
							height: 310,
							decoration: BoxDecoration(
								color: Theme.of(context).scaffoldBackgroundColor,
								border: Border.all(color: Theme.of(context).dividerColor, width: 2),
								borderRadius: BorderRadius.circular(16),
							),
						),
					),
					// Tell us how you feel
					Positioned(
						left: 91.5,
						top: 106,
						child: SizedBox(
							width: 228,
							height: 29,
							child: Center(
								child: Text(
									'Tell us how you feel',
									style: TextStyle(
										fontFamily: 'Arial Rounded MT Bold',
										fontWeight: FontWeight.w400,
										fontSize: 24,
										color: Theme.of(context).textTheme.bodyLarge?.color,
									),
									textAlign: TextAlign.center,
								),
							),
						),
					),
					// Editable grey TextField (autofocus)
					Positioned(
						left: 57,
						top: 176,
						child: Container(
							width: 289,
							height: 44,
							decoration: BoxDecoration(
								color: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).colorScheme.surface,
								borderRadius: BorderRadius.circular(12),
							),
							child: TextField(
								controller: _controller,
								autofocus: true,
								maxLines: 2,
								style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.bodyLarge?.color),
								decoration: const InputDecoration(
									border: InputBorder.none,
									contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
									hintText: 'Type here...',
								),
							),
						),
					),
					// Blue box (mirrors text live)
					Positioned(
						left: 34,
						top: 230,
						child: SizedBox(
							width: 343,
							height: 150,
							child: Container(
								decoration: BoxDecoration(
									color: const Color(0xFFE8F2FB),
									borderRadius: BorderRadius.circular(16),
								),
								padding: const EdgeInsets.all(20),
								child: Align(
									alignment: Alignment.topLeft,
									child: Text(
										_mirroredText,
										style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.bodyLarge?.color),
										maxLines: 5,
										overflow: TextOverflow.ellipsis,
									),
								),
							),
						),
					),
					// Detected mood display (optional, for debugging)
					// Positioned(
					//   left: 57,
					//   top: 390,
					//   child: Text('Detected mood: $_detectedMood'),
					// ),
					// OK button
					Positioned(
						left: 290,
						top: 305,
						child: _OkButton(onPressed: _onOkPressed),
					),
					// Cancel button
					Positioned(
						left: 331,
						top: 305,
						child: _CancelButton(onPressed: _onCancelPressed),
					),
					// Moosik logo (small, text only)
					Positioned(
						left: 145,
						top: 21,
						child: SizedBox(
							width: 122,
							height: 49,
							child: Center(
								child: Text(
									'moosik',
									style: TextStyle(
										fontFamily: 'Nunito',
										fontWeight: FontWeight.w800,
										fontSize: 36,
										color: Theme.of(context).textTheme.bodyLarge?.color,
									),
								),
							),
						),
					),
				],
			),
		);
	}
}

// Custom OK Button widget (must be outside the class)
class _OkButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _OkButton({required this.onPressed});

  @override
  State<_OkButton> createState() => _OkButtonState();
}

class _OkButtonState extends State<_OkButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: SizedBox(
        width: 34,
        height: 16,
        child: Image.asset(
          _pressed ? 'assets/ok_pressed.png' : 'assets/ok_default.png',
          width: 34,
          height: 16,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// Custom Cancel Button widget (must be outside the class)
class _CancelButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _CancelButton({required this.onPressed});

  @override
  State<_CancelButton> createState() => _CancelButtonState();
}

class _CancelButtonState extends State<_CancelButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: SizedBox(
        width: 52,
        height: 16,
        child: Image.asset(
          _pressed ? 'assets/cancel_pressed.png' : 'assets/canceldefault.png',
          width: 52,
          height: 16,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
