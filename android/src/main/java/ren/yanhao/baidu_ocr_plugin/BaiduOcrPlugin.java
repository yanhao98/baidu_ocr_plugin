package ren.yanhao.baidu_ocr_plugin;

import androidx.annotation.NonNull;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;

/**
 * BaiduOcrPlugin
 */
public class BaiduOcrPlugin implements FlutterPlugin, ActivityAware {
  public static final String TAG = "BaiduOcrPlugin";
  private OcrHostApiImpl ocrHostApi;
  private ActivityResultDelegate activityResultDelegate;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    log("onAttachedToEngine");

    BinaryMessenger binaryMessenger = binding.getBinaryMessenger();

    this.ocrHostApi = new OcrHostApiImpl(binding.getApplicationContext());
    Pigeon.OcrHostApi.setup(binaryMessenger, ocrHostApi);

    this.activityResultDelegate = new ActivityResultDelegate(
        new Pigeon.RecognizeListenerFlutterApi(binaryMessenger),
        binding.getApplicationContext());

  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    log("onDetachedFromEngine");
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding activityPluginBinding) {
    log("onAttachedToActivity");

    ocrHostApi.setActivity(activityPluginBinding.getActivity());

    activityPluginBinding.addActivityResultListener(activityResultDelegate);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    log("onDetachedFromActivityForConfigChanges");
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    log("onReattachedToActivityForConfigChanges");
  }

  @Override
  public void onDetachedFromActivity() {
    log("onDetachedFromActivity");
  }

  public static void log(String message) {
    Log.d(TAG, "🍑" + message);
  }

  public static void loge(String message) {
    Log.e(TAG, "🍑" + message);
  }
}
