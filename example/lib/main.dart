import 'package:baidu_ocr_plugin/baidu_ocr_plugin.dart';
import 'package:flutter/material.dart';

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
                      await BaiduOcrPlugin.initWithAkSk(
                        ak: 'gyNpPgRMqKiCOWffodQDmpAT',
                        sk: 'c8amR3DEfrqB4ONfc5gS2sumjBl75aQO',
                      );
                      _showAlert(context, '初始化成功');
                    } on BaiduOcrPluginError catch (e) {
                      _showAlert(context, '初始化失败', e.message);
                    }
                  },
                  child: const Text('初始化SDK'),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void _showAlert(BuildContext context, String title, [String? content]) {
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
