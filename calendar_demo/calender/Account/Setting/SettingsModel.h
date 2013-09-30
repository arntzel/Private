//
//  SettingsModel.h
//  Calvin
//
//  Created by tu on 13-9-30.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
//typedef NS_ENUM(NSInteger, ERROCODE) {
//    ERROCODE_OK = 0,   //OK
//    ERROCODE_NETWORK,  //network error
//    ERROCODE_SERVER,   //server errir
//    ERROCODE_UNAUTHORIZED, //unauthorized
//};
typedef enum
{
    ConnectGoogle = 1,
    ConnectFacebook,
    
}ConnectType;
@interface SettingsModel : NSObject

- (void)updateUserEmail:(NSString *)email andCallback:(void (^)(NSInteger error))callback;
- (void)updateUserPwd:(NSMutableDictionary *)dic andCallback:(void (^)(NSInteger error))callback;
- (void)updateConnect:(ConnectType )connectType tokenVale:(NSString *)token IsConnectOrNot:(BOOL)isConnect andCallback:(void (^)(NSInteger error))callback;
@end
