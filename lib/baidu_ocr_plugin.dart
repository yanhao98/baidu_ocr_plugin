import 'dart:async';

import 'src/entity/ocr_error.dart';
import 'src/pigeon.dart';
import 'src/recognize_callback_handler.dart';
import 'src/recognize_flutter_api_impl.dart';

export 'src/entity/ocr_error.dart';
export 'src/recognize_callback_handler.dart';

class BaiduOcrPlugin {
  BaiduOcrPlugin._() {
    RecognizeListenerFlutterApi.setup(_recognizeFlutterApi);
  }

  static final BaiduOcrPlugin _instance = BaiduOcrPlugin._();

  /// Gets the globally set BaiduOcrPlugin instance.
  static BaiduOcrPlugin get instance => _instance;

  static final OcrHostApi _hostApi = OcrHostApi();
  static final RecognizeFlutterApiImpl _recognizeFlutterApi =
      RecognizeFlutterApiImpl();

  Future<String> initAccessTokenWithAkSk(String ak, String sk) async {
    InitResponseData? response = await _hostApi
        .initAccessTokenWithAkSk(InitWithAkSkRequestData(ak: ak, sk: sk));
    if (response!.isSuccess!) {
      return response.accessToken!;
    } else {
      throw OCRError.fromNativeResponse(response.ocrError!);
    }
  }

  Future<String> initAccessToken() async {
    InitResponseData? response = await _hostApi.initAccessToken();
    if (response!.isSuccess!) {
      return response.accessToken!;
    } else {
      throw OCRError.fromNativeResponse(response.ocrError!);
    }
  }

  /// 释放Android端本地质量控制模型。
  /*void releaseCameraNative() {
    _hostApi.releaseCameraNative();
  }*/

  /// 初始化Android端本地质量控制模型。
  /*void initCameraNative() {
    _hostApi.initCameraNative();
  }*/

  /// 身份证正面(本地质量控制)
  void recognizeIdCardFrontNative(
      RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeIdCardFrontNative();
  }

  /// 身份证反面(本地质量控制)
  void recognizeIdCardBackNative(
      RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeIdCardBackNative();
  }

  /// 银行卡识别。
  ///
  /// https://ai.baidu.com/ai-doc/OCR/ak3h7xxg3#%E8%BF%94%E5%9B%9E%E8%AF%B4%E6%98%8E
  void recognizeBankCard(RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeBankCard();
  }

  /// 通用文字识别。
  void recognizeGeneralBasic(
      RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeGeneralBasic();
  }

  /// 通用文字识别(高精度版)
  void recognizeAccurateBasic(
      RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeAccurateBasic();
  }

  /// 通用文字识别（含位置信息版）
  void recognizeGeneral(RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeGeneral();
  }

  /// 通用文字识别(高精度含位置信息版)
  void recognizeAccurate(RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeAccurate();
  }

  /// 通用文字识别（含生僻字版）
  void recognizeGeneralEnhanced(
      RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeGeneralEnhanced();
  }

  /// 网络图片文字识别
  void recognizeWebimage(RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeGeneralEnhanced();
  }

  void recognizeDrivingLicense(
      RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeDrivingLicense();
  }

  void recognizeVehicleLicense(
      RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeVehicleLicense();
  }

  void recognizeBusinessLicense(
      RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeBusinessLicense();
  }

  void recognizeReceipt(RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeReceipt();
  }

  void recognizeVatInvoice(RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeVatInvoice();
  }

  void recognizeTaxireceipt(RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeTaxireceipt();
  }

  void recognizeLicensePlate(
      RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeLicensePlate();
  }

  void recognizeVincode(RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeVincode();
  }

  void recognizeTrainticket(RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeTrainticket();
  }

  void recognizeNumbers(RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeNumbers();
  }

  void recognizeQrcode(RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeQrcode();
  }

  void recoginzeTripTicket(RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recoginzeTripTicket();
  }

  void recoginzeVihickleSellInvoice(
      RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recoginzeVihickleSellInvoice();
  }

  void recoginzeVihickleCertificate(
      RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recoginzeVihickleCertificate();
  }

  void recoginzeExampleDoc(RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recoginzeExampleDoc();
  }

  void recoginzeWrittenText(RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recoginzeWrittenText();
  }

  void recognizePassport(RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizePassport();
  }

  void recoginzeHuKouPage(RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recoginzeHuKouPage();
  }

  void recoginzeNormalMachineInvoice(
      RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recoginzeNormalMachineInvoice();
  }

  void recognizeCustom(RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeCustom();
  }

  void recoginzeweightnote(RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recoginzeweightnote();
  }

  void recoginzemedicaldetail(
      RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recoginzemedicaldetail();
  }

  void recoginzeonlinetaxiitinerary(
      RecognizeCallbackHandler recognizeCallbackHandler) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recoginzeonlinetaxiitinerary();
  }
}
