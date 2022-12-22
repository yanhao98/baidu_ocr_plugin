import 'dart:async';
import 'dart:typed_data';

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
  void recognizeBankCard(RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeBankCard(bytes);
  }

  /// 通用文字识别。
  void recognizeGeneralBasic(RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeGeneralBasic(bytes);
  }

  /// 通用文字识别(高精度版)
  void recognizeAccurateBasic(RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeAccurateBasic(bytes);
  }

  /// 通用文字识别（含位置信息版）
  void recognizeGeneral(RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeGeneral(bytes);
  }

  /// 通用文字识别(高精度含位置信息版)
  void recognizeAccurate(RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeAccurate(bytes);
  }

  /// 通用文字识别（含生僻字版）
  void recognizeGeneralEnhanced(
      RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeGeneralEnhanced(bytes);
  }

  /// 网络图片文字识别
  void recognizeWebimage(RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeGeneralEnhanced(bytes);
  }

  void recognizeDrivingLicense(
      RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeDrivingLicense(bytes);
  }

  void recognizeVehicleLicense(
      RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeVehicleLicense(bytes);
  }

  void recognizeBusinessLicense(
      RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeBusinessLicense(bytes);
  }

  void recognizeReceipt(RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeReceipt(bytes);
  }

  void recognizeVatInvoice(RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeVatInvoice(bytes);
  }

  void recognizeTaxireceipt(RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeTaxireceipt(bytes);
  }

  void recognizeLicensePlate(RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeLicensePlate(bytes);
  }

  void recognizeVincode(RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeVincode(bytes);
  }

  void recognizeTrainticket(RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeTrainticket(bytes);
  }

  void recognizeNumbers(RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeNumbers(bytes);
  }

  void recognizeQrcode(RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeQrcode(bytes);
  }

  void recoginzeTripTicket(RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recoginzeTripTicket(bytes);
  }

  void recoginzeVihickleSellInvoice(
      RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recoginzeVihickleSellInvoice(bytes);
  }

  void recoginzeVihickleCertificate(
      RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recoginzeVihickleCertificate(bytes);
  }

  void recoginzeExampleDoc(RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recoginzeExampleDoc(bytes);
  }

  void recoginzeWrittenText(RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recoginzeWrittenText(bytes);
  }

  void recognizePassport(RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizePassport(bytes);
  }

  void recoginzeHuKouPage(RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recoginzeHuKouPage(bytes);
  }

  void recoginzeNormalMachineInvoice(
      RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recoginzeNormalMachineInvoice(bytes);
  }

  void recognizeCustom(RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recognizeCustom(bytes);
  }

  void recoginzeweightnote(RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recoginzeweightnote(bytes);
  }

  void recoginzemedicaldetail(RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recoginzemedicaldetail(bytes);
  }

  void recoginzeonlinetaxiitinerary(
      RecognizeCallbackHandler recognizeCallbackHandler,
      {Uint8List? bytes}) {
    _recognizeFlutterApi.callbackHandler = recognizeCallbackHandler;
    _hostApi.recoginzeonlinetaxiitinerary(bytes);
  }
}
