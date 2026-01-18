import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';
import 'results_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Centralized color tokens from Figma
class AppColors {
  // Light mode
  static const Color lightButtonColor1 = Color(0xFF5B80A4);
  static const Color lightButtonColor2 = Color(0xFFDBFBFF);
  static const Color lightSelectedMood = Color(0xFFCBB1E5);
  static const Color lightBackground = Color(0xFFFFFBF7); // #FFFBF7 for light mode
  static const Color lightDisabled = Color(0xFFD3CECE);
  static const Color lightIconAccent = Color(0xFF061B45);
  static const Color lightErrorAccent = Color(0xFFFC4E50);
  static const Color lightTextColor = Color(0xFF383737);
  static const Color lightTextColor2 = Color(0xFF615690);
  static const Color lightFillColor3 = Color(0xFFE8F2FB);
  static const Color lightBorder = Color(0xFF4F6678);

  // Dark mode
  static const Color darkButtonColor1 = Color(0xFF2D547A);
  static const Color darkButtonColor2 = Color(0xFF5B7174);
  static const Color darkSelectedMood = Color(0xFFB1BE86);
  static const Color darkBackground = Color(0xFF312F2D); // #312F2D for dark mode
  static const Color darkDisabled = Color(0xFFAEB7C4);
  static const Color darkIconAccent = Color(0xFF336BA1);
  static const Color darkErrorAccent = Color(0xFFA9191B);
  static const Color darkTextColor = Color(0xFFFFFFFF);
  static const Color darkTextColor2 = Color(0xFF9076FE);
  static const Color darkFillColor3 = Color(0xFF727475);
  static const Color darkBorder = Color(0xFF1A1835);
}

// ...existing code...

void main() {
  runApp(const MyApp());
}

enum AppThemeMode { light, dark }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Map of color asset URLs for each mode
  final Map<String, String> lightModeAssets = {
    'buttonColor1': 'https://www.figma.com/api/mcp/asset/86afdfa4-e237-4663-a16e-b541b735ed10',
    'buttonColor2': 'https://www.figma.com/api/mcp/asset/6e3d98e7-3105-44ae-ad67-a1ec1076dc00',
    'buttonColor3': 'https://www.figma.com/api/mcp/asset/59fafe6f-6105-4ba9-bd4a-de2f2799b158',
    'buttonColor4': 'https://www.figma.com/api/mcp/asset/59fafe6f-6105-4ba9-bd4a-de2f2799b158',
    'fillColor2': 'https://www.figma.com/api/mcp/asset/40223878-187e-4c55-919a-4d98287d9744',
    'textColor': 'https://www.figma.com/api/mcp/asset/4e3bdf78-5f51-4ff9-91c0-d90ee71dafd9',
    'textColor2': 'https://www.figma.com/api/mcp/asset/1465a0a7-5a87-447a-ab2c-1aa14de61a04',
    'micColor': 'https://www.figma.com/api/mcp/asset/e03d2230-a8a8-4c23-b402-2d1d7d029db2',
    'background': '',
  };
  final Map<String, String> darkModeAssets = {
    'buttonColor1': 'https://www.figma.com/api/mcp/asset/5d1bd959-4978-41e3-94bb-2633d8631212',
    'buttonColor2': 'https://www.figma.com/api/mcp/asset/5d1bd959-4978-41e3-94bb-2633d8631212',
    'buttonColor3': 'https://www.figma.com/api/mcp/asset/f11aa78a-ba9f-40ae-9bef-9a8e6a58e402',
    'buttonColor4': 'https://www.figma.com/api/mcp/asset/f11aa78a-ba9f-40ae-9bef-9a8e6a58e402',
    'fillColor2': 'https://www.figma.com/api/mcp/asset/11b0c00c-4645-4537-b7b2-588a90eed88a',
    'textColor': 'https://www.figma.com/api/mcp/asset/db468bfb-0e0e-4f2e-ae00-ad01349e8b5d',
    'textColor2': 'https://www.figma.com/api/mcp/asset/14a12772-d93f-429c-8691-3d3538d0f7dd',
    'micColor': 'https://www.figma.com/api/mcp/asset/e03d2230-a8a8-4c23-b402-2d1d7d029db2',
    'background': '',
  };

  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBackground,
        primaryColor: AppColors.lightButtonColor1,
        disabledColor: AppColors.lightDisabled,
        cardColor: AppColors.lightFillColor3,
        dividerColor: AppColors.lightBorder,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.lightTextColor),
          bodyMedium: TextStyle(color: AppColors.lightTextColor2),
        ),
      );

  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBackground,
        primaryColor: AppColors.darkButtonColor1,
        disabledColor: AppColors.darkDisabled,
        cardColor: AppColors.darkFillColor3,
        dividerColor: AppColors.darkBorder,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.darkTextColor),
          bodyMedium: TextStyle(color: AppColors.darkTextColor2),
        ),
      );


  String? _lastMood;
  bool _checkedPrefs = false;

  @override
  void initState() {
    super.initState();
    _restoreLastMood();
  }

  Future<void> _restoreLastMood() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastMood = prefs.getString('lastMood');
      _checkedPrefs = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_checkedPrefs) {
      return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
    }
    // Use system brightness to select theme assets and mode
    final brightness = MediaQuery.platformBrightnessOf(context);
    final isDark = brightness == Brightness.dark;
    final assets = isDark ? darkModeAssets : lightModeAssets;
    final themeMode = isDark ? AppThemeMode.dark : AppThemeMode.light;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moosik App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: _lastMood != null
          ? ResultsScreen(mood: _lastMood!, themeAssets: assets, themeMode: themeMode)
          : HomeScreen(themeAssets: assets, themeMode: themeMode),
    );
  }
}
