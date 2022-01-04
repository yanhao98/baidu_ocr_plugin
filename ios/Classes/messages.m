// Autogenerated from Pigeon (v1.0.12), do not edit directly.
// See also: https://pub.dev/packages/pigeon
#import "messages.h"
#import <Flutter/Flutter.h>

#if !__has_feature(objc_arc)
#error File requires ARC to be enabled.
#endif

static NSDictionary<NSString *, id> *wrapResult(id result, FlutterError *error) {
  NSDictionary *errorDict = (NSDictionary *)[NSNull null];
  if (error) {
    errorDict = @{
        @"code": (error.code ? error.code : [NSNull null]),
        @"message": (error.message ? error.message : [NSNull null]),
        @"details": (error.details ? error.details : [NSNull null]),
        };
  }
  return @{
      @"result": (result ? result : [NSNull null]),
      @"error": errorDict,
      };
}

@interface InitWithAkSkRequestData ()
+ (InitWithAkSkRequestData *)fromMap:(NSDictionary *)dict;
- (NSDictionary *)toMap;
@end

@implementation InitWithAkSkRequestData
+ (InitWithAkSkRequestData *)fromMap:(NSDictionary *)dict {
  InitWithAkSkRequestData *result = [[InitWithAkSkRequestData alloc] init];
  result.ak = dict[@"ak"];
  if ((NSNull *)result.ak == [NSNull null]) {
    result.ak = nil;
  }
  result.sk = dict[@"sk"];
  if ((NSNull *)result.sk == [NSNull null]) {
    result.sk = nil;
  }
  return result;
}
- (NSDictionary *)toMap {
  return [NSDictionary dictionaryWithObjectsAndKeys:(self.ak ? self.ak : [NSNull null]), @"ak", (self.sk ? self.sk : [NSNull null]), @"sk", nil];
}
@end

@interface OcrHostApiCodecReader : FlutterStandardReader
@end
@implementation OcrHostApiCodecReader
- (nullable id)readValueOfType:(UInt8)type 
{
  switch (type) {
    case 128:     
      return [InitWithAkSkRequestData fromMap:[self readValue]];
    
    default:    
      return [super readValueOfType:type];
    
  }
}
@end

@interface OcrHostApiCodecWriter : FlutterStandardWriter
@end
@implementation OcrHostApiCodecWriter
- (void)writeValue:(id)value 
{
  if ([value isKindOfClass:[InitWithAkSkRequestData class]]) {
    [self writeByte:128];
    [self writeValue:[value toMap]];
  } else 
{
    [super writeValue:value];
  }
}
@end

@interface OcrHostApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation OcrHostApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[OcrHostApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[OcrHostApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *OcrHostApiGetCodec() {
  static dispatch_once_t s_pred = 0;
  static FlutterStandardMessageCodec *s_sharedObject = nil;
  dispatch_once(&s_pred, ^{
    OcrHostApiCodecReaderWriter *readerWriter = [[OcrHostApiCodecReaderWriter alloc] init];
    s_sharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return s_sharedObject;
}


void OcrHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<OcrHostApi> *api) {
  {
    FlutterBasicMessageChannel *channel =
      [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.OcrHostApi.initWithAkSk"
        binaryMessenger:binaryMessenger
        codec:OcrHostApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(initWithAkSkRequest:completion:)], @"OcrHostApi api (%@) doesn't respond to @selector(initWithAkSkRequest:completion:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        InitWithAkSkRequestData *arg_request = args[0];
        [api initWithAkSkRequest:arg_request completion:^(FlutterError *_Nullable error) {
          callback(wrapResult(nil, error));
        }];
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.OcrHostApi.recognizeIdCardFrontNative"
        binaryMessenger:binaryMessenger
        codec:OcrHostApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(recognizeIdCardFrontNativeWithError:)], @"OcrHostApi api (%@) doesn't respond to @selector(recognizeIdCardFrontNativeWithError:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        [api recognizeIdCardFrontNativeWithError:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.OcrHostApi.recognizeIdCardBackNative"
        binaryMessenger:binaryMessenger
        codec:OcrHostApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(recognizeIdCardBackNativeWithError:)], @"OcrHostApi api (%@) doesn't respond to @selector(recognizeIdCardBackNativeWithError:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        [api recognizeIdCardBackNativeWithError:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.OcrHostApi.initCameraNative"
        binaryMessenger:binaryMessenger
        codec:OcrHostApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(initCameraNativeWithError:)], @"OcrHostApi api (%@) doesn't respond to @selector(initCameraNativeWithError:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        [api initCameraNativeWithError:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.OcrHostApi.releaseCameraNative"
        binaryMessenger:binaryMessenger
        codec:OcrHostApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(releaseCameraNativeWithError:)], @"OcrHostApi api (%@) doesn't respond to @selector(releaseCameraNativeWithError:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        [api releaseCameraNativeWithError:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
}
@interface RecognizeListenerFlutterApiCodecReader : FlutterStandardReader
@end
@implementation RecognizeListenerFlutterApiCodecReader
@end

@interface RecognizeListenerFlutterApiCodecWriter : FlutterStandardWriter
@end
@implementation RecognizeListenerFlutterApiCodecWriter
@end

@interface RecognizeListenerFlutterApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation RecognizeListenerFlutterApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[RecognizeListenerFlutterApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[RecognizeListenerFlutterApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *RecognizeListenerFlutterApiGetCodec() {
  static dispatch_once_t s_pred = 0;
  static FlutterStandardMessageCodec *s_sharedObject = nil;
  dispatch_once(&s_pred, ^{
    RecognizeListenerFlutterApiCodecReaderWriter *readerWriter = [[RecognizeListenerFlutterApiCodecReaderWriter alloc] init];
    s_sharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return s_sharedObject;
}


@interface RecognizeListenerFlutterApi ()
@property (nonatomic, strong) NSObject<FlutterBinaryMessenger> *binaryMessenger;
@end

@implementation RecognizeListenerFlutterApi
- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)binaryMessenger {
  self = [super init];
  if (self) {
    _binaryMessenger = binaryMessenger;
  }
  return self;
}

- (void)onReceivedStartWithCompletion:(void(^)(NSError *_Nullable))completion {
  FlutterBasicMessageChannel *channel =
    [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.RecognizeListenerFlutterApi.onReceivedStart"
      binaryMessenger:self.binaryMessenger
      codec:RecognizeListenerFlutterApiGetCodec()];
  [channel sendMessage:nil reply:^(id reply) {
    completion(nil);
  }];
}
- (void)onReceivedResultResult:(NSString *)arg_result completion:(void(^)(NSError *_Nullable))completion {
  FlutterBasicMessageChannel *channel =
    [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.RecognizeListenerFlutterApi.onReceivedResult"
      binaryMessenger:self.binaryMessenger
      codec:RecognizeListenerFlutterApiGetCodec()];
  [channel sendMessage:@[arg_result] reply:^(id reply) {
    completion(nil);
  }];
}
- (void)onReceivedErrorDescription:(NSString *)arg_description completion:(void(^)(NSError *_Nullable))completion {
  FlutterBasicMessageChannel *channel =
    [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.RecognizeListenerFlutterApi.onReceivedError"
      binaryMessenger:self.binaryMessenger
      codec:RecognizeListenerFlutterApiGetCodec()];
  [channel sendMessage:@[arg_description] reply:^(id reply) {
    completion(nil);
  }];
}
@end
