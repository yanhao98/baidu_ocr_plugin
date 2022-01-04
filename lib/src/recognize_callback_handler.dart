/// baidu_ocr_plugin 的识别回调。
class RecognizeCallbackHandler<T> {
  /// 开始识别。
  void Function() onStart;

  /// 识别成功。
  void Function(T result) onResult;

  /// 识别失败。
  void Function(String description) onError;

  RecognizeCallbackHandler({
    required this.onStart,
    required this.onResult,
    required this.onError,
  });
}
