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

  void recognizeGeneralBasic();

  void recognizeAccurateBasic();

  void recognizeGeneral();

  void recognizeAccurate();

  void recognizeGeneralEnhanced();

  void recognizeWebimage();

  void recognizeDrivingLicense();

  void recognizeVehicleLicense();

  void recognizeBusinessLicense();

  void recognizeReceipt();

  void recognizeVatInvoice();

  void recognizeTaxireceipt();

  void recognizeLicensePlate();

  void recognizeVincode();

  void recognizeTrainticket();

  void recognizeNumbers();

  void recognizeQrcode();

  void recoginzeTripTicket();

  void recoginzeVihickleSellInvoice();

  void recoginzeVihickleCertificate();

  void recoginzeExampleDoc();

  void recoginzeWrittenText();

  void recognizePassport();

  void recoginzeHuKouPage();

  void recoginzeNormalMachineInvoice();

  void recognizeCustom();

  void recoginzeweightnote();

  void recoginzemedicaldetail();

  void recoginzeonlinetaxiitinerary();

  /// 身份证正面(本地质量控制)
  void recognizeIdCardFrontNative();

  /// 身份证反面(本地质量控制)
  void recognizeIdCardBackNative();

  /// 银行卡识别
  void recognizeBankCard();

/*
  /// 初始化本地质量控制模型
  void initCameraNative();

  /// 释放本地质量控制模型
  void releaseCameraNative();
*/

}

@FlutterApi()
abstract class RecognizeListenerFlutterApi {
  void onReceivedStart();

  void onReceivedResult(String jsonResult);

  void onReceivedError(OCRErrorResponseData ocrErrorResponseData);
}
