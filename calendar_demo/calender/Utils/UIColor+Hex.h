//
//  UIColor+Hex.h
//  Calvin
//
//  Created by Kevin Wu on 11/30/13.
//  Copyright (c) 2013 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+(UIColor *)generateUIColorByHexString:(NSString *)hexString;

+(UIColor *)generateUIColorByHexString:(NSString *)hexString withAlpha:(float) alpha;

@end
