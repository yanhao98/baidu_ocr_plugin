package ren.yanhao.baidu_ocr_plugin;

import android.content.Context;

import androidx.annotation.NonNull;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;


/**
 * BaiduOcrPlugin
 */
public class BaiduOcrPlugin implements FlutterPlugin {
  private static final String TAG = "BaiduOcrPlugin";

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    Log.d(TAG, "onAttachedToEngine");
    setup(
        binding.getBinaryMessenger(),
        binding.getApplicationContext());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    Log.d(TAG, "onDetachedFromEngine");
  }

  // WebViewFlutterPlugin.java
  private void setup(
      BinaryMessenger binaryMessenger,
      Context context) {
    Pigeon.OcrHostApi.setup(binaryMessenger, new OcrHostApiImpl(context));
  }
}
