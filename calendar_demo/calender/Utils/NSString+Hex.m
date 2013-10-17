//
//  NSString+Hex.m
//  NSData+HexDemo
//
//  Created by zyax86 on 10/17/13.
//  Copyright (c) 2013 iFactory Lab Limited. All rights reserved.
//

#import "NSString+Hex.h"

@implementation NSString (Hex)

- (NSData *)hexData
{
    NSString *theString = [[self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:nil];
    
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= theString.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [theString substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        if ([scanner scanHexInt:&intValue])
            [data appendBytes:&intValue length:1];
    }
    return data;
}



@end
