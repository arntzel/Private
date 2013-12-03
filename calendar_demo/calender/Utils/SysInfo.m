//
//  SysInfo.m
//  Calvin
//
//  Created by zyax86 on 10/12/13.
//  Copyright (c) 2013 fang xiang. All rights reserved.
//

#import "SysInfo.h"

@implementation SysInfo

+(double)version
{
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    return version;
}

@end
