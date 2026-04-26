import 'package:flutter/material.dart';

import 'package:ondas_web/app/app.dart';
import 'package:ondas_web/core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const OndasApp());
}


