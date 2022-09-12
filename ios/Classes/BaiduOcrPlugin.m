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


/// 身份证背面扫描识别。
- (void)recognizeIdCardBackNativeWithError:(FlutterError **)error {
    UIViewController *vc = [AipCaptureCardVC
            ViewControllerWithCardType:CardTypeLocalIdCardBack
                       andImageHandler:^(UIImage *image) {
                           [self notifyFlutterOfStart];

                           [[AipOcrService shardService]
                                   detectIdCardBackFromImage:image
                                                 withOptions:nil
                                              successHandler:_successHandler
                                                 failHandler:_failHandler];
                       }];

    // 打开拍照
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}


/// 身份证正面扫描识别。
- (void)recognizeIdCardFrontNativeWithError:(FlutterError **)error {
    UIViewController *vc = [AipCaptureCardVC
            ViewControllerWithCardType:CardTypeLocalIdCardFont
                       andImageHandler:^(UIImage *image) {
                           [self notifyFlutterOfStart];
                           // 不准
                           NSDictionary *options = @{@"detect_risk": @"false"};

                           [[AipOcrService shardService]
                                   detectIdCardFrontFromImage:image
                                                  withOptions:options
                                               successHandler:_successHandler
                                                  failHandler:_failHandler];
                       }];

    // 打开拍照
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}


// 银行卡正面拍照识别
- (void)recognizeBankCardWithError:(FlutterError **)error {
    UIViewController *vc = [AipCaptureCardVC ViewControllerWithCardType:CardTypeBankCard andImageHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];
        [[AipOcrService shardService] detectBankCardFromImage:image
                                               successHandler:_successHandler
                                                  failHandler:_failHandler];
    }];


    // 打开拍照
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}


