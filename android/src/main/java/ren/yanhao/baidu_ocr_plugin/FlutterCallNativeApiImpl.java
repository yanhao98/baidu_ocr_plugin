package ren.yanhao.baidu_ocr_plugin;

import android.content.Context;
import android.widget.Toast;

import io.flutter.Log;

public class FlutterCallNativeApiImpl implements Pigeon.FlutterCallNativeApi {
    private static final String TAG = "BaiduOcrPlugin";

    private final Pigeon.NativeCallFlutterApi nativeApi;
    private final Context context;

    public FlutterCallNativeApiImpl(
            Pigeon.NativeCallFlutterApi nativeCallFlutterApi,
            Context context) {
        this.nativeApi = nativeCallFlutterApi;
        this.context = context;
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
