import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pocket/domain/services/services.dart';
import 'package:pocket/domain/utils/app_utils.dart';

class BootstrapService {
  static bool didInitilize = false;
  static Future<void> start(void Function() onDone) async {
    try {
      await KeyValueStorageBase.init();

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
}