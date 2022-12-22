package ren.yanhao.baidu_ocr_plugin;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.baidu.ocr.sdk.OCR;
import com.baidu.ocr.sdk.OnResultListener;
import com.baidu.ocr.sdk.exception.OCRError;
import com.baidu.ocr.sdk.model.AccessToken;
import com.baidu.ocr.ui.camera.CameraActivity;

public class OcrHostApiImpl implements Pigeon.OcrHostApi {
    private final Context context;
    private Activity activity;
    private final Pigeon.RecognizeListenerFlutterApi flutterApi;
//    private boolean hasCameraNativeInitialized = false;

    public OcrHostApiImpl(Context context, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        this.context = context;
        this.flutterApi = flutterApi;
    }

    public void setActivity(Activity activity) {
        this.activity = activity;
    }

    /*
    @Override
    public void initCameraNative() {
        BaiduOcrPlugin.log("initCameraNative, hasCameraNativeInitialized: " + hasCameraNativeInitialized);
        if (hasCameraNativeInitialized) {
            return;
        }
        hasCameraNativeInitialized = true;
        BaiduOcrPlugin.log("OCR.getInstance(context).getLicense(): " + OCR.getInstance(context).getLicense());
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
                    BaiduOcrPlugin.loge(message);
                });
    }*/

    /*
    @Override
    public void releaseCameraNative() {
        BaiduOcrPlugin.log("releaseCameraNative, hasCameraNativeInitialized: " + hasCameraNativeInitialized);
        if (!hasCameraNativeInitialized) {
            return;
        }
        hasCameraNativeInitialized = false;
        CameraNativeHelper.release();
    }*/

    @Override
    public void initAccessTokenWithAkSk(@NonNull Pigeon.InitWithAkSkRequestData request, Pigeon.Result<Pigeon.InitResponseData> result) {
        //noinspection deprecation
        OCR.getInstance(context).initAccessTokenWithAkSk(
                new OnResultListener<AccessToken>() {
                    @Override
                    public void onResult(AccessToken accessToken) {
                        handleInitResult(accessToken, result);
                    }

                    @Override
                    public void onError(OCRError ocrError) {
                        handleInitError(ocrError, result);
                    }
                }, context, request.getAk(), request.getSk());
    }

    @Override
    public void initAccessToken(Pigeon.Result<Pigeon.InitResponseData> result) {
        OCR.getInstance(getApplicationContext()).initAccessToken(new OnResultListener<AccessToken>() {
            @Override
            public void onResult(AccessToken accessToken) {
                handleInitResult(accessToken, result);
            }

            @Override
            public void onError(OCRError ocrError) {
                handleInitError(ocrError, result);
            }
        }, getApplicationContext());
    }

    private void handleInitError(OCRError ocrError, Pigeon.Result<Pigeon.InitResponseData> result) {
        Pigeon.InitResponseData res = new Pigeon.InitResponseData();
        res.setIsSuccess(false);
        res.setOcrError(new Pigeon.OCRErrorResponseData.Builder()
                .setErrorCode((long) ocrError.getErrorCode())
                .setErrorMessage(ocrError.getMessage())
                .build());
        result.success(res);
    }

    private void handleInitResult(AccessToken accessToken, Pigeon.Result<Pigeon.InitResponseData> result) {
        Pigeon.InitResponseData res = new Pigeon.InitResponseData();
        res.setIsSuccess(true);
        res.setAccessToken(accessToken.getAccessToken());
        result.success(res);
    }

    private Context getApplicationContext() {
        return context;
    }

    @Override
    public void recognizeGeneralBasic(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recGeneralBasic(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(context).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_GENERAL_BASIC);
    }

    @Override
    public void recognizeAccurateBasic(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recAccurateBasic(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(context).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_ACCURATE_BASIC);
    }

    @Override
    public void recognizeGeneral(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recGeneral(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_GENERAL);
    }

    @Override
    public void recognizeAccurate(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recAccurate(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_ACCURATE);
    }

    @Override
    public void recognizeGeneralEnhanced(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recGeneralEnhanced(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_GENERAL_ENHANCED);
    }

    @Override
    public void recognizeWebimage(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recGeneralEnhanced(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_GENERAL_WEBIMAGE);
    }

    @Override
    public void recognizeDrivingLicense(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recDrivingLicense(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_DRIVING_LICENSE);
    }

