import 'dart:async';

import 'package:baidu_ocr_plugin/src/pigeon.dart';
import 'package:flutter/services.dart';

class BaiduOcrPluginError implements Exception {
  final String message;
  BaiduOcrPluginError({
    required this.message,
  });
}

class BaiduOcrPlugin {
  static final OcrHostApi _api = OcrHostApi();

  static Future<void> initWithAkSk({
    required String ak,
    required String sk,
  }) async {
    try {
      await _api.initWithAkSk(InitWithAkSkRequestData()
        ..ak = ak
        ..sk = sk);
    } on PlatformException catch (e) {
      throw BaiduOcrPluginError(message: e.message!);
    }
  }
}
