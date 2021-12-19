import 'dart:async';

import 'package:flutter/services.dart';

import 'src/entity/id_card_result.dart';
import 'src/pigeon.dart';
import 'src/recognize_callback_handler.dart';
import 'src/recognize_flutter_api_impl.dart';

export 'src/entity/id_card_result.dart';
export 'src/recognize_callback_handler.dart';

class BaiduOcrPluginError implements Exception {
  final String message;
  BaiduOcrPluginError({
    required this.message,
  });
}

class BaiduOcrPlugin {
  BaiduOcrPlugin._() {
    RecognizeListenerFlutterApi.setup(_recognizeFlutterApi);
  }

  static final BaiduOcrPlugin _instance = BaiduOcrPlugin._();

  /// Gets the globally set BaiduOcrPlugin instance.
  static BaiduOcrPlugin get instance => _instance;

  static final OcrHostApi _hostApi = OcrHostApi();
  static final RecognizeFlutterApiImpl _recognizeFlutterApi = RecognizeFlutterApiImpl();

  Future<void> initWithAkSk(String ak, String sk) async {
    try {
      await _hostApi.initWithAkSk(InitWithAkSkRequestData()
        ..ak = ak
        ..sk = sk);
    } on PlatformException catch (e) {
      throw BaiduOcrPluginError(message: '${e.message}');
    }
  }

  /// 身份证正面(本地质量控制)
  void recognizeIdCardFrontNative(RecognizeCallbackHandler<IdCardResult> cb) {
    _recognizeFlutterApi.callbackHandler = RecognizeCallbackHandler(
      onResult: (result) => cb.onResult.call(IdCardResult.fromJson(result)),
      onError: cb.onError,
      onCancel: cb.onCancel,
    );

    _hostApi.recognizeIdCardFrontNative();
  }

  /// 身份证反面(本地质量控制)
  void recognizeIdCardBackNative(RecognizeCallbackHandler<IdCardResult> cb) {
    _recognizeFlutterApi.callbackHandler = RecognizeCallbackHandler(
      onResult: (result) => cb.onResult.call(IdCardResult.fromJson(result)),
      onError: cb.onError,
      onCancel: cb.onCancel,
    );

    _hostApi.recognizeIdCardBackNative();
  }
}
