package ren.yanhao.baidu_ocr_plugin;

import android.content.Context;
import android.widget.Toast;

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

        setup(binding.getBinaryMessenger(), binding.getApplicationContext());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        Log.d(TAG, "onDetachedFromEngine");
    }

    private void setup(
            BinaryMessenger binaryMessenger,
            Context context) {
        Pigeon.NativeCallFlutterApi nativeCallFlutterApi = new Pigeon.NativeCallFlutterApi(binaryMessenger);

        Pigeon.FlutterCallNativeApi flutterCallNativeApi =
                new FlutterCallNativeApiImpl(nativeCallFlutterApi, context);

        Pigeon.FlutterCallNativeApi.setup(binaryMessenger, flutterCallNativeApi);
    }
}
