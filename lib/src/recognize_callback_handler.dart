class RecognizeCallbackHandler<T> {
  /// 识别成功。
  void Function(T result) onResult;

  /// 识别失败。
  void Function(String description) onError;

  /// 取消识别。
  void Function() onCancel;
  RecognizeCallbackHandler({
    required this.onResult,
    required this.onError,
    required this.onCancel,
  });
}
