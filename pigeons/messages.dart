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

  // TODO:安卓端在初始化SDK的时候init。
  /// 初始化本地质量控制模型
  void initCameraNative();

  //  TODO:release SDK的时候release。
  /// 释放本地质量控制模型
  void releaseCameraNative();
}

@FlutterApi()
abstract class RecognizeListenerFlutterApi {
  void onReceivedStart();
  void onReceivedResult(String result);
  void onReceivedError(String description);
}
