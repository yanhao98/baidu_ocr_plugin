package ren.yanhao.baidu_ocr_plugin;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import androidx.annotation.NonNull;

import com.baidu.ocr.sdk.OCR;
import com.baidu.ocr.sdk.OnResultListener;
import com.baidu.ocr.sdk.exception.OCRError;
import com.baidu.ocr.sdk.model.IDCardParams;
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

                notifyFlutterOfStart();
                OCR.getInstance(ctx).recognizeIDCard(param, getListener());
                // }
                break;
            }
            case PluginDefine.REQUEST_CODE_BANKCARD: {
                RecognizeService.recBankCard(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_GENERAL_BASIC: {
                RecognizeService.recGeneralBasic(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_ACCURATE_BASIC: {
                RecognizeService.recAccurateBasic(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_GENERAL: {
                RecognizeService.recGeneral(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_ACCURATE: {
                RecognizeService.recAccurate(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_GENERAL_ENHANCED: {
                RecognizeService.recGeneralEnhanced(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_GENERAL_WEBIMAGE: {
                RecognizeService.recWebimage(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_DRIVING_LICENSE: {
                RecognizeService.recDrivingLicense(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_VEHICLE_LICENSE: {
                RecognizeService.recVehicleLicense(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_BUSINESS_LICENSE: {
                RecognizeService.recBusinessLicense(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_RECEIPT: {
                RecognizeService.recReceipt(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_VATINVOICE: {
                RecognizeService.recVatInvoice(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_TAXIRECEIPT: {
                RecognizeService.recTaxireceipt(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_LICENSE_PLATE: {
                RecognizeService.recLicensePlate(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_VINCODE: {
                RecognizeService.recVincode(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_TRAINTICKET: {
                RecognizeService.recTrainticket(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_NUMBERS: {
                RecognizeService.recNumbers(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_QRCODE: {
                RecognizeService.recQrcode(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_TRIP_TICKET: {
                RecognizeService.recTripTicket(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_CAR_SELL_INVOICE: {
                RecognizeService.recVihickleSellInvoice(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_VIHICLE_SERTIFICATION: {
                RecognizeService.recVihickleCertificate(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_EXAMPLE_DOC_REG: {
                RecognizeService.recExampleDoc(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_WRITTEN_TEXT: {
                RecognizeService.recWrittenText(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_PASSPORT: {
                RecognizeService.recPassport(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_HUKOU_PAGE: {
                RecognizeService.recHuKouPage(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_NORMAL_MACHINE_INVOICE: {
                RecognizeService.recNormalMachineInvoice(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_WEIGHT_NOTE: {
                RecognizeService.recweightnote(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_MEDICAL_DETAIL: {
                RecognizeService.recmedicaldetail(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_ONLINE_TAXI_ITINERARY: {
                RecognizeService.reconlinetaxiitinerary(ctx, filePath, this.flutterApi);
                break;
            }
            case PluginDefine.REQUEST_CODE_CUSTOM: {
                RecognizeService.recCustom(ctx, filePath, this.flutterApi);
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
        File imageFile = FileUtil.getSaveFile(ctx);
        byte[] raw = com.baidu.ocr.sdk.tool.FileUtil.reaFileFromSDcard(imageFile.getAbsolutePath());
//        final String img = Base64Util.byte2String(raw);

        flutterApi.onReceivedStart(raw, reply -> {
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
