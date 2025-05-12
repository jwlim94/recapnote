import 'package:dart_openai/dart_openai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recapnote/env/env.dart';
import 'package:recapnote/firebase_options.dart';
import 'package:recapnote/src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set API Keys
  OpenAI.apiKey = Env.openAIAPIKey;

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize the app with ProviderScope for Riverpod state management
  runApp(const ProviderScope(child: App()));
}
