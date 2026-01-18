import 'package:flutter/material.dart';

import 'main.dart';

class VoiceOverlayEditScreen extends StatelessWidget {
	final Map<String, String> themeAssets;
	final AppThemeMode themeMode;
	const VoiceOverlayEditScreen({super.key, required this.themeAssets, required this.themeMode});

	static const String textBoxAsset = "assets/bluetextbox.png";

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: const Color(0xFFFFFBF7),
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
								color: const Color(0xFFFFFBF7),
								border: Border.all(color: const Color(0xFF383737), width: 2),
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
									child: const Center(
											child: Text(
													'Tell us how you feel',
													style: TextStyle(
															fontFamily: 'Arial Rounded MT Bold',
															fontWeight: FontWeight.w400,
															fontSize: 24,
															color: Color(0xFF383737),
													),
													textAlign: TextAlign.center,
											),
									),
							),
					),
					// Text box (background image)
					Positioned(
							left: 34,
							top: 176,
							child: SizedBox(
									width: 343,
									height: 150,
									child: ClipRRect(
											borderRadius: BorderRadius.circular(16),
											child: Image.asset(textBoxAsset, fit: BoxFit.cover),
									),
							),
					),
										// OK button (image asset, changes on press)
										Positioned(
										  left: 290,
										  top: 305,
										  child: _OkButton(onPressed: () => Navigator.of(context).pop()),
										),
										// Cancel button (image asset, changes on press)
										Positioned(
										  left: 331,
										  top: 305,
										  child: _CancelButton(onPressed: () => Navigator.of(context).pop()),
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
										color: Color(0xFF383737),
									),
								),
							),
						),
					),
					// System keyboard placeholder (gray box)
					Positioned(
						left: -1,
						top: 396,
						child: Container(
							width: 411,
							height: 335,
							color: const Color(0xFFD9D9D9),
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
