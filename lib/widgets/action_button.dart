import 'package:flutter/material.dart';

import 'package:music/main.dart';

class ActionButton extends StatefulWidget {
  final String label;
  final Widget iconDefault;
  final Widget iconPressed;
  final bool isPressed; // persistent pressed state from parent
  final VoidCallback? onTap;
  final VoidCallback? onTapDown;
  final VoidCallback? onTapUp;
  final VoidCallback? onTapCancel;
  final double pressedScale;
  final Color? pressedColor;
  final Map<String, String>? themeAssets;
  final AppThemeMode? themeMode;

  const ActionButton({
    super.key,
    required this.label,
    required this.iconDefault,
    required this.iconPressed,
    required this.isPressed,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.pressedScale = 1.08,
    this.pressedColor,
    this.themeAssets,
    this.themeMode,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> with SingleTickerProviderStateMixin {
  bool _isPressedLocal = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressedLocal = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressedLocal = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressedLocal = false);
  }

  @override
  Widget build(BuildContext context) {
    final bool effectivePressed = widget.isPressed || _isPressedLocal;
    final double scale = effectivePressed ? widget.pressedScale : 1.0;

    Color borderColor = (widget.themeMode == AppThemeMode.dark)
        ? const Color(0xFF727475)
        : const Color(0xFFD3CECE);
    Color textColor = (widget.themeMode == AppThemeMode.dark)
        ? const Color(0xFFDBFBFF)
        : const Color(0xFF383737);

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (details) {
        _handleTapDown(details);
        if (widget.onTapDown != null) widget.onTapDown!();
      },
      onTapUp: (details) {
        _handleTapUp(details);
        if (widget.onTapUp != null) widget.onTapUp!();
      },
      onTapCancel: () {
        _handleTapCancel();
        if (widget.onTapCancel != null) widget.onTapCancel!();
      },
      child: Column(
        children: [
          AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: borderColor,
                  width: 1.5,
                ),
                color: effectivePressed
                    ? (widget.pressedColor ?? const Color(0xFFF5F5F5))
                    : Colors.transparent,
              ),
              child: Center(
                child: effectivePressed ? widget.iconPressed : widget.iconDefault,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: textColor,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
