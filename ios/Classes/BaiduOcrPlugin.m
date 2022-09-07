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
@property(readonly, strong, nonatomic) RecognizeListenerFlutterApi* flutterApi;
//@property(readonly, strong, nonatomic) NSMutableDictionary* players;
//@property(readonly, strong, nonatomic) NSObject<FlutterPluginRegistrar>* registrar;
@end

@implementation BaiduOcrPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    BaiduOcrPlugin* instance = [[BaiduOcrPlugin alloc] initWithRegistrar:registrar];
    [registrar publish:instance];
    OcrHostApiSetup(registrar.messenger, instance);
}

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    self = [super init];
    NSAssert(self, @"super init cannot be nil");
    //    _registry = [registrar textures];
    //    _messenger = [registrar messenger];
    _flutterApi = [[RecognizeListenerFlutterApi alloc]initWithBinaryMessenger: [registrar messenger]];
    //    _registrar = registrar;
    //    _players = [NSMutableDictionary dictionaryWithCapacity:1];
    return self;
}

- (void)initCameraNativeWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    NSLog(@"initCameraNativeWithError");
}

- (void)initWithAkSkRequest:(InitWithAkSkRequestData *)request completion:(nonnull void (^)(FlutterError * _Nullable))completion {
    NSLog(@"initWithAkSkRequest");
    [[AipOcrService shardService] authWithAK:request.ak andSK:request.sk];

    [[AipOcrService shardService] getTokenSuccessHandler:^(NSString *token) {
        completion(nil);
    } failHandler:^(NSError *error) {
        NSString *code =  [NSString stringWithFormat:@"%ld",(long)error.code];
        completion([FlutterError errorWithCode:code message:error.localizedDescription details:nil]);
    }];
}

/// 身份证背面扫描识别。
- (void)recognizeIdCardBackNativeWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    NSLog(@"recognizeIdCardBackNativeWithError");
    UIViewController * vc = [AipCaptureCardVC
                             ViewControllerWithCardType:CardTypeLocalIdCardBack
                             andImageHandler:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 开始识别。
            [self->_flutterApi onReceivedStartWithCompletion:^(NSError * _Nullable _) {}];
            // 关闭拍照
            [[[UIApplication sharedApplication].keyWindow rootViewController] dismissViewControllerAnimated:YES completion:nil];
        });
        NSDictionary *options = @{@"detect_direction": @"true"};
        [[AipOcrService shardService]
         detectIdCardBackFromImage:image
         withOptions:options
         successHandler:^(id aipOcrResult){
            NSLog(@"successHandler");
            [self->_flutterApi onReceivedResultResult:[BaiduOcrPlugin dictionaryToJson:aipOcrResult] completion:^(NSError * _Nullable _) {}];
        }
         failHandler:^(NSError *error){
            NSLog(@"failHandler");
        }];
    }];

    // 打开拍照
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

/// 身份证正面扫描识别。
- (void)recognizeIdCardFrontNativeWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    NSLog(@"recognizeIdCardBackNativeWithError");
    UIViewController * vc = [AipCaptureCardVC
                             ViewControllerWithCardType:CardTypeLocalIdCardFont
                             andImageHandler:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 开始识别。
            [self->_flutterApi onReceivedStartWithCompletion:^(NSError * _Nullable _) {}];
            // 关闭拍照
            [[[UIApplication sharedApplication].keyWindow rootViewController] dismissViewControllerAnimated:YES completion:nil];
        });
        NSDictionary *options = @{@"detect_direction": @"true"};
        [[AipOcrService shardService]
         detectIdCardBackFromImage:image
         withOptions:options
         successHandler:^(id aipOcrResult){
            NSLog(@"successHandler");
            [self->_flutterApi onReceivedResultResult:[BaiduOcrPlugin dictionaryToJson:aipOcrResult] completion:^(NSError * _Nullable _) {}];
        }
         failHandler:^(NSError *error){
            NSLog(@"failHandler");
        }];
    }];

    // 打开拍照
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)releaseCameraNativeWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    NSLog(@"releaseCameraNativeWithError");
}

- (void)recognizeBankCardWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    NSLog(@"recognizeBankCardWithError");
}


+ (NSString*)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&parseError];
    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
    
    return jsonStr?:@"";
}

@end
