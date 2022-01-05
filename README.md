# baidu_ocr_plugin

[百度文字识别OCR](https://ai.baidu.com/ai-doc/index/OCR) 插件。

iOS SDK版本：`3.0.5`

Android SDK版本：`1.4.7`

## 安装

```shell
 $ flutter pub add baidu_ocr_plugin
```

## 使用

1. 身份验证：调用 `BaiduOcrPlugin.instance.initWithAkSk(ak, sk);`

   ```dart
   import 'dart:async';

   import 'package:baidu_ocr_plugin/baidu_ocr_plugin.dart';

   void _initWithAkSk() async {
     try {
       await BaiduOcrPlugin.instance.initWithAkSk(ak, sk);
       print("初始化成功");
     } on BaiduOcrPluginError catch (error) {
       print("初始化错误: ${error.message}");
     }
   }
   ```

2. 调用相应接口

   - 身份证正面(本地质量控制)`recognizeIdCardFrontNative`
   - 身份证反面(本地质量控制)`recognizeIdCardBackNative`

   以下以身份证正面(本地质量控制)调用为例

   ```dart
   import 'package:baidu_ocr_plugin/baidu_ocr_plugin.dart';
   
   BaiduOcrPlugin.instance.recognizeIdCardFrontNative(
     RecognizeCallbackHandler(
       onStart: () {
         // 即拍照结束后通知此回调。
         print("开始识别");
       },
       onResult: (IdCardResult result) {
         print("识别成功。${result.front.name}");
       },
       onError: (String description) {
         print("识别出错。错误原因: $description");
       },
     ),
   );
   ```

