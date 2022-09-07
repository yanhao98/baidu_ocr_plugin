package ren.yanhao.baidu_ocr_plugin;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import com.baidu.ocr.sdk.model.IDCardParams;
import com.baidu.ocr.ui.camera.CameraActivity;

import io.flutter.plugin.common.PluginRegistry;

public class ActivityResultDelegate implements PluginRegistry.ActivityResultListener {
    private final Context context;
    private final Pigeon.RecognizeListenerFlutterApi flutterApi;

    public ActivityResultDelegate(
            Pigeon.RecognizeListenerFlutterApi recognizeListenerFlutterApi,
            Context context) {
        this.context = context;
        this.flutterApi = recognizeListenerFlutterApi;
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        BaiduOcrPlugin.log("onActivityResult, requestCode: " + requestCode + ", resultCode: " + resultCode);

        // 释放本地质量控制模型
        // CameraNativeHelper.release();
        if (requestCode == PluginDefine.REQUEST_CODE_CAMERA) {

            /*if (resultCode == Activity.RESULT_CANCELED) {
                flutterApi.onReceivedCancel(reply -> {
                });
            }*/

            if (resultCode == Activity.RESULT_OK) {
                if (data != null) {
                    String contentType = data.getStringExtra(CameraActivity.KEY_CONTENT_TYPE);
                    String filePath = FileUtil.getSaveFile(context).getAbsolutePath();
                    String idCardSide = null;
                    if (CameraActivity.CONTENT_TYPE_ID_CARD_FRONT.equals(contentType)) {
                        idCardSide = IDCardParams.ID_CARD_SIDE_FRONT;
                    } else if (CameraActivity.CONTENT_TYPE_ID_CARD_BACK.equals(contentType)) {
                        idCardSide = IDCardParams.ID_CARD_SIDE_BACK;
                    }

                    flutterApi.onReceivedStart(reply -> {
                    });
                    RecognizeService.recognizeIDCard(idCardSide, context, filePath,
                            new RecognizeService.ServiceListener() {
                                @Override
                                public void onResult(String jsonResult) {
                                    BaiduOcrPlugin.log("onResult回调给FLT: " + jsonResult);
                                    flutterApi.onReceivedResult(jsonResult, reply -> {
                                    });
                                }

                                @Override
                                public void onError(String message) {
                                    BaiduOcrPlugin.log("onResult回调给FLT: " + message);
                                    flutterApi.onReceivedError(message, reply -> {
                                    });
                                }
                            });
                }
            }

        }
        // 识别成功回调，银行卡识别
        else if (requestCode == PluginDefine.REQUEST_CODE_BANKCARD) {
            flutterApi.onReceivedStart(reply -> {
            });
            RecognizeService.recBankCard(context, FileUtil.getSaveFile(context).getAbsolutePath(),
                    new RecognizeService.ServiceListener() {
                        @Override
                        public void onResult(String jsonResult) {
                            BaiduOcrPlugin.log("onResult回调给FLT: " + jsonResult);
                            flutterApi.onReceivedResult(jsonResult, reply -> {
                            });
                        }

                        @Override
                        public void onError(String message) {
                            BaiduOcrPlugin.log("onResult回调给FLT: " + message);
                            flutterApi.onReceivedError(message, reply -> {
                            });
                        }
                    });
        }
        // TODO: return true???
        return true;
    }
}
