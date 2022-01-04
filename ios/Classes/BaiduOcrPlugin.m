#import "BaiduOcrPlugin.h"
#import "messages.h"
#import <AipOcrSdk/AipOcrSdk.h>

@interface BaiduOcrPlugin () <OcrHostApi>
//@property(readonly, weak, nonatomic) NSObject<FlutterTextureRegistry>* registry;
@property(readonly, weak, nonatomic) NSObject<FlutterBinaryMessenger>* messenger;
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
    _messenger = [registrar messenger];
    //    _registrar = registrar;
    //    _players = [NSMutableDictionary dictionaryWithCapacity:1];
    return self;
}

- (void)initCameraNativeWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    NSLog(@"initCameraNativeWithError");
}

- (void)initWithAkSkRequest:(nullable InitWithAkSkRequestData *)request completion:(nonnull void (^)(FlutterError * _Nullable))completion {
    NSLog(@"initWithAkSkRequest");
    [[AipOcrService shardService] authWithAK:request.ak andSK:request.sk];
    
    [[AipOcrService shardService] getTokenSuccessHandler:^(NSString *token) {
        completion(nil);
    } failHandler:^(NSError *error) {
        NSString *code =  [NSString stringWithFormat:@"%ld",(long)error.code];
        completion([FlutterError errorWithCode:code message:error.localizedDescription details:nil]);
    }];
}

- (void)recognizeIdCardBackNativeWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    NSLog(@"recognizeIdCardBackNativeWithError");
}

- (void)recognizeIdCardFrontNativeWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    NSLog(@"recognizeIdCardFrontNativeWithError");
}

- (void)releaseCameraNativeWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    NSLog(@"releaseCameraNativeWithError");
}

@end
