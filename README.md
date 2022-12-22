# baidu_ocr_plugin

[百度文字识别OCR](https://ai.baidu.com/ai-doc/index/OCR) 插件。

iOS SDK版本：`3.0.7`

Android SDK版本：`2.0.1`

## 安装

```shell
 $ flutter pub add baidu_ocr_plugin
```

## 使用

### 身份验证：

- 调用 `BaiduOcrPlugin.instance.initAccessToken()`。授权文件如何配置参考官网。
- 调用 `BaiduOcrPlugin.instance.initAccessTokenWithAkSk(ak, sk);`

```dart
import 'package:baidu_ocr_plugin/baidu_ocr_plugin.dart';

  ...
  try {
    await BaiduOcrPlugin.instance.initAccessToken();
    print("初始化成功");
  } on OCRError catch (e) {
    print("初始化错误: ${e.message}");
  }
	...
```

### 调用识别api

```dart
import 'package:baidu_ocr_plugin/baidu_ocr_plugin.dart';

BaiduOcrPlugin.instance.recognizeGeneralBasic(
    RecognizeCallbackHandler(
      onStart: (Uint8List imageBytes) {
        // 发送网络请求之前，通知此回调。
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
    bytes: bytes);
```

参数说明：

`bytes ` : 可选参数，照片二进制数据。如果传入该参数，将不弹出自带的拍照界面，直接调用识别接口识别。

注意：

- 支持的图片大小为：base64编码后小于4M，分辨率不高于4096x4096。否则会报错误码`216202`
- `身份证正面(本地质量控制)`、`身份证反面(本地质量控制)`这两个api暂时不支持传入照片二进制数据。

## 说明

- 有帮助的话给个start。

- 所有的api仅仅搬运了官方demo的调用，目前没有实现调用api的请求参数传递。（如果需要自己研究改造一下或发个Issues）
- 最初我自己使用的api只有`身份证正面(本地质量控制)`、`身份证反面(本地质量控制)`。我对`Android`和`iOS`的知识也很有限。目前的工作与`Flutter`也无关。开源这个插件真心希望能帮到你。

## 打赏

- 如果在使用这个插件有真实的与插件有关的需求欢迎发起Issues或与我联系。

<div style="display:flex;">
<img src="https://user-images.githubusercontent.com/37316281/189598858-eee4717a-e2b8-46e2-9ea1-8e3d0fe56598.jpg" alt="IMG_6845" style="width:500px; height: 500px" />
<img src="https://user-images.githubusercontent.com/37316281/189598869-d948b585-138d-4438-94f6-a75a7b5e90f7.jpg" alt="IMG_6846" style="width:500px; height: 500px" />
</div>


## 资源

https://ai.baidu.com/sdk#ocr

[文字识别控制台](https://console.bce.baidu.com/ai/#/ai/ocr/overview/index)

[Android 授权文件（安全模式）获取AccessToken](https://ai.baidu.com/ai-doc/OCR/5kibizyrv#授权文件（安全模式）获取accesstoken)

[iOS 授权文件（安全模式）获取AccessToken](https://ai.baidu.com/ai-doc/OCR/6kibizx7f#授权文件（安全模式）)

[错误码](https://ai.baidu.com/ai-doc/OCR/dk3h7y5vr)
