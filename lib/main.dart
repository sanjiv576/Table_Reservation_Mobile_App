import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/app.dart';
import 'core/network/local/hive_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HiveService().init();

  /// reading .env file
  await dotenv.load(fileName: '.env');
  runApp(const ProviderScope(child: App()));
}
