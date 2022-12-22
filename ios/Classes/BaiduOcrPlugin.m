#import "BaiduOcrPlugin.h"
#import "messages.h"
#import <AipOcrSdk/AipOcrSdk.h>
//#import <AipBase/AipBase.h>
//#import <IdcardQuality/IdcardQuality.h>
//#include <stdlib.h>
//#include <vector>

@interface BaiduOcrPlugin () <OcrHostApi>
//@property(readonly, weak, nonatomic) NSObject<FlutterTextureRegistry>* registry;
//@property(readonly, weak, nonatomic) NSObject<FlutterBinaryMessenger>* messenger;
@property(readonly, strong, nonatomic) RecognizeListenerFlutterApi *flutterApi;
//@property(readonly, strong, nonatomic) NSMutableDictionary* players;
//@property(readonly, strong, nonatomic) NSObject<FlutterPluginRegistrar>* registrar;
@end

// 默认的识别成功的回调
void (^_successHandler)(id);

// 默认的识别失败的回调
void (^_failHandler)(NSError *);

@implementation BaiduOcrPlugin
+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    BaiduOcrPlugin *instance = [[BaiduOcrPlugin alloc] initWithRegistrar:registrar];
    [registrar publish:instance];
    OcrHostApiSetup(registrar.messenger, instance);
}

- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    self = [super init];
    NSAssert(self, @"super init cannot be nil");
    //    _registry = [registrar textures];
    //    _messenger = [registrar messenger];
    _flutterApi = [[RecognizeListenerFlutterApi alloc] initWithBinaryMessenger:[registrar messenger]];
    //    _registrar = registrar;
    //    _players = [NSMutableDictionary dictionaryWithCapacity:1];

    [self configCallback];

    return self;
}

- (void)configCallback {
//    __weak typeof(self) weakSelf = self;

    // 这是默认的识别成功的回调
    _successHandler = ^(id aipOcrResult) {
        [self notifyFlutterOfResult:aipOcrResult];
    };

    _failHandler = ^(NSError *error) {
        [self notifyFlutterOfError:error];
    };
}

- (void)presentViewController:(UIViewController *)vc {
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
//    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [viewController presentViewController:vc animated:YES completion:nil];
}

- (void)dismissView {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 关闭拍照
        [[UIApplication sharedApplication].delegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    });
}

// 字典转json
- (NSString *)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;

    return jsonStr ?: @"";
}

// 通知Flutter端开始识别。
- (void)notifyFlutterOfStart:(UIImage *)image {
    [self dismissView];
    FlutterStandardTypedData *_Nonnull imageBytes = [FlutterStandardTypedData typedDataWithBytes:UIImageJPEGRepresentation(image, 1.0f)];
    [self->_flutterApi onReceivedStartImageBytes:imageBytes completion:^(NSError *error) {
    }];
}


// 通知Flutter端识别结果。
- (void)notifyFlutterOfResult:(id)aipOcrResult {
    [self->_flutterApi onReceivedResultJsonResult:[self dictionaryToJson:aipOcrResult] completion:^(NSError *_Nullable _) {
    }];
}

// 通知Flutter端识别错误。
- (void)notifyFlutterOfError:(NSError *)err {
    NSString *msg = [NSString stringWithFormat:@"%li:%@", (long) [err code], [err localizedDescription]];
    [self->_flutterApi onReceivedErrorOcrErrorResponseData:[OCRErrorResponseData makeWithErrorCode:@(err.code) errorMessage:msg] completion:^(NSError *_Nullable _) {
    }];
}

// 通知Flutter端初始化结果。
- (void)notifyInitData:(void (^ _Nonnull)(InitResponseData *, FlutterError *))completion {
    [[AipOcrService shardService] getTokenSuccessHandler:^(NSString *token) {
        InitResponseData *data = [InitResponseData makeWithIsSuccess:@YES accessToken:token ocrError:nil];
        completion(data, nil);
    }                                        failHandler:^(NSError *error) {
        OCRErrorResponseData *ocrError = [OCRErrorResponseData makeWithErrorCode:@(error.code) errorMessage:error.localizedDescription];
        InitResponseData *data = [InitResponseData makeWithIsSuccess:@NO accessToken:nil ocrError:ocrError];
        completion(data, nil);
    }];
}

- (void)initAccessTokenWithAkSkRequest:(nonnull InitWithAkSkRequestData *)request completion:(nonnull void (^)(InitResponseData *_Nullable, FlutterError *_Nullable))completion {
    [[AipOcrService shardService] authWithAK:request.ak andSK:request.sk];
    [self notifyInitData:completion];
}

- (void)initAccessTokenWithCompletion:(void (^)(InitResponseData *, FlutterError *))completion {
    NSString *licenseFile = [[NSBundle mainBundle] pathForResource:@"aip" ofType:@"license"];
    NSData *licenseFileData = [NSData dataWithContentsOfFile:licenseFile];
    if (!licenseFileData) {
        [[[UIAlertView alloc] initWithTitle:@"授权失败" message:@"授权文件不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        OCRErrorResponseData *ocrError = [OCRErrorResponseData makeWithErrorCode:@(283503) errorMessage:@"授权文件不存在"];
        InitResponseData *data = [InitResponseData makeWithIsSuccess:@NO accessToken:nil ocrError:ocrError];
        completion(data, nil);
    } else {
        [[AipOcrService shardService] authWithLicenseFileData:licenseFileData];
        [self notifyInitData:completion];
    }
}

- (void)recognizeCustomBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    NSDictionary *options = @{@"templateSign": @"123"};

    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] iOCRRecognitionFromImage:image withOptions:options successHandler:_successHandler failHandler:_failHandler];
        return;
    }

    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];

        [[AipOcrService shardService] iOCRRecognitionFromImage:image withOptions:options successHandler:_successHandler failHandler:_failHandler];
    }];
    // 打开拍照
    [self presentViewController:vc];
}


// 银行卡正面拍照识别
- (void)recognizeBankCardBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectBankCardFromImage:image successHandler:_successHandler failHandler:_failHandler];
        return;
    }

    UIViewController *vc = [AipCaptureCardVC ViewControllerWithCardType:CardTypeBankCard andImageHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectBankCardFromImage:image successHandler:_successHandler failHandler:_failHandler];
    }]; // 打开拍照
    [self presentViewController:vc];
}

/// 身份证背面扫描识别。
- (void)recognizeIdCardBackNativeWithError:(FlutterError **)error {
    UIViewController *vc = [AipCaptureCardVC ViewControllerWithCardType:CardTypeLocalIdCardBack andImageHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectIdCardBackFromImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
    }];

    // 打开拍照
    [self presentViewController:vc];
}

/// 身份证正面扫描识别。
- (void)recognizeIdCardFrontNativeWithError:(FlutterError **)error {
    UIViewController *vc = [AipCaptureCardVC ViewControllerWithCardType:CardTypeLocalIdCardFont andImageHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        // 不准
        NSDictionary *options = @{@"detect_risk": @"false"};

        [[AipOcrService shardService] detectIdCardFrontFromImage:image withOptions:options successHandler:_successHandler failHandler:_failHandler];
    }];

    // 打开拍照
    [self presentViewController:vc];
}

// 通用文字识别
- (void)recognizeGeneralBasicBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};

    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectTextBasicFromImage:image withOptions:options successHandler:_successHandler failHandler:_failHandler];
        return;
    }

    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectTextBasicFromImage:image withOptions:options successHandler:_successHandler failHandler:_failHandler];
    }];
    [self presentViewController:vc];
}

- (void)recognizeAccurateBasicBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};
    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectTextAccurateBasicFromImage:image withOptions:options successHandler:_successHandler failHandler:_failHandler];
        return;
    }

    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectTextAccurateBasicFromImage:image withOptions:options successHandler:_successHandler failHandler:_failHandler];
    }];
    [self presentViewController:vc];
}

- (void)recognizeGeneralBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};
    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectTextFromImage:image withOptions:options successHandler:_successHandler failHandler:_failHandler];
        return;
    }
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectTextFromImage:image withOptions:options successHandler:_successHandler failHandler:_failHandler];
    }];
    // 打开拍照
    [self presentViewController:vc];
}

- (void)recognizeAccurateBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};

    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectTextAccurateFromImage:image withOptions:options successHandler:_successHandler failHandler:_failHandler];
        return;
    }
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];

        [[AipOcrService shardService] detectTextAccurateFromImage:image withOptions:options successHandler:_successHandler failHandler:_failHandler];
    }];
    // 打开拍照
    [self presentViewController:vc];
}

- (void)recognizeGeneralEnhancedBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};

    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectTextEnhancedFromImage:image withOptions:options successHandler:_successHandler failHandler:_failHandler];
        return;
    }
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectTextEnhancedFromImage:image withOptions:options successHandler:_successHandler failHandler:_failHandler];
    }];
    // 打开拍照
    [self presentViewController:vc];
}

- (void)recognizeWebimageBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectWebImageFromImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
        return;
    }
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectWebImageFromImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
    }];
    // 打开拍照
    [self presentViewController:vc];
}

- (void)recognizeDrivingLicenseBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectDrivingLicenseFromImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
        return;
    }
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectDrivingLicenseFromImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
    }];
    // 打开拍照
    [self presentViewController:vc];
}

- (void)recognizeVehicleLicenseBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    NSDictionary *options = @{@"vehicle_license_side": @"front"};
    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectVehicleLicenseFromImage:image withOptions:options successHandler:_successHandler failHandler:_failHandler];
        return;
    }
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectVehicleLicenseFromImage:image withOptions:options successHandler:_successHandler failHandler:_failHandler];
    }];
    // 打开拍照
    [self presentViewController:vc];
}

- (void)recognizeBusinessLicenseBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectBusinessLicenseFromImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
        return;
    }
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectBusinessLicenseFromImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
    }];
    // 打开拍照
    [self presentViewController:vc];
}

- (void)recognizeReceiptBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectReceiptFromImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
        return;
    }
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectReceiptFromImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
    }];
    // 打开拍照
    [self presentViewController:vc];
}

- (void)recognizeVatInvoiceBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectValueAddedTaxImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
        return;
    }
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectValueAddedTaxImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
    }];
    // 打开拍照
    [self presentViewController:vc];
}

- (void)recognizeTaxireceiptBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectTaxiReceiptImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
        return;
    }
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectTaxiReceiptImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
    }];
    // 打开拍照
    [self presentViewController:vc];
}

- (void)recognizeLicensePlateBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectPlateNumberFromImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
        return;
    }
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectPlateNumberFromImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
    }];
    // 打开拍照
    [self presentViewController:vc];
}

- (void)recognizeVincodeBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectVinCodeImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
        return;
    }
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectVinCodeImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
    }];
    // 打开拍照
    [self presentViewController:vc];
}

- (void)recognizeTrainticketBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectTrainTicketImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
        return;
    }
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectTrainTicketImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
    }];
    // 打开拍照
    [self presentViewController:vc];
}

- (void)recognizeNumbersBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectNumbersImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
        return;
    }
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectNumbersImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
    }];
    // 打开拍照
    [self presentViewController:vc];
}

- (void)recognizeQrcodeBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] qrcodeImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
        return;
    }
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] qrcodeImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
    }];
    // 打开拍照
    [self presentViewController:vc];
}

- (void)recoginzeTripTicketBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] airTicketImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
        return;
    }
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] airTicketImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
    }];
    // 打开拍照
    [self presentViewController:vc];
}

- (void)recoginzeVihickleSellInvoiceBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] vehicleInvoiceImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
        return;
    }
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] vehicleInvoiceImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
    }];
    // 打开拍照
    [self presentViewController:vc];
}

- (void)recoginzeVihickleCertificateBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] vehicleCertificateImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
        return;
    }
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] vehicleCertificateImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
    }];
    // 打开拍照
    [self presentViewController:vc];
}

- (void)recoginzeExampleDocBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] docAnalysisImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
        return;
    }
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] docAnalysisImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
    }];
    // 打开拍照
    [self presentViewController:vc];
}

- (void)recoginzeWrittenTextBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] handwritingImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
        return;
    }
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] handwritingImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
    }];
    // 打开拍照
    [self presentViewController:vc];
}

- (void)recognizePassportBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] passportImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
        return;
    }
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] passportImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
    }];
    // 打开拍照
    [self presentViewController:vc];
}

- (void)recoginzeHuKouPageBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] householdRegisterImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
        return;
    }
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] householdRegisterImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
    }];
    // 打开拍照
    [self presentViewController:vc];
}

- (void)recoginzeNormalMachineInvoiceBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectValueAddedTaxImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
        return;
    }
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] detectValueAddedTaxImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
    }];
    // 打开拍照
    [self presentViewController:vc];
}

- (void)recoginzeweightnoteBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] weightNoteImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
        return;
    }
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] weightNoteImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
    }];
    // 打开拍照
    [self presentViewController:vc];
}

- (void)recoginzemedicaldetailBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] medicalDetailImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
        return;
    }

    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] medicalDetailImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
    }];
    // 打开拍照
    [self presentViewController:vc];
}

- (void)recoginzeonlinetaxiitineraryBytes:(FlutterStandardTypedData *)bytes error:(FlutterError **)error {
    if (bytes != nil) {
        UIImage *image = [UIImage imageWithData:bytes.data];
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] onlineTaxiItineraryImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
        return;
    }

    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart:image];
        [[AipOcrService shardService] onlineTaxiItineraryImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];
    }];
    // 打开拍照
    [self presentViewController:vc];
}


@end
