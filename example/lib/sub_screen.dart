import 'package:baidu_ocr_plugin/baidu_ocr_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';

const ak = 'LrWkpucBSIKHErkFLWl71Pji';
const sk = 'YnRX31Nz3g5aKUFPtv6A6oYvFFWhgRd6';

class SubScreen extends StatefulWidget {
  const SubScreen({Key? key}) : super(key: key);

  @override
  _SubScreenState createState() => _SubScreenState();
}

class _SubScreenState extends State<SubScreen> {
  @override
  void initState() {
    [Permission.camera, Permission.storage].request();
    _initWithAkSk();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('baidu_ocr_plugin'),
      ),
      body: Builder(builder: (context) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => _initWithAkSk(),
                child: const Text('initWithAkSk'),
              ),
              ElevatedButton(
                onPressed: () => BaiduOcrPlugin.instance.initCameraNative(),
                child: const Text('初始化本地质量控制模型'),
              ),
              ElevatedButton(
                onPressed: () => _recognizeIdCardFrontNative(context),
                child: const Text('身份证正面(本地质量控制)'),
              ),
              ElevatedButton(
                onPressed: () => _recognizeIdCardBackNative(context),
                child: const Text('身份证反面(本地质量控制)'),
              ),
              ElevatedButton(
                onPressed: () => BaiduOcrPlugin.instance.releaseCameraNative(),
                child: const Text('释放本地质量控制模型'),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _initWithAkSk() {
    EasyLoading.show(status: '_initWithAkSk', maskType: EasyLoadingMaskType.black);

    BaiduOcrPlugin.instance //
        .initWithAkSk(ak, sk)
        .then((_) => EasyLoading.dismiss().then((_) => EasyLoading.showInfo('init success')))
        .onError<BaiduOcrPluginError>(
          (error, stackTrace) => EasyLoading.dismiss().then((_) => _alertText(context, '初始化错误', error.message)),
        );
  }

  void _recognizeIdCardBackNative(BuildContext context) {
    BaiduOcrPlugin.instance.recognizeIdCardBackNative(
      RecognizeCallbackHandler(
        onStart: () => EasyLoading.show(status: '正在识别...', maskType: EasyLoadingMaskType.black),
        onResult: (result) => EasyLoading.dismiss().then(
          (_) => _alertText(
              context,
              '反面扫描结果',
              '${result.back.issueAuthority}\n'
                  '${result.back.signDate}\n'
                  '${result.back.expiryDate}\n'),
        ),
        onError: (description) => EasyLoading.dismiss().then(
          (_) => _alertText(context, '反面扫描错误', description),
        ),
      ),
    );
  }

  void _recognizeIdCardFrontNative(BuildContext context) async {
    BaiduOcrPlugin.instance.recognizeIdCardFrontNative(
      RecognizeCallbackHandler(
        onStart: () => EasyLoading.show(status: '正面识别...', maskType: EasyLoadingMaskType.black),
        onResult: (result) => EasyLoading.dismiss().then((_) => _alertText(
            context,
            '正面扫描结果',
            '${result.front.name}\n'
                '${result.front.idNumber}\n'
                '${result.front.gender}\n'
                '${result.front.ethnic}\n'
                '${result.front.birthday}\n'
                '${result.front.address}\n')),
        onError: (description) => EasyLoading.dismiss().then(
          (_) => _alertText(context, '正面扫描错误', description),
        ),
      ),
    );
  }

  void _alertText(BuildContext context, String title, [String? content]) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: content != null ? Text(content) : null,
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
}
