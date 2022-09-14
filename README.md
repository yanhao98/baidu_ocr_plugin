# baidu_ocr_plugin

[百度文字识别OCR](https://ai.baidu.com/ai-doc/index/OCR) 插件。

iOS SDK版本：`3.0.7`

Android SDK版本：`2.0.1`

## 安装

```shell
 $ flutter pub add baidu_ocr_plugin
```

## 使用

1. 身份验证：调用`BaiduOcrPlugin.instance.initAccessToken()`或 `BaiduOcrPlugin.instance.initAccessTokenWithAkSk(ak, sk);`

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
   try {
     await BaiduOcrPlugin.instance.initAccessToken();
     print("初始化成功");
   } on OCRError catch (e) {
     print("初始化错误: ${e.message}");
   }
   ```

2. 调用相应接口

   以`身份证正面(嵌入式质量控制+云端识别)`调用为例。
   
   其他api调用参照example项目。
   
   ```dart
   import 'package:baidu_ocr_plugin/baidu_ocr_plugin.dart';
   
   BaiduOcrPlugin.instance.recognizeIdCardFrontNative(
     RecognizeCallbackHandler(
       onStart: (Uint8List imageBytes) {
         // 即拍照结束后，发送网络请求时，通知此回调。
         // imageBytes为图片的二进制数据，可自行选择如何处理
         print("开始识别");
       },
       onResult: (String jsonRes) {
         print("识别结果：$jsonRes");
       },
       onError: (OCRError err) {
         print("识别错误：${err.message}");
       },
     ),
   );
   ```

## 注意

- 所有的api仅仅搬运了官方demo的调用，目前没有实现调用api的请求参数传递。（如果需要请发Issues）

## 打赏

- 如果在使用这个插件有真实的与插件有关的需求欢迎发起Issues或与我联系。

<div style="display:flex;">
<img src="https://user-images.githubusercontent.com/37316281/189598858-eee4717a-e2b8-46e2-9ea1-8e3d0fe56598.jpg" alt="IMG_6845" style="width:50%;" />
<img src="https://user-images.githubusercontent.com/37316281/189598869-d948b585-138d-4438-94f6-a75a7b5e90f7.jpg" alt="IMG_6846" style="width:50%;" />
</div>

## 资源

https://ai.baidu.com/sdk#ocr

[文字识别控制台](https://console.bce.baidu.com/ai/#/ai/ocr/overview/index)

[Android 授权文件（安全模式）获取AccessToken](https://ai.baidu.com/ai-doc/OCR/5kibizyrv#授权文件（安全模式）获取accesstoken)

[iOS 授权文件（安全模式）获取AccessToken](https://ai.baidu.com/ai-doc/OCR/6kibizx7f#授权文件（安全模式）)
