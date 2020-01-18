// Copyright (c) 2020, David PHAM-VAN. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:provider/provider.dart';

import 'screen.dart';

void main() {
  // Temporary macOS support
  if (!kIsWeb && Platform.isMacOS) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }

  runApp(
    ClockCustomizer((ClockModel model) => MainApp(model: model)),
  );
}

/// Widget that forwards ClockModel to its child using Provider
class MainApp extends StatelessWidget {
  const MainApp({@required this.model}) : assert(model != null);

  final ClockModel model;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      child: const Screen(),
    );
  }
}
