package ren.yanhao.baidu_ocr_plugin;

import android.content.Context;

import com.baidu.ocr.sdk.OCR;
import com.baidu.ocr.sdk.OnResultListener;
import com.baidu.ocr.sdk.exception.OCRError;
import com.baidu.ocr.sdk.model.BankCardParams;
import com.baidu.ocr.sdk.model.GeneralBasicParams;
import com.baidu.ocr.sdk.model.GeneralParams;
import com.baidu.ocr.sdk.model.OcrRequestParams;
import com.baidu.ocr.sdk.model.ResponseResult;

import java.io.File;

public class RecognizeService {
    public static void recBankCard(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        BankCardParams param = new BankCardParams();
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recognizeBankCard(param, getListener(flutterApi));
    }

    public static void recGeneralBasic(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        GeneralBasicParams param = new GeneralBasicParams();
        param.setDetectDirection(true);
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recognizeGeneralBasic(param, getListener(flutterApi));
    }

    public static void recAccurateBasic(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        GeneralParams param = new GeneralParams();
        param.setDetectDirection(true);
        param.setVertexesLocation(true);
        param.setRecognizeGranularity(GeneralParams.GRANULARITY_SMALL);
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recognizeAccurateBasic(param, getListener(flutterApi));
    }

    public static void recGeneral(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        GeneralParams param = new GeneralParams();
        param.setDetectDirection(true);
        param.setVertexesLocation(true);
        param.setRecognizeGranularity(GeneralParams.GRANULARITY_SMALL);
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recognizeGeneral(param, getListener(flutterApi));
    }

    public static void recAccurate(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        GeneralParams param = new GeneralParams();
        param.setDetectDirection(true);
        param.setVertexesLocation(true);
        param.setRecognizeGranularity(GeneralParams.GRANULARITY_SMALL);
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recognizeAccurate(param, getListener(flutterApi));
    }

    public static void recGeneralEnhanced(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        GeneralBasicParams param = new GeneralBasicParams();
        param.setDetectDirection(true);
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recognizeGeneralEnhanced(param, getListener(flutterApi));
    }

    public static void recWebimage(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        GeneralBasicParams param = new GeneralBasicParams();
        param.setDetectDirection(true);
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recognizeWebimage(param, getListener(flutterApi));
    }

    public static void recCustom(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        OcrRequestParams param = new OcrRequestParams();
        param.putParam("templateSign", "");
        param.putParam("classifierId", 0);
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recognizeCustom(param, getListener(flutterApi));
    }

    public static void recDrivingLicense(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        OcrRequestParams param = new OcrRequestParams();
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recognizeDrivingLicense(param, getListener(flutterApi));
    }

    public static void recVehicleLicense(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        OcrRequestParams param = new OcrRequestParams();
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recognizeVehicleLicense(param, getListener(flutterApi));
    }

    public static void recBusinessLicense(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        OcrRequestParams param = new OcrRequestParams();
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recognizeBusinessLicense(param, getListener(flutterApi));
    }

    public static void recReceipt(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        OcrRequestParams param = new OcrRequestParams();
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recognizeReceipt(param, getListener(flutterApi));
    }

    public static void recVatInvoice(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        OcrRequestParams param = new OcrRequestParams();
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recognizeVatInvoice(param, getListener(flutterApi));
    }

    public static void recTaxireceipt(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        OcrRequestParams param = new OcrRequestParams();
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recognizeTaxireceipt(param, getListener(flutterApi));
    }

    public static void recLicensePlate(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        OcrRequestParams param = new OcrRequestParams();
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recognizeLicensePlate(param, getListener(flutterApi));
    }

    public static void recVincode(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        OcrRequestParams param = new OcrRequestParams();
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recognizeVincode(param, getListener(flutterApi));
    }

    public static void recTrainticket(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        OcrRequestParams param = new OcrRequestParams();
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recognizeTrainticket(param, getListener(flutterApi));
    }


    public static void recNumbers(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        OcrRequestParams param = new OcrRequestParams();
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recognizeNumbers(param, getListener(flutterApi));
    }

    public static void recQrcode(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        OcrRequestParams param = new OcrRequestParams();
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recognizeQrcode(param, getListener(flutterApi));
    }

    public static void recTripTicket(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        OcrRequestParams param = new OcrRequestParams();
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recoginzeTripTicket(param, getListener(flutterApi));
    }

    public static void recVihickleSellInvoice(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        OcrRequestParams param = new OcrRequestParams();
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recoginzeVihickleSellInvoice(param, getListener(flutterApi));
    }

    public static void recVihickleCertificate(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        OcrRequestParams param = new OcrRequestParams();
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recoginzeVihickleCertificate(param, getListener(flutterApi));
    }

    public static void recExampleDoc(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        OcrRequestParams param = new OcrRequestParams();
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recoginzeExampleDoc(param, getListener(flutterApi));
    }

    public static void recWrittenText(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        OcrRequestParams param = new OcrRequestParams();
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recoginzeWrittenText(param, getListener(flutterApi));
    }

    public static void recPassport(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        OcrRequestParams param = new OcrRequestParams();
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recognizePassport(param, getListener(flutterApi));
    }

    public static void recHuKouPage(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        OcrRequestParams param = new OcrRequestParams();
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recoginzeHuKouPage(param, getListener(flutterApi));
    }

    public static void recNormalMachineInvoice(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        OcrRequestParams param = new OcrRequestParams();
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recoginzeNormalMachineInvoice(param, getListener(flutterApi));
    }

    public static void recweightnote(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        OcrRequestParams param = new OcrRequestParams();
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recoginzeweightnote(param, getListener(flutterApi));
    }

    public static void recmedicaldetail(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        OcrRequestParams param = new OcrRequestParams();
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recoginzemedicaldetail(param, getListener(flutterApi));
    }

    public static void reconlinetaxiitinerary(Context ctx, String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        OcrRequestParams param = new OcrRequestParams();
        param.setImageFile(new File(filePath));

        notifyFlutterOfStart(filePath, flutterApi);
        OCR.getInstance(ctx).recoginzeonlinetaxiitinerary(param, getListener(flutterApi));
    }


    private static void notifyFlutterOfStart(String filePath, Pigeon.RecognizeListenerFlutterApi flutterApi) {
        BaiduOcrPlugin.log("notifyFlutterOfStart");
//        File imageFile = FileUtil.getSaveFile(ctx);
        byte[] raw = com.baidu.ocr.sdk.tool.FileUtil.reaFileFromSDcard(filePath);
//        final String img = Base64Util.byte2String(raw);

        flutterApi.onReceivedStart(raw, reply -> {
        });
    }

    private static <T extends ResponseResult> OnResultListener<T> getListener(Pigeon.RecognizeListenerFlutterApi flutterApi) {
        return new OnResultListener<T>() {
            @Override
            public void onResult(T result) {
                BaiduOcrPlugin.log("onResult");
                flutterApi.onReceivedResult(result.getJsonRes(), reply -> {
                });
            }

            @Override
            public void onError(OCRError error) {
                BaiduOcrPlugin.log("onError");
                Pigeon.OCRErrorResponseData responseData = new Pigeon.OCRErrorResponseData();
                responseData.setErrorCode((long) error.getErrorCode());
                responseData.setErrorMessage(error.getMessage());
                flutterApi.onReceivedError(responseData, reply -> {
                });
            }
        };
    }

}
