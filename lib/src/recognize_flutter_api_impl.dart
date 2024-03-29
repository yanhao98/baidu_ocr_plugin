import 'dart:typed_data';

import 'entity/ocr_error.dart';
import 'pigeon.dart';
import 'recognize_callback_handler.dart';

/// native端调用flutter端的实现。
class RecognizeFlutterApiImpl extends RecognizeListenerFlutterApi {
  late RecognizeCallbackHandler callbackHandler;

  @override
  void onReceivedStart(Uint8List imageBytes) {
    callbackHandler.onStart(imageBytes);
  }

  @override
  void onReceivedResult(String jsonResult) {
    callbackHandler.onResult.call(jsonResult);
  }

  @override
  void onReceivedError(OCRErrorResponseData ocrErrorResponseData) {
    callbackHandler.onError
        .call(OCRError.fromNativeResponse(ocrErrorResponseData));
  }
}
