import 'package:pigeon/pigeon.dart';

class InitWithAkSkRequestData {
  String? ak;
  String? sk;
}

@HostApi()
abstract class OcrHostApi {
  @async
  void initWithAkSk(InitWithAkSkRequestData request);

  /// 身份证正面(本地质量控制)
  void recognizeIdCardFrontNative();

  /// 身份证反面(本地质量控制)
  void recognizeIdCardBackNative();
}

@FlutterApi()
abstract class RecognizeListenerFlutterApi {
  void onReceivedResult(String result);
  void onReceivedError(String description);
  void onReceivedCancel();
}
