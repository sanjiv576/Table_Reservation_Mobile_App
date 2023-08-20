import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/app.dart';
import 'core/network/local/hive_services.dart';

void main()  {
  WidgetsFlutterBinding.ensureInitialized();
   HiveService().init();
  runApp(const ProviderScope(child: App()));
}
