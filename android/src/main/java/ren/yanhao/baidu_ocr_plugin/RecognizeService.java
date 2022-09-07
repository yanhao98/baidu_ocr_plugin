package ren.yanhao.baidu_ocr_plugin;

import android.content.Context;

import com.baidu.ocr.sdk.OCR;
import com.baidu.ocr.sdk.OnResultListener;
import com.baidu.ocr.sdk.exception.OCRError;
import com.baidu.ocr.sdk.model.BankCardParams;
import com.baidu.ocr.sdk.model.BankCardResult;
import com.baidu.ocr.sdk.model.IDCardParams;
import com.baidu.ocr.sdk.model.IDCardResult;

import java.io.File;

public class RecognizeService {

  public RecognizeService() {
    BaiduOcrPlugin.log("RecognizeService constructor");
  }

  interface ServiceListener {
    void onResult(String jsonResult);

    void onError(String message);
  }

  public static void recognizeIDCard(String idCardSide, Context context, String filePath, final ServiceListener listener) {
    IDCardParams param = new IDCardParams();
    param.setImageFile(new File(filePath));
    // 设置身份证正反面
    param.setIdCardSide(idCardSide);
    // 设置方向检测
    param.setDetectDirection(true);
    // 设置图像参数压缩质量0-100, 越大图像质量越好但是请求时间越长。 不设置则默认值为20
    param.setImageQuality(99);

    OCR.getInstance(context).recognizeIDCard(param, new OnResultListener<IDCardResult>() {
      @Override
      public void onResult(IDCardResult idCardResult) {
        listener.onResult(idCardResult.getJsonRes());
      }

      @Override
      public void onError(OCRError ocrError) {
        listener.onError(ocrError.getMessage());
      }
    });

  }

  public static void recBankCard(Context ctx, String filePath, final ServiceListener listener) {
    BankCardParams param = new BankCardParams();
    param.setImageFile(new File(filePath));
    OCR.getInstance(ctx).recognizeBankCard(param, new OnResultListener<BankCardResult>() {
      @Override
      public void onResult(BankCardResult result) {
                /*String res = String.format("卡号：%s\n类型：%s\n发卡行：%s\n有效日期：%s\n持有者姓名：%s",
                        result.getBankCardNumber(),
                        result.getBankCardType().name(),
                        result.getBankName(),
                        result.getValid_date(),
                        result.getHolder_name());
                listener.onResult(res);*/
        listener.onResult(result.getJsonRes());
      }

      @Override
      public void onError(OCRError error) {
        listener.onResult(error.getMessage());
      }
    });
  }
}
