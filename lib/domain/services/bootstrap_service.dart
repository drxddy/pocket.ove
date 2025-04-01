import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocket/domain/services/services.dart';
import 'package:pocket/domain/utils/app_utils.dart';

class BootstrapService {
  static bool didInitilize = false;
  static Future<void> start(void Function() onDone) async {
    try {
      await KeyValueStorageBase.init();

      setStatusBarColor();
      setPreferredOrientation();

      didInitilize = true;

      onDone();
    } catch (err, st) {
      AppUtils.logError(err, st);
      exitGracefully();
    }
  }

  static void exitGracefully() async {
    didInitilize = false;
    // close the app
    if (Platform.isAndroid) {
      exit(0);
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  static void setPreferredOrientation() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  static void setStatusBarColor() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarColor: Colors.black.withOpacity(0.002)));
  }
}
