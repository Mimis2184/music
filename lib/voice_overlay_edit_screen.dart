import 'package:flutter/material.dart';

import 'main.dart';

class VoiceOverlayEditScreen extends StatelessWidget {
	final Map<String, String> themeAssets;
	final AppThemeMode themeMode;
	const VoiceOverlayEditScreen({super.key, required this.themeAssets, required this.themeMode});

	static const String textBoxAsset = "assets/rectangle17_figma.png";

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
										// OK button (Figma exact position)
										Positioned(
											left: 290,
											top: 305,
											child: GestureDetector(
												onTap: () => Navigator.of(context).pop(),
												child: Container(
													width: 34,
													height: 16,
													decoration: BoxDecoration(
														color: const Color(0xFF4F6678),
														borderRadius: BorderRadius.circular(7),
													),
													child: const Center(
														child: Text(
															'OK',
															style: TextStyle(
																fontFamily: 'Inter',
																fontWeight: FontWeight.w600,
																fontSize: 10,
																color: Color(0xFFD3CECE),
															),
														),
													),
												),
											),
										),
										// Cancel button (Figma exact position)
										Positioned(
											left: 331,
											top: 305,
											child: GestureDetector(
												onTap: () => Navigator.of(context).pop(),
												child: Container(
													width: 52,
													height: 16,
													decoration: BoxDecoration(
														color: const Color(0xFF4F6678),
														borderRadius: BorderRadius.circular(7),
													),
													child: const Center(
														child: Text(
															'Cancel',
															style: TextStyle(
																fontFamily: 'Inter',
																fontWeight: FontWeight.w600,
																fontSize: 10,
																color: Color(0xFFD3CECE),
															),
														),
													),
												),
											),
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
