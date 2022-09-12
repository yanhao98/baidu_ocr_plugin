import 'package:baidu_ocr_plugin/baidu_ocr_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';

const ak = 'LrWkpucBSIKHErkFLWl71Pji';
const sk = 'YnRX31Nz3g5aKUFPtv6A6oYvFFWhgRd6';

void main() {
  /* Always call this if the main method is asynchronous*/
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool hasGotToken = false;

  @override
  void initState() {
    [Permission.camera, Permission.storage].request();
    _initAccessToken();
    // _initAccessTokenWithAkSk();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('baidu_ocr_plugin'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton(
            child: const Text('通用文字识别'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recognizeGeneralBasic(
                  RecognizeCallbackHandler(
                      onStart: _showLoading,
                      onResult: handleJsonRes,
                      onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('通用文字识别(高精度版)'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recognizeAccurateBasic(
                  RecognizeCallbackHandler(
                      onStart: _showLoading,
                      onResult: handleJsonRes,
                      onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('通用文字识别（含位置信息版）'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recognizeGeneral(RecognizeCallbackHandler(
                  onStart: _showLoading,
                  onResult: handleJsonRes,
                  onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('通用文字识别(高精度含位置信息版)'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recognizeAccurate(
                  RecognizeCallbackHandler(
                      onStart: _showLoading,
                      onResult: handleJsonRes,
                      onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('通用文字识别（含生僻字版）'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recognizeGeneralEnhanced(
                  RecognizeCallbackHandler(
                      onStart: _showLoading,
                      onResult: handleJsonRes,
                      onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('网络图片文字识别'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recognizeWebimage(
                  RecognizeCallbackHandler(
                      onStart: _showLoading,
                      onResult: handleJsonRes,
                      onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('身份证正面(嵌入式质量控制+云端识别)'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recognizeIdCardFrontNative(
                  RecognizeCallbackHandler(
                      onStart: _showLoading,
                      onResult: handleJsonRes,
                      onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('身份证反面(嵌入式质量控制+云端识别)'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recognizeIdCardBackNative(
                  RecognizeCallbackHandler(
                      onStart: _showLoading,
                      onResult: handleJsonRes,
                      onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('银行卡识别'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recognizeBankCard(
                  RecognizeCallbackHandler(
                      onStart: _showLoading,
                      onResult: handleJsonRes,
                      onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('驾驶证识别'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recognizeDrivingLicense(
                  RecognizeCallbackHandler(
                      onStart: _showLoading,
                      onResult: handleJsonRes,
                      onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('行驶证识别'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recognizeVehicleLicense(
                  RecognizeCallbackHandler(
                      onStart: _showLoading,
                      onResult: handleJsonRes,
                      onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('车牌识别'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recognizeLicensePlate(
                  RecognizeCallbackHandler(
                      onStart: _showLoading,
                      onResult: handleJsonRes,
                      onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('营业执照识别'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recognizeBusinessLicense(
                  RecognizeCallbackHandler(
                      onStart: _showLoading,
                      onResult: handleJsonRes,
                      onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('通用票据识别'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recognizeReceipt(RecognizeCallbackHandler(
                  onStart: _showLoading,
                  onResult: handleJsonRes,
                  onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('增值税发票识别'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recognizeVatInvoice(
                  RecognizeCallbackHandler(
                      onStart: _showLoading,
                      onResult: handleJsonRes,
                      onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('出租车票'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recognizeTaxireceipt(
                  RecognizeCallbackHandler(
                      onStart: _showLoading,
                      onResult: handleJsonRes,
                      onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('VIN码'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recognizeVincode(RecognizeCallbackHandler(
                  onStart: _showLoading,
                  onResult: handleJsonRes,
                  onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('火车票'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recognizeTrainticket(
                  RecognizeCallbackHandler(
                      onStart: _showLoading,
                      onResult: handleJsonRes,
                      onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('数字识别'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recognizeNumbers(RecognizeCallbackHandler(
                  onStart: _showLoading,
                  onResult: handleJsonRes,
                  onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('二维码识别'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recognizeQrcode(RecognizeCallbackHandler(
                  onStart: _showLoading,
                  onResult: handleJsonRes,
                  onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('行程单识别'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recoginzeTripTicket(
                  RecognizeCallbackHandler(
                      onStart: _showLoading,
                      onResult: handleJsonRes,
                      onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('机动车销售发票识别'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recoginzeVihickleSellInvoice(
                  RecognizeCallbackHandler(
                      onStart: _showLoading,
                      onResult: handleJsonRes,
                      onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('车辆合格证'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recoginzeVihickleCertificate(
                  RecognizeCallbackHandler(
                      onStart: _showLoading,
                      onResult: handleJsonRes,
                      onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('试卷分析与识别'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recoginzeExampleDoc(
                  RecognizeCallbackHandler(
                      onStart: _showLoading,
                      onResult: handleJsonRes,
                      onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('手写文字识别'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recoginzeWrittenText(
                  RecognizeCallbackHandler(
                      onStart: _showLoading,
                      onResult: handleJsonRes,
                      onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('护照识别'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recognizePassport(
                  RecognizeCallbackHandler(
                      onStart: _showLoading,
                      onResult: handleJsonRes,
                      onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('户口本识别'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recoginzeHuKouPage(
                  RecognizeCallbackHandler(
                      onStart: _showLoading,
                      onResult: handleJsonRes,
                      onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('普通机打发票识别'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recoginzeNormalMachineInvoice(
                  RecognizeCallbackHandler(
                      onStart: _showLoading,
                      onResult: handleJsonRes,
                      onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('自定义模板'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recognizeCustom(RecognizeCallbackHandler(
                  onStart: _showLoading,
                  onResult: handleJsonRes,
                  onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('磅单识别'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recoginzeweightnote(
                  RecognizeCallbackHandler(
                      onStart: _showLoading,
                      onResult: handleJsonRes,
                      onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('医疗费用明细识别'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recoginzemedicaldetail(
                  RecognizeCallbackHandler(
                      onStart: _showLoading,
                      onResult: handleJsonRes,
                      onError: handleOcrError));
            },
          ),
          ElevatedButton(
            child: const Text('网约车行程单识别'),
            onPressed: () {
              if (!checkTokenStatus()) return;

              BaiduOcrPlugin.instance.recoginzeonlinetaxiitinerary(
                  RecognizeCallbackHandler(
                      onStart: _showLoading,
                      onResult: handleJsonRes,
                      onError: handleOcrError));
            },
          ),
        ],
      ),
    );
  }

  bool checkTokenStatus() {
    if (!hasGotToken) EasyLoading.showToast('token还未成功获取');

    return hasGotToken;
  }

  void _alertText(BuildContext context, String title, [String? content]) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: content != null
              ? SingleChildScrollView(child: Text(content))
              : null,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('确定'),
            )
          ],
        );
      },
    );
  }

  // ignore: unused_element
  void _initAccessTokenWithAkSk() async {
    try {
      await BaiduOcrPlugin.instance.initAccessTokenWithAkSk(ak, sk);
      hasGotToken = true;
      EasyLoading.dismiss();
    } on OCRError catch (e) {
      await EasyLoading.dismiss();
      _alertText(context, '初始化错误', e.message);
    }
  }

  // ignore: unused_element
  void _initAccessToken() async {
    try {
      await BaiduOcrPlugin.instance.initAccessToken();
      hasGotToken = true;
      EasyLoading.dismiss();
    } on OCRError catch (e) {
      await EasyLoading.dismiss();
      _alertText(context, '初始化错误', e.message);
    }
  }

  void _showLoading([String status = '正在识别...']) {
    EasyLoading.show(status: status, maskType: EasyLoadingMaskType.black);
  }

  void handleJsonRes(String jsonRes) {
    EasyLoading.dismiss();
    _alertText(context, '识别结果', jsonRes);
  }

  void handleOcrError(OCRError ocrError) {
    EasyLoading.dismiss();
    _alertText(context, '识别错误', ocrError.message);
  }
}
