package ren.yanhao.baidu_ocr_plugin;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import com.baidu.ocr.sdk.model.IDCardParams;
import com.baidu.ocr.ui.camera.CameraActivity;
import com.baidu.ocr.ui.camera.CameraNativeHelper;

import io.flutter.plugin.common.PluginRegistry;

public class ActivityResultDelegate implements PluginRegistry.ActivityResultListener {
  private final Context context;
  private Pigeon.RecognizeListenerFlutterApi recognizeListenerFlutterApi;

  public ActivityResultDelegate(
      Pigeon.RecognizeListenerFlutterApi recognizeListenerFlutterApi,
      Context context) {
    this.context = context;
    this.recognizeListenerFlutterApi = recognizeListenerFlutterApi;
  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    BaiduOcrPlugin.log("onActivityResult, requestCode: " + requestCode + ", resultCode: " + resultCode);

    // 释放本地质量控制模型
    CameraNativeHelper.release();
    // TODO: Activity.RESULT_CANCELED;
    if (requestCode == PluginDefine.REQUEST_CODE_CAMERA && resultCode == Activity.RESULT_CANCELED) {
      recognizeListenerFlutterApi.onReceivedCancel(reply -> {
      });
    }

    if (requestCode == PluginDefine.REQUEST_CODE_CAMERA && resultCode == Activity.RESULT_OK) {

      String contentType = data.getStringExtra(CameraActivity.KEY_CONTENT_TYPE);
      String filePath = FileUtil.getSaveFile(context).getAbsolutePath();
      String idCardSide = null;
      if (CameraActivity.CONTENT_TYPE_ID_CARD_FRONT.equals(contentType)) {
        idCardSide = IDCardParams.ID_CARD_SIDE_FRONT;
      } else if (CameraActivity.CONTENT_TYPE_ID_CARD_BACK.equals(contentType)) {
        idCardSide = IDCardParams.ID_CARD_SIDE_BACK;
      }

      RecognizeService.recognizeIDCard(idCardSide, context, filePath,
          new RecognizeService.ServiceListener() {
            @Override
            public void onResult(String jsonResult) {
              BaiduOcrPlugin.log("onResult回调给FLT: " + jsonResult);
              recognizeListenerFlutterApi.onReceivedResult(jsonResult, reply -> {
              });
            }

            @Override
            public void onError(String message) {
              BaiduOcrPlugin.log("onResult回调给FLT: " + message);
              recognizeListenerFlutterApi.onReceivedError(message, reply -> {
              });
            }
          });
    }

    // TODO: return true???
    return false;
  }
}
