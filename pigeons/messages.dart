import 'package:pigeon/pigeon.dart';

class InitWithAkSkRequestData {
  String? ak;
  String? sk;
}

class InitResponseData {
  bool? isSuccess;
  String? accessToken;
  OCRErrorResponseData? ocrError;
}

class OCRErrorResponseData {
  int? errorCode;
  String? errorMessage;
}

@HostApi()
abstract class OcrHostApi {
  @async
  InitResponseData? initAccessTokenWithAkSk(InitWithAkSkRequestData request);

  @async
  InitResponseData? initAccessToken();

  void recognizeGeneralBasic(Uint8List? bytes);

  void recognizeAccurateBasic(Uint8List? bytes);

  void recognizeGeneral(Uint8List? bytes);

  void recognizeAccurate(Uint8List? bytes);

  void recognizeGeneralEnhanced(Uint8List? bytes);

  void recognizeWebimage(Uint8List? bytes);

  void recognizeDrivingLicense(Uint8List? bytes);

  void recognizeVehicleLicense(Uint8List? bytes);

  void recognizeBusinessLicense(Uint8List? bytes);

  void recognizeReceipt(Uint8List? bytes);

  void recognizeVatInvoice(Uint8List? bytes);

  void recognizeTaxireceipt(Uint8List? bytes);

  void recognizeLicensePlate(Uint8List? bytes);

  void recognizeVincode(Uint8List? bytes);

  void recognizeTrainticket(Uint8List? bytes);

  void recognizeNumbers(Uint8List? bytes);

  void recognizeQrcode(Uint8List? bytes);

  void recoginzeTripTicket(Uint8List? bytes);

  void recoginzeVihickleSellInvoice(Uint8List? bytes);

  void recoginzeVihickleCertificate(Uint8List? bytes);

  void recoginzeExampleDoc(Uint8List? bytes);

  void recoginzeWrittenText(Uint8List? bytes);

  void recognizePassport(Uint8List? bytes);

  void recoginzeHuKouPage(Uint8List? bytes);

  void recoginzeNormalMachineInvoice(Uint8List? bytes);

  void recognizeCustom(Uint8List? bytes);

  void recoginzeweightnote(Uint8List? bytes);

  void recoginzemedicaldetail(Uint8List? bytes);

  void recoginzeonlinetaxiitinerary(Uint8List? bytes);

  /// 身份证正面(本地质量控制)
  void recognizeIdCardFrontNative();

  /// 身份证反面(本地质量控制)
  void recognizeIdCardBackNative();

  /// 银行卡识别
  void recognizeBankCard(Uint8List? bytes);

/*
  /// 初始化本地质量控制模型
  void initCameraNative();

  /// 释放本地质量控制模型
  void releaseCameraNative();
*/

}

@FlutterApi()
abstract class RecognizeListenerFlutterApi {
  void onReceivedStart(Uint8List imageBytes);

  void onReceivedResult(String jsonResult);

  void onReceivedError(OCRErrorResponseData ocrErrorResponseData);
}
