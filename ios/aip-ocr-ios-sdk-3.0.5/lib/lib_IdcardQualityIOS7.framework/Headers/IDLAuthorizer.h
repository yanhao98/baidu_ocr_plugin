//
//  IDLAuthorizer.h
//  idl-license
//
//  Abstract:SDK鉴权器
//  Created by Nick(xuli02) on 15/5/6.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDLAuthorizer : NSObject

@property(nonatomic, strong) NSString *apiKey;
@property(nonatomic, strong) NSString *localLicencePath;

- (void)verifyWithAPIKey:(NSString *)apiKey
           algorithmType:(NSString *)module
     andLocalLicenceFile:(NSString *)licencePath;
- (BOOL)verifyWithToken:(NSString *)givenToken
          algorithmType:(NSString *)module;
- (BOOL)isDone;
- (BOOL)isVerifyed;

@end
