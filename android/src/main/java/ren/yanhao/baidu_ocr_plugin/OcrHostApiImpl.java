package ren.yanhao.baidu_ocr_plugin;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import com.baidu.ocr.sdk.OCR;
import com.baidu.ocr.sdk.OnResultListener;
import com.baidu.ocr.sdk.exception.OCRError;
import com.baidu.ocr.sdk.model.AccessToken;
import com.baidu.ocr.ui.camera.CameraActivity;
import com.baidu.ocr.ui.camera.CameraNativeHelper;
import com.baidu.ocr.ui.camera.CameraView;

public class OcrHostApiImpl implements Pigeon.OcrHostApi {
  private final Context context;
  private Activity activity;

  public OcrHostApiImpl(Context context) {
    this.context = context;
  }

  public void setActivity(Activity activity) {
    this.activity = activity;
  }

  @Override
  public void initWithAkSk(Pigeon.InitWithAkSkRequestData request, Pigeon.Result<Void> result) {
    BaiduOcrPlugin.log("initWithAkSk");
    OCR.getInstance(context).initAccessTokenWithAkSk(
        new OnResultListener<AccessToken>() {
          @Override
          public void onResult(AccessToken accessToken) {
            result.success(null);
          }

          @Override
          public void onError(OCRError ocrError) {
            result.error(new PluginException(ocrError.getMessage()));
          }
        }, context, request.getAk(), request.getSk());
  }

  @Override
  public void recognizeIdCardFrontNative() {
    BaiduOcrPlugin.log("开始身份证正面扫描");
    this.recognizeIdCard(CameraActivity.CONTENT_TYPE_ID_CARD_FRONT);
  }

  @Override
  public void recognizeIdCardBackNative() {
    BaiduOcrPlugin.log("开始身份证反面扫描");
    this.recognizeIdCard(CameraActivity.CONTENT_TYPE_ID_CARD_BACK);
  }

  private void recognizeIdCard(String activityContentType) {
    BaiduOcrPlugin.log("recognizeIdCard, idCardSide: " + activityContentType);
    // KEY_NATIVE_MANUAL 设置了之后 CameraActivity 中不再自动初始化和释放模型
    // 请手动使用CameraNativeHelper初始化和释放模型
    // 推荐这样做，可以避免一些activity切换导致的不必要的异常

    // 手动化本地质量控制模型,释放代码在 ActivityResultDelegate
    this.initNative();

    Intent intent = new Intent(activity, CameraActivity.class);
    intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(context).getAbsolutePath());
    intent.putExtra(CameraActivity.KEY_NATIVE_ENABLE, true);
    intent.putExtra(CameraActivity.KEY_NATIVE_MANUAL, true);
    intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, activityContentType);
    activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_CAMERA);
  }

  private void initNative() {
    CameraNativeHelper.init(
        context,
        OCR.getInstance(context).getLicense(),
        (errorCode, e) -> {
          String msg;
          switch (errorCode) {
            case CameraView.NATIVE_SOLOAD_FAIL:
              msg = "加载so失败，请确保apk中存在ui部分的so";
              break;
            case CameraView.NATIVE_AUTH_FAIL:
              msg = "授权本地质量控制token获取失败";
              break;
            case CameraView.NATIVE_INIT_FAIL:
              msg = "本地质量控制";
              break;
            default:
              msg = String.valueOf(errorCode);
          }
          String message = "本地质量控制初始化错误，错误原因： " + msg;
          BaiduOcrPlugin.log(message);
        });
  }

}
