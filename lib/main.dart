
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'presentation/screens/home_screen.dart';
import 'app_theme.dart';
import 'data/providers/chat_provider.dart'; // Import the new ChatProvider

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(
    // Wrap the app with ChangeNotifierProvider
    ChangeNotifierProvider(
      create: (context) => ChatProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeepSeek AI',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false, // Optional: hide the debug banner
    );
  }
}
