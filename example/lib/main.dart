import 'package:baidu_ocr_plugin/baidu_ocr_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';

const ak = 'gyNpPgRMqKiCOWffodQDmpAT';
const sk = 'c8amR3DEfrqB4ONfc5gS2sumjBl75aQO';
void main() {
  // Always call this if the main method is asynchronous
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
  @override
  void initState() {
    [Permission.camera, Permission.storage].request();
    _initWithAkSk();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('baidu_ocr_plugin'),
        ),
        body: Builder(builder: (context) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                /* ElevatedButton(
                  onPressed: () {
                    BaiduOcrPlugin.instance //
                        .initWithAkSk(ak, sk)
                        .then((value) {
                      EasyLoading.showInfo('init success').then((value) => //
                          _recognizeIdCardBackNative(context));
                    });
                  },
                  child: const Text('initWithAkSk and _recognizeIdCardBackNative'),
                ), */
                ElevatedButton(
                  onPressed: () => _initWithAkSk(),
                  child: const Text('initWithAkSk'),
                ),
                ElevatedButton(
                  onPressed: () => _recognizeIdCardFrontNative(context),
                  child: const Text('身份证正面(本地质量控制)'),
                ),
                ElevatedButton(
                  onPressed: () => _recognizeIdCardBackNative(context),
                  child: const Text('身份证反面(本地质量控制)'),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void _recognizeIdCardBackNative(BuildContext context) {
    {
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
    }
  }

  void _recognizeIdCardFrontNative(BuildContext context) async {
    {
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
    }
  }

  void _initWithAkSk() {
    BaiduOcrPlugin.instance
        .initWithAkSk(ak, sk)
        .then(
          (_) => EasyLoading.showInfo('init success'),
        )
        .catchError(
      (error) {
        EasyLoading.showError('init success');
      },
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
