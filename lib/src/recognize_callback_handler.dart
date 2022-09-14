import 'dart:typed_data';

import '../baidu_ocr_plugin.dart';

/// baidu_ocr_plugin 的识别回调。
class RecognizeCallbackHandler {
  /// 开始识别。网络请求开始时调用。
  void Function(Uint8List imageBytes) onStart;

  /// 识别成功。网络返回成功时调用。
  void Function(String jsonRes) onResult;

  /// 识别失败。网络返回失败时调用。
  void Function(OCRError ocrError) onError;

  RecognizeCallbackHandler({
    required this.onStart,
    required this.onResult,
    required this.onError,
  });
}
