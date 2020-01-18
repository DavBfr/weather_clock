// Copyright (c) 2020, David PHAM-VAN. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:provider/provider.dart';
import 'package:spritewidget/spritewidget.dart';

import 'resources.dart' as resources;
import 'world.dart';

/// Main widget for the background animations
class Background extends StatefulWidget {
  const Background();

  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> with TickerProviderStateMixin {
  // Are we ready to display the background?
  bool _assetsLoaded = false;

  // The sprite tree for the weather animations
  WeatherWorld _weatherWorld;

  @override
  void initState() {
    super.initState();

    // Load all required sprites and update the state.
    resources.loadAssets(rootBundle).then((_) {
      setState(() {
        print('All assets loaded');
        _assetsLoaded = true;
        final brightness = Theme.of(context).brightness;
        _weatherWorld = WeatherWorld(
          Provider.of<ClockModel>(context, listen: false).weatherCondition,
          brightness,
        );
      });
    });
  }

  /// For debugging: restart the current scene on hot reload
  @override
  void reassemble() {
    final brightness = Theme.of(context).brightness;
    _weatherWorld = WeatherWorld(
      Provider.of<ClockModel>(context, listen: false).weatherCondition,
      brightness,
    );
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ClockModel>(context);

    // Display the current weather gradient until all assets are loaded
    if (!_assetsLoaded) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              transform: GradientRotation(pi / 2),
              colors: resources.gradientColors(
                model.weatherCondition,
                Theme.of(context).brightness,
              )),
        ),
      );
    }

    // All assets are loaded, display the animations
    _weatherWorld.weatherType = model.weatherCondition;
    _weatherWorld.brightness = Theme.of(context).brightness;

    // The content is clipped to fit into the imposed screen dimensions.
    return ClipRect(
      child: SpriteWidget(_weatherWorld),
    );
  }
}