- (void)recognizeGeneralBasicWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];

        NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};
        [[AipOcrService shardService] detectTextBasicFromImage:image
                                                   withOptions:options
                                                successHandler:_successHandler
                                                   failHandler:_failHandler];

    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recognizeAccurateBasicWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];

        NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};

        [[AipOcrService shardService] detectTextAccurateBasicFromImage:image
                                                           withOptions:options
                                                        successHandler:_successHandler
                                                           failHandler:_failHandler];

    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recognizeGeneralWithError:(FlutterError **)error {

    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];
        // 在这个block里，image即为切好的图片，可自行选择如何处理
        NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};
        [[AipOcrService shardService] detectTextFromImage:image
                                              withOptions:options
                                           successHandler:_successHandler
                                              failHandler:_failHandler];

    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recognizeAccurateWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];
        NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};
        [[AipOcrService shardService] detectTextAccurateFromImage:image
                                                      withOptions:options
                                                   successHandler:_successHandler
                                                      failHandler:_failHandler];

    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recognizeGeneralEnhancedWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];
        NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};
        [[AipOcrService shardService] detectTextEnhancedFromImage:image
                                                      withOptions:options
                                                   successHandler:_successHandler
                                                      failHandler:_failHandler];

    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recognizeWebimageWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];
        [[AipOcrService shardService] detectWebImageFromImage:image
                                                  withOptions:nil
                                               successHandler:_successHandler
                                                  failHandler:_failHandler];
    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recognizeDrivingLicenseWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];
        [[AipOcrService shardService] detectDrivingLicenseFromImage:image
                                                        withOptions:nil
                                                     successHandler:_successHandler
                                                        failHandler:_failHandler];

    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recognizeVehicleLicenseWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];
        NSDictionary *options = @{@"vehicle_license_side": @"front"};
        [[AipOcrService shardService] detectVehicleLicenseFromImage:image
                                                        withOptions:options
                                                     successHandler:_successHandler
                                                        failHandler:_failHandler];
    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recognizeBusinessLicenseWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];
        [[AipOcrService shardService] detectBusinessLicenseFromImage:image
                                                         withOptions:nil
                                                      successHandler:_successHandler
                                                         failHandler:_failHandler];

    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recognizeReceiptWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];
        [[AipOcrService shardService] detectReceiptFromImage:image
                                                 withOptions:nil
                                              successHandler:_successHandler
                                                 failHandler:_failHandler];

    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recognizeVatInvoiceWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];
        [[AipOcrService shardService] detectValueAddedTaxImage:image
                                                   withOptions:nil
                                                successHandler:_successHandler
                                                   failHandler:_failHandler];

    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recognizeTaxireceiptWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];
        [[AipOcrService shardService] detectTaxiReceiptImage:image
                                                 withOptions:nil
                                              successHandler:_successHandler
                                                 failHandler:_failHandler];

    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recognizeLicensePlateWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];
        [[AipOcrService shardService] detectPlateNumberFromImage:image
                                                     withOptions:nil
                                                  successHandler:_successHandler
                                                     failHandler:_failHandler];

    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recognizeVincodeWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];
        [[AipOcrService shardService] detectVinCodeImage:image
                                             withOptions:nil
                                          successHandler:_successHandler
                                             failHandler:_failHandler];

    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recognizeTrainticketWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];
        [[AipOcrService shardService] detectTrainTicketImage:image
                                                 withOptions:nil
                                              successHandler:_successHandler
                                                 failHandler:_failHandler];

    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recognizeNumbersWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];
        [[AipOcrService shardService] detectNumbersImage:image
                                             withOptions:nil
                                          successHandler:_successHandler
                                             failHandler:_failHandler];

    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recognizeQrcodeWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];
        [[AipOcrService shardService] qrcodeImage:image withOptions:nil successHandler:_successHandler failHandler:_failHandler];

    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recoginzeTripTicketWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];
        [[AipOcrService shardService] airTicketImage:image
                                         withOptions:nil
                                      successHandler:_successHandler
                                         failHandler:_failHandler];

    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recoginzeVihickleSellInvoiceWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];
        [[AipOcrService shardService] vehicleInvoiceImage:image
                                              withOptions:nil
                                           successHandler:_successHandler
                                              failHandler:_failHandler];

    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recoginzeVihickleCertificateWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];
        [[AipOcrService shardService] vehicleCertificateImage:image
                                                  withOptions:nil
                                               successHandler:_successHandler
                                                  failHandler:_failHandler];

    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recoginzeExampleDocWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];
        [[AipOcrService shardService] docAnalysisImage:image
                                           withOptions:nil
                                        successHandler:_successHandler
                                           failHandler:_failHandler];

    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recoginzeWrittenTextWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];
        [[AipOcrService shardService] handwritingImage:image
                                           withOptions:nil
                                        successHandler:_successHandler
                                           failHandler:_failHandler];

    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recognizePassportWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];
        [[AipOcrService shardService] passportImage:image
                                        withOptions:nil
                                     successHandler:_successHandler
                                        failHandler:_failHandler];

    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recoginzeHuKouPageWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];
        [[AipOcrService shardService] householdRegisterImage:image
                                                 withOptions:nil
                                              successHandler:_successHandler
                                                 failHandler:_failHandler];

    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recoginzeNormalMachineInvoiceWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];
        [[AipOcrService shardService] detectValueAddedTaxImage:image
                                                   withOptions:nil
                                                successHandler:_successHandler
                                                   failHandler:_failHandler];

    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recognizeCustomWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];

        NSDictionary *options = @{@"templateSign": @"123"};
        [[AipOcrService shardService] iOCRRecognitionFromImage:image
                                                   withOptions:options
                                                successHandler:_successHandler
                                                   failHandler:_failHandler];

    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recoginzeweightnoteWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];
        [[AipOcrService shardService] weightNoteImage:image
                                          withOptions:nil
                                       successHandler:_successHandler
                                          failHandler:_failHandler];

    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recoginzemedicaldetailWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];
        [[AipOcrService shardService] medicalDetailImage:image
                                             withOptions:nil
                                          successHandler:_successHandler
                                             failHandler:_failHandler];

    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)recoginzeonlinetaxiitineraryWithError:(FlutterError **)error {
    UIViewController *vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        [self notifyFlutterOfStart];
        [[AipOcrService shardService] onlineTaxiItineraryImage:image
                                                   withOptions:nil
                                                successHandler:_successHandler
                                                   failHandler:_failHandler];

    }];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}


- (NSString *)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;

    return jsonStr ?: @"";
}


// 通知Flutter端开始识别。
- (void)notifyFlutterOfStart {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 关闭拍照
        [[[UIApplication sharedApplication].keyWindow rootViewController] dismissViewControllerAnimated:YES completion:nil];
    });
    [self->_flutterApi onReceivedStartWithCompletion:^(NSError *_Nullable _) {
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
    [[AipOcrService shardService]
            getTokenSuccessHandler:^(NSString *token) {
                InitResponseData *data = [InitResponseData makeWithIsSuccess:@YES accessToken:token ocrError:nil];
                completion(data, nil);
            } failHandler:^(NSError *error) {
        OCRErrorResponseData *ocrError = [OCRErrorResponseData makeWithErrorCode:@(error.code) errorMessage:error.localizedDescription];
        InitResponseData *data = [InitResponseData makeWithIsSuccess:@NO accessToken:nil ocrError:ocrError];
        completion(data, nil);
    }];
}

@end
