import 'package:ai_seller_assistant/screens/dashbord.dart';
import 'package:ai_seller_assistant/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  String apiKey = dotenv.env['APIKEY'] ?? '';

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Gemini.init(apiKey: apiKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Seller Assistant',
      home: FirebaseAuth.instance.currentUser != null 
       ? Dashbord()
       : LoginScreen(),
    );
  }
}