    @Override
    public void recognizeVehicleLicense(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recVehicleLicense(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_VEHICLE_LICENSE);
    }

    @Override
    public void recognizeBusinessLicense(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recBusinessLicense(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_BUSINESS_LICENSE);
    }

    @Override
    public void recognizeReceipt(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recReceipt(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_RECEIPT);
    }

    @Override
    public void recognizeVatInvoice(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recVatInvoice(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_VATINVOICE);
    }

    @Override
    public void recognizeTaxireceipt(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recTaxireceipt(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_TAXIRECEIPT);
    }

    @Override
    public void recognizeLicensePlate(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recLicensePlate(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_LICENSE_PLATE);
    }

    @Override
    public void recognizeVincode(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recVincode(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_VINCODE);
    }

    @Override
    public void recognizeTrainticket(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recTrainticket(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_TRAINTICKET);
    }

    @Override
    public void recognizeNumbers(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recNumbers(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_NUMBERS);
    }

    @Override
    public void recognizeQrcode(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recQrcode(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_QRCODE);
    }

    @Override
    public void recoginzeTripTicket(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recTripTicket(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_TRIP_TICKET);
    }

    @Override
    public void recoginzeVihickleSellInvoice(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recVihickleSellInvoice(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_CAR_SELL_INVOICE);
    }

    @Override
    public void recoginzeVihickleCertificate(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recVihickleCertificate(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_VIHICLE_SERTIFICATION);
    }

    @Override
    public void recoginzeExampleDoc(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recExampleDoc(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_EXAMPLE_DOC_REG);
    }

    @Override
    public void recoginzeWrittenText(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recWrittenText(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_WRITTEN_TEXT);
    }

    @Override
    public void recognizePassport(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recPassport(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_PASSPORT);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_PASSPORT);
    }

    @Override
    public void recoginzeHuKouPage(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recHuKouPage(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_HUKOU_PAGE);
    }

    @Override
    public void recoginzeNormalMachineInvoice(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recNormalMachineInvoice(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_NORMAL_MACHINE_INVOICE);
    }

    @Override
    public void recoginzeweightnote(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recweightnote(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_WEIGHT_NOTE);
    }

    @Override
    public void recoginzemedicaldetail(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recmedicaldetail(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_MEDICAL_DETAIL);
    }

    @Override
    public void recoginzeonlinetaxiitinerary(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.reconlinetaxiitinerary(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_ONLINE_TAXI_ITINERARY);
    }

    @Override
    public void recognizeIdCardFrontNative() {
        this.recognizeIdCardNative(CameraActivity.CONTENT_TYPE_ID_CARD_FRONT);
    }

    @Override
    public void recognizeIdCardBackNative() {
        this.recognizeIdCardNative(CameraActivity.CONTENT_TYPE_ID_CARD_BACK);
    }


    // 身份证正反面
    private void recognizeIdCardNative(String activityContentType) {
        // initCameraNative();
        // KEY_NATIVE_MANUAL 设置了之后 CameraActivity 中不再自动初始化和释放模型
        // 请手动使用CameraNativeHelper初始化和释放模型
        // 推荐这样做，可以避免一些activity切换导致的不必要的异常

        // 手动初始化本地质量控制模型
        // this.initNative();

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(context).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_NATIVE_ENABLE, true);
        intent.putExtra(CameraActivity.KEY_NATIVE_MANUAL, false);
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, activityContentType);
        intent.putExtra(CameraActivity.KEY_NATIVE_TOKEN, OCR.getInstance(context).getLicense());

        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_CAMERA);
    }

    @Override
    public void recognizeBankCard(@Nullable byte[] bytes) {
        if (bytes == null) {
            Intent intent = new Intent(activity, CameraActivity.class);
            intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(context).getAbsolutePath());
            intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_BANK_CARD);
            activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_BANKCARD);
        } else {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recBankCard(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
        }
    }

    @Override
    public void recognizeCustom(@Nullable byte[] bytes) {
        if (bytes != null) {
            FileUtil.saveFile(context, bytes);
            RecognizeService.recCustom(context, FileUtil.getSaveFile(context).getAbsolutePath(), this.flutterApi);
            return;
        }

        Intent intent = new Intent(activity, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH, FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_GENERAL);
        activity.startActivityForResult(intent, PluginDefine.REQUEST_CODE_CUSTOM);
    }


}
