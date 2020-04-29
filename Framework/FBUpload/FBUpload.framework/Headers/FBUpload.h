//
//  FBUpload.h
//  FBUpload
//
//  Created by 王磊 on 2020/4/28.
//  Copyright © 2020 王磊. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for FBUpload.
FOUNDATION_EXPORT double FBUploadVersionNumber;

//! Project version string for FBUpload.
FOUNDATION_EXPORT const unsigned char FBUploadVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <FBUpload/PublicHeader.h>


@import AFNetworking;
NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(FBALCredentialsBean)
@interface FBALCredentialsBean : NSObject

@property (nonatomic ,copy) NSString *accessKeyId;

@property (nonatomic ,copy) NSString *accessKeySecret;

@property (nonatomic ,copy) NSString *securityToken;

@end

NS_SWIFT_NAME(FBUpload)
@interface FBUpload : NSObject

#pragma mark ---- 不是json errorcode 131
+ (void)fetchAliObjWithUrl:(NSString *)url
                 andParams:(NSDictionary *)params
                 andHeader:(NSDictionary *)header
                   andSucc:(nonnull void (^)(FBALCredentialsBean * _Nonnull))success
                   andFail:(nonnull void (^)(NSError * _Nonnull))failure;

+ (void)uploadAvatarWithData:(NSData *)data
                     andFile:(NSString *)file
                      andUid:(NSString *)uid
                   andParams:(FBALCredentialsBean *)credentialsBean
                     andSucc:(void (^)(NSString * _Nonnull))success
                     andFail:(void (^)(NSError * _Nonnull))failure;

+ (void)uploadImageWithData:(NSData *)data
                    andFile:(NSString *)file
                     andUid:(NSString *)uid
                  andParams:(FBALCredentialsBean *)credentialsBean
                    andSucc:(void (^)(NSString * _Nonnull))success
                    andFail:(void (^)(NSError * _Nonnull))failure;

#pragma mark ---- 视频大于10兆 errorcode 132
+ (void)uploadVideoWithData:(NSData *)data
                    andFile:(NSString *)file
                     andUid:(NSString *)uid
                  andParams:(FBALCredentialsBean *)credentialsBean
                    andSucc:(void (^)(NSString * _Nonnull))success
                    andFail:(void (^)(NSError * _Nonnull))failure;

@end

NS_ASSUME_NONNULL_END
