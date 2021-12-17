package ren.yanhao.baidu_ocr_plugin;

import android.app.Activity;
import android.content.Context;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.baidu.ocr.sdk.OCR;
import com.baidu.ocr.sdk.OnResultListener;
import com.baidu.ocr.sdk.exception.OCRError;
import com.baidu.ocr.sdk.model.AccessToken;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;


/**
 * BaiduOcrPlugin
 */
public class BaiduOcrPlugin implements FlutterPlugin, ActivityAware {
    private static final String TAG = "BaiduOcrPlugin";

    private Activity activity;
    private Context context;

    public static Pigeon.Result<Pigeon.SearchReply> result;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        this.context = binding.getApplicationContext();
        Log.d(TAG, "onAttachedToEngine");
        setup(binding.getBinaryMessenger(), binding.getApplicationContext());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        Log.d(TAG, "onDetachedFromEngine");
    }

    private void setup(BinaryMessenger binaryMessenger, Context context) {
        Pigeon.NativeCallFlutterApi nativeCallFlutterApi = new Pigeon.NativeCallFlutterApi(binaryMessenger);
        Pigeon.FlutterCallNativeApi flutterCallNativeApi = new FlutterCallNativeApiImpl(nativeCallFlutterApi, context);

        Pigeon.FlutterCallNativeApi.setup(binaryMessenger, flutterCallNativeApi);
    }

    private void test() {
        OCR.getInstance(activity).initAccessTokenWithAkSk(
                new OnResultListener<AccessToken>() {
                    @Override
                    public void onResult(AccessToken accessToken) {
                        Log.d(TAG, "onResult: " + accessToken.toString());
                    }

                    @Override
                    public void onError(OCRError ocrError) {
                        Log.d(TAG, "onError: " + ocrError.toString());
                        Log.d(TAG, "getMessage: " + ocrError.getMessage());
                    }
                },
                this.context,
                "gyNpPgRMqKiCOWffodQDmpAT",
                "c8amR3DEfrqB4ONfc5gS2sumjBl75aQO"
        );
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        Log.d(TAG, "onAttachedToActivity");
        this.activity = binding.getActivity();
        this.test();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    }

    @Override
    public void onDetachedFromActivity() {
    }
}
