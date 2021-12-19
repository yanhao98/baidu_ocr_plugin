import 'pigeon.dart';
import 'recognize_callback_handler.dart';

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
  void onReceivedCancel() {
    callbackHandler?.onCancel.call();
  }
}
