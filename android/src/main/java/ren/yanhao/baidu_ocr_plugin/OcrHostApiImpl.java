package ren.yanhao.baidu_ocr_plugin;

import android.content.Context;

import com.baidu.ocr.sdk.OCR;
import com.baidu.ocr.sdk.OnResultListener;
import com.baidu.ocr.sdk.exception.OCRError;
import com.baidu.ocr.sdk.model.AccessToken;

public class OcrHostApiImpl implements Pigeon.OcrHostApi {
  private static final String TAG = "OcrHostApiImpl";
  private final Context ctx;

  public OcrHostApiImpl(Context ctx) {
    this.ctx = ctx;
  }

  @Override
  public void initWithAkSk(Pigeon.InitWithAkSkRequestData request, Pigeon.Result<Void> result) {
    OCR.getInstance(ctx).initAccessTokenWithAkSk(
        new OnResultListener<AccessToken>() {
          @Override
          public void onResult(AccessToken accessToken) {
            result.success(null);
          }

          @Override
          public void onError(OCRError ocrError) {
            result.error(new PluginException(ocrError.getMessage()));
          }
        }, ctx, request.getAk(), request.getSk());
  }
}
