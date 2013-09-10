//
//  EncryptUtil.h
//  MRCamera
//
//  Created by silson Liu on 12-7-31.
//  Copyright (c) 2012年 Microrapid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncryptUtil : NSObject

+ (NSString *)encryptWithText:(NSString *)sText;
+ (NSString *)decryptWithText:(NSString *)sText;

@end
