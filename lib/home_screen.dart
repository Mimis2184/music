import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF7), // Background από Figma

      body: Padding(
        padding: const EdgeInsets.only(top: 61.0, left: 26.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // --------------------------------------------------
            // LOGO + MOOSIK TITLE (ROW)
            // --------------------------------------------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LOGO IMAGE
                Image.asset(
                  'assets/logo.png',
                  width: 174,
                  height: 174,
                ),

                const SizedBox(width: 15), // Απόσταση logo ? moosik

                // MOOSIK TEXT
                Text(
                  'moosik',
                  style: TextStyle(
                    fontFamily: "Nunito",
                    fontSize: 55,
                    fontWeight: FontWeight.w800, // ExtraBold
                    color: Color(0xFF383737),
                  ),
                ),
              ],
            ),

            // --------------------------------------------------
            // SPACING BELOW LOGO+TITLE
            // --------------------------------------------------
            const SizedBox(height: 20),

            // --------------------------------------------------
            // HOW ARE YOU FEELING TODAY
            // --------------------------------------------------
            Text(
              'How are you feeling today?',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                color: Color(0xFF383737),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


