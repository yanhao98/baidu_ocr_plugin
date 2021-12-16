import 'dart:developer';

import 'package:baidu_ocr_plugin/pigeon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  NativeCallFlutterApi.setup(NativeCallFlutterApiImpl());
                },
                child: const Text('NativeCallFlutterApi.setup()'),
              ),
              ElevatedButton(
                onPressed: () async {
                  FlutterCallNativeApi api = FlutterCallNativeApi();
                  SearchRequest request = SearchRequest()..query = DateTime.now().toString();
                  SearchReply reply = await api.search(request);
                  log('native返回数据: ${reply.result}');
                },
                child: const Text('调用 native'),
              ),
              ElevatedButton(
                onPressed: () async {
                  FlutterCallNativeApi api = FlutterCallNativeApi();
                  try {
                    await api.replyErrorFromNative();
                  } on PlatformException catch (e) {
                    // code: Exception,
                    // message: java.lang.Exception: 错误内容1
                    log('code: ${e.code}, message: ${e.message}');
                  }
                },
                child: const Text('testReplyErrorFromNative'),
              ),
              const Divider(),
              ElevatedButton(
                onPressed: () async {
                  FlutterCallNativeApi api = FlutterCallNativeApi();
                  SearchReply searchReply = await api.startAsyncSearch();
                  log('异步结束, result: ${searchReply.result}');
                },
                child: const Text('1.异步开始'),
              ),
              ElevatedButton(
                onPressed: () async {
                  FlutterCallNativeApi api = FlutterCallNativeApi();
                  api.endAsyncSearch();
                },
                child: const Text('2.异步结束'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NativeCallFlutterApiImpl extends NativeCallFlutterApi {
  @override
  SearchReply query(SearchRequest request) {
    log("FLT被原生调用了。");
    SearchReply reply = SearchReply();
    reply.result = request.query! + "-flutterResult:" + DateTime.now().toString();
    return reply;
  }
}
