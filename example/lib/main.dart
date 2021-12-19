import 'package:baidu_ocr_plugin/baidu_ocr_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

const ak = 'gyNpPgRMqKiCOWffodQDmpAT';
const sk = 'c8amR3DEfrqB4ONfc5gS2sumjBl75aQO';
void main() {
  // Always call this if the main method is asynchronous
  WidgetsFlutterBinding.ensureInitialized();
  BaiduOcrPlugin.instance.initWithAkSk(ak, sk);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('baidu_ocr_plugin'),
        ),
        body: Builder(builder: (context) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await BaiduOcrPlugin.instance.initWithAkSk(ak, sk);
                      _alertText(context, '初始化成功');
                    } on BaiduOcrPluginError catch (e) {
                      _alertText(context, '初始化失败', e.message);
                    }
                  },
                  child: const Text('initWithAkSk'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    EasyLoading.show(status: '正面扫描...', maskType: EasyLoadingMaskType.black);
                    BaiduOcrPlugin.instance.recognizeIdCardFrontNative(
                      RecognizeCallbackHandler(
                        onResult: (result) {
                          EasyLoading.dismiss().then((value) => _alertText(
                                context,
                                '正面扫描结果',
                                '${result.front.name}\n'
                                    '${result.front.idNumber}\n'
                                    '${result.front.gender}\n'
                                    '${result.front.ethnic}\n'
                                    '${result.front.birthday}\n'
                                    '${result.front.address}\n',
                              ));
                        },
                        onError: (description) {
                          EasyLoading.dismiss().then((value) => _alertText(context, '错误', description));
                        },
                        onCancel: () {
                          EasyLoading.dismiss().then((value) => _alertText(context, 'onCancel'));
                        },
                      ),
                    );
                  },
                  child: const Text('身份证正面(本地质量控制)'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    EasyLoading.show(
                      status: '反面扫描...',
                      maskType: EasyLoadingMaskType.black,
                    ).then((value) => BaiduOcrPlugin.instance.recognizeIdCardBackNative(
                          RecognizeCallbackHandler(
                            onResult: (result) {
                              EasyLoading.dismiss().then(
                                (value) => _alertText(
                                  context,
                                  '反面扫描结果',
                                  '${result.back.issueAuthority}\n'
                                      '${result.back.signDate}\n'
                                      '${result.back.expiryDate}\n',
                                ),
                              );
                            },
                            onError: (description) {
                              EasyLoading.dismiss().then((value) => _alertText(context, '错误', description));
                            },
                            onCancel: () {
                              EasyLoading.dismiss().then((value) => _alertText(context, 'onCancel'));
                            },
                          ),
                        ));
                  },
                  child: const Text('身份证反面(本地质量控制)'),
                ),
              ],
            ),
          );
        }),
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
