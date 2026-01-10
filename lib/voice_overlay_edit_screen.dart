import 'package:flutter/material.dart';

class VoiceOverlayEditScreen extends StatefulWidget {
  final String initialText;

  const VoiceOverlayEditScreen({
    super.key,
    this.initialText = '',
  });

  @override
  State<VoiceOverlayEditScreen> createState() => _VoiceOverlayEditScreenState();
}

class _VoiceOverlayEditScreenState extends State<VoiceOverlayEditScreen> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleOK() {
    // Return the edited text to previous screen
    Navigator.of(context).pop(_textController.text);
  }

  void _handleCancel() {
    // Return null or original text without changes
    Navigator.of(context).pop();
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
                // Header title
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 30),
                  child: Text(
                    'moosik',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF383737),
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),

                // Prompt
                const Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Text(
                    'Tell us how you feel',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF383737),
                      fontFamily: 'Arial Rounded MT Bold',
                    ),
                  ),
                ),

                // Text editing box
                Container(
                  width: 343,
                  height: 150,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F2FB),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: _textController,
                    maxLines: 8,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Edit your text here...',
                      hintStyle: TextStyle(
                        color: Color(0xFFBBBBBB),
                        fontFamily: 'Arial Rounded MT Bold',
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF383737),
                      fontFamily: 'Arial Rounded MT Bold',
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // OK and Cancel buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: GestureDetector(
                        onTap: _handleOK,
                        child: Container(
                          width: 34,
                          height: 16,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4F6678),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'OK',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFD3CECE),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _handleCancel,
                      child: Container(
                        width: 52,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4F6678),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFD3CECE),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
