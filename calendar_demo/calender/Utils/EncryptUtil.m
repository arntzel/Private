//
//  EncryptUtil.m
//  MRCamera
//
//  Created by silson Liu on 12-7-31.
//  Copyright (c) 2012年 Microrapid. All rights reserved.
//

#import "EncryptUtil.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

@implementation EncryptUtil
+ (NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOperation == kCCDecrypt)
    {
        NSData *decryptData = [GTMBase64 decodeString:sText];
        plainTextBufferSize = [decryptData length];
        vplainText = (const void *)[decryptData bytes];
    }
    else
    {
        NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [encryptData length];
        vplainText = (const void *)[encryptData bytes];
    }
    
//    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeAES128) & ~(kCCBlockSizeAES128 - 1);
    bufferPtr = malloc( (bufferPtrSize+1) * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize+1);
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    CCCrypt(encryptOperation,
                   kCCAlgorithmAES128,
                   kCCOptionPKCS7Padding | kCCOptionECBMode,
                   keyPtr,
                   kCCBlockSizeAES128,
                   NULL, 
                   vplainText,
                   plainTextBufferSize,
                   (void *)bufferPtr,
                   bufferPtrSize,
                   &movedBytes);

    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt)
    {
        result = [[[NSString alloc] initWithData:[NSData dataWithBytesNoCopy:bufferPtr length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding] autorelease];
    }
    else
    {
        NSData *data = [NSData dataWithBytesNoCopy:bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:data];
    }
    //free(bufferPtr);
    
    return result;
}

+ (NSString *)encryptWithText:(NSString *)sText
{
    NSString *result = [self encrypt:sText encryptOrDecrypt:kCCEncrypt key:@"CalvinApp"];
    return result;
}

+ (NSString *)decryptWithText:(NSString *)sText
{
    NSString *result = [self encrypt:sText encryptOrDecrypt:kCCDecrypt key:@"CalvinApp"];
    return result;
}
@end
