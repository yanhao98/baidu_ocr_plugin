import 'pigeon.dart';
import 'recognize_callback_handler.dart';

/// native端调用flutter端的实现。
class RecognizeFlutterApiImpl extends RecognizeListenerFlutterApi {
  RecognizeCallbackHandler<String>? callbackHandler;

  @override
  void onReceivedError(String description) {
    callbackHandler?.onError.call(description);
  }

  @override
  void onReceivedResult(String result) {
    callbackHandler?.onResult.call(result);
  }

  @override
  void onReceivedStart() {
    callbackHandler?.onStart.call();
  }
}
