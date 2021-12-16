package ren.yanhao.baidu_ocr_plugin;

import android.content.Context;
import android.widget.Toast;

import androidx.annotation.NonNull;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;


/**
 * BaiduOcrPlugin
 */
public class BaiduOcrPlugin implements FlutterPlugin, Pigeon.FlutterCallNativeApi {
    private static final String TAG = "BaiduOcrPlugin";

    private Pigeon.NativeCallFlutterApi nativeApi;
    private Context context;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        Log.d(TAG, "onAttachedToEngine");
        context = binding.getApplicationContext();

        Pigeon.FlutterCallNativeApi.setup(binding.getBinaryMessenger(), this);
        nativeApi = new Pigeon.NativeCallFlutterApi(binding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        Log.d(TAG, "onDetachedFromEngine");
        Pigeon.FlutterCallNativeApi.setup(binding.getBinaryMessenger(), null);
    }

    // flutter call native
    @Override
    public Pigeon.SearchReply search(Pigeon.SearchRequest request) {
        Log.d(TAG, "navtive 被 FLT 端调用了。入参:" + request.getQuery());
        Pigeon.SearchReply reply = new Pigeon.SearchReply();
        reply.setResult(request.getQuery() + "--nativeResult");

        //region native call flutter
        Pigeon.SearchRequest requestArg = new Pigeon.SearchRequest();
        requestArg.setQuery("nativeRequestArg");
        nativeApi.query(requestArg, new Pigeon.NativeCallFlutterApi.Reply<Pigeon.SearchReply>() {
            @Override
            public void reply(Pigeon.SearchReply reply) {
                // flutter reply
                if (reply != null) {
                    Log.d(TAG, "navtive 收到了 FLT 端的回复。reply:" + reply.getResult());
                    Toast.makeText(context, reply.getResult(), Toast.LENGTH_SHORT).show();
                }
            }
        });
        //endregion

        // native reply flutter
        return reply;
    }

    @Override
    public void replyErrorFromNative(Pigeon.Result<Void> result) {
        result.error(new Exception("错误内容1"));
    }
}
