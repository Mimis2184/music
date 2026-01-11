
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';
import 'main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppThemeMode _themeMode = AppThemeMode.light;

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

  Map<String, String> get currentAssets => _themeMode == AppThemeMode.light ? lightModeAssets : darkModeAssets;

  @override
  void initState() {
    super.initState();
    RawKeyboard.instance.addListener(_handleKeyEvent);
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKeyEvent);
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.keyD) {
        setState(() {
          _themeMode = AppThemeMode.dark;
        });
      } else if (event.logicalKey == LogicalKeyboardKey.keyL) {
        setState(() {
          _themeMode = AppThemeMode.light;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moosik App',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode == AppThemeMode.light ? ThemeMode.light : ThemeMode.dark,
      home: HomeScreen(themeAssets: currentAssets, themeMode: _themeMode),
    );
  }
}
