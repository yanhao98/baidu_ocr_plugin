package ren.yanhao.baidu_ocr_plugin;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import androidx.annotation.NonNull;

import com.baidu.ocr.sdk.OCR;
import com.baidu.ocr.sdk.OnResultListener;
import com.baidu.ocr.sdk.exception.OCRError;
import com.baidu.ocr.sdk.model.BankCardParams;
import com.baidu.ocr.sdk.model.GeneralBasicParams;
import com.baidu.ocr.sdk.model.GeneralParams;
import com.baidu.ocr.sdk.model.IDCardParams;
import com.baidu.ocr.sdk.model.OcrRequestParams;
import com.baidu.ocr.sdk.model.ResponseResult;
import com.baidu.ocr.ui.camera.CameraActivity;

import java.io.File;

import io.flutter.plugin.common.PluginRegistry;

public class ActivityResultDelegate implements PluginRegistry.ActivityResultListener {
    private final Context ctx;
    private final Pigeon.RecognizeListenerFlutterApi flutterApi;

    public ActivityResultDelegate(
            Pigeon.RecognizeListenerFlutterApi recognizeListenerFlutterApi,
            Context context) {
        this.ctx = context;
        this.flutterApi = recognizeListenerFlutterApi;
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        BaiduOcrPlugin.log("onActivityResult, requestCode: " + requestCode + ", resultCode: " + resultCode);

        if (resultCode != Activity.RESULT_OK) {
            return false;
        }

        notifyFlutterOfStart();

        String filePath = FileUtil.getSaveFile(ctx).getAbsolutePath();

        switch (requestCode) {
            case PluginDefine.REQUEST_CODE_CAMERA: {
                // if (data != null) {
                IDCardParams param = new IDCardParams();
                param.setImageFile(new File(filePath));
                // 设置身份证正反面
                String contentType = data.getStringExtra(CameraActivity.KEY_CONTENT_TYPE);
                String idCardSide = null;
                if (CameraActivity.CONTENT_TYPE_ID_CARD_FRONT.equals(contentType)) {
                    idCardSide = IDCardParams.ID_CARD_SIDE_FRONT;
                } else if (CameraActivity.CONTENT_TYPE_ID_CARD_BACK.equals(contentType)) {
                    idCardSide = IDCardParams.ID_CARD_SIDE_BACK;
                }
                param.setIdCardSide(idCardSide);
                // 设置方向检测
                param.setDetectDirection(true);
                // 设置图像参数压缩质量0-100, 越大图像质量越好但是请求时间越长。 不设置则默认值为20
                param.setImageQuality(99);

                OCR.getInstance(ctx).recognizeIDCard(param, getListener());
                // }
                break;
            }
            case PluginDefine.REQUEST_CODE_BANKCARD: {
                BankCardParams param = new BankCardParams();
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recognizeBankCard(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_GENERAL_BASIC: {
                GeneralBasicParams param = new GeneralBasicParams();
                param.setDetectDirection(true);
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recognizeGeneralBasic(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_ACCURATE_BASIC: {
                GeneralParams param = new GeneralParams();
                param.setDetectDirection(true);
                param.setVertexesLocation(true);
                param.setRecognizeGranularity(GeneralParams.GRANULARITY_SMALL);
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recognizeAccurateBasic(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_GENERAL: {
                GeneralParams param = new GeneralParams();
                param.setDetectDirection(true);
                param.setVertexesLocation(true);
                param.setRecognizeGranularity(GeneralParams.GRANULARITY_SMALL);
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recognizeGeneral(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_ACCURATE: {
                GeneralParams param = new GeneralParams();
                param.setDetectDirection(true);
                param.setVertexesLocation(true);
                param.setRecognizeGranularity(GeneralParams.GRANULARITY_SMALL);
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recognizeAccurate(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_GENERAL_ENHANCED: {
                GeneralBasicParams param = new GeneralBasicParams();
                param.setDetectDirection(true);
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recognizeGeneralEnhanced(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_GENERAL_WEBIMAGE: {
                GeneralBasicParams param = new GeneralBasicParams();
                param.setDetectDirection(true);
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recognizeWebimage(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_DRIVING_LICENSE: {
                OcrRequestParams param = new OcrRequestParams();
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recognizeDrivingLicense(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_VEHICLE_LICENSE: {
                OcrRequestParams param = new OcrRequestParams();
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recognizeVehicleLicense(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_BUSINESS_LICENSE: {
                OcrRequestParams param = new OcrRequestParams();
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recognizeBusinessLicense(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_RECEIPT: {
                OcrRequestParams param = new OcrRequestParams();
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recognizeReceipt(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_VATINVOICE: {
                OcrRequestParams param = new OcrRequestParams();
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recognizeVatInvoice(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_TAXIRECEIPT: {
                OcrRequestParams param = new OcrRequestParams();
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recognizeTaxireceipt(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_LICENSE_PLATE: {
                OcrRequestParams param = new OcrRequestParams();
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recognizeLicensePlate(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_VINCODE: {
                OcrRequestParams param = new OcrRequestParams();
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recognizeVincode(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_TRAINTICKET: {
                OcrRequestParams param = new OcrRequestParams();
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recognizeTrainticket(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_NUMBERS: {
                OcrRequestParams param = new OcrRequestParams();
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recognizeNumbers(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_QRCODE: {
                OcrRequestParams param = new OcrRequestParams();
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recognizeQrcode(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_TRIP_TICKET: {
                OcrRequestParams param = new OcrRequestParams();
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recoginzeTripTicket(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_CAR_SELL_INVOICE: {
                OcrRequestParams param = new OcrRequestParams();
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recoginzeVihickleSellInvoice(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_VIHICLE_SERTIFICATION: {
                OcrRequestParams param = new OcrRequestParams();
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recoginzeVihickleCertificate(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_EXAMPLE_DOC_REG: {
                OcrRequestParams param = new OcrRequestParams();
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recoginzeExampleDoc(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_WRITTEN_TEXT: {
                OcrRequestParams param = new OcrRequestParams();
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recoginzeWrittenText(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_PASSPORT: {
                OcrRequestParams param = new OcrRequestParams();
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recognizePassport(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_HUKOU_PAGE: {
                OcrRequestParams param = new OcrRequestParams();
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recoginzeHuKouPage(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_NORMAL_MACHINE_INVOICE: {
                OcrRequestParams param = new OcrRequestParams();
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recoginzeNormalMachineInvoice(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_CUSTOM: {
                OcrRequestParams param = new OcrRequestParams();
                param.putParam("templateSign", "");
                param.putParam("classifierId", 0);
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recognizeCustom(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_WEIGHT_NOTE: {
                OcrRequestParams param = new OcrRequestParams();
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recoginzeweightnote(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_MEDICAL_DETAIL: {
                OcrRequestParams param = new OcrRequestParams();
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recoginzemedicaldetail(param, getListener());
                break;
            }
            case PluginDefine.REQUEST_CODE_ONLINE_TAXI_ITINERARY: {
                OcrRequestParams param = new OcrRequestParams();
                param.setImageFile(new File(filePath));
                OCR.getInstance(ctx).recoginzeonlinetaxiitinerary(param, getListener());
                break;
            }
        }

        return true;
    }

    @NonNull
    private <T extends ResponseResult> OnResultListener<T> getListener() {
        return new OnResultListener<T>() {
            @Override
            public void onResult(T result) {
                notifyFlutterOfResult(result);
            }

            @Override
            public void onError(OCRError error) {
                notifyFlutterOfError(error);
            }
        };
    }

    // 通知flutter识别开始。
    private void notifyFlutterOfStart() {
        flutterApi.onReceivedStart(reply -> {
        });
    }

    // 通知flutter识别结果。
    private void notifyFlutterOfResult(ResponseResult result) {
        flutterApi.onReceivedResult(result.getJsonRes(), reply -> {
        });
    }

    // 通知flutter识别错误。
    private void notifyFlutterOfError(OCRError error) {
        Pigeon.OCRErrorResponseData responseData = new Pigeon.OCRErrorResponseData();
        responseData.setErrorCode((long) error.getErrorCode());
        responseData.setErrorMessage(error.getMessage());
        flutterApi.onReceivedError(responseData, reply -> {
        });
    }
}
