//
//  CustomSwitch.h
//  customSwitch
//
//  Created by zyax86 on 13-7-9.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSwitch : UIControl

- (id)initWithFrame:(CGRect)frame segmentCount:(NSInteger)count;
- (void)setSegTitle:(NSString *)title AtIndex:(NSInteger)index;
- (void)selectIndex:(NSInteger)index;

@property(nonatomic,assign) NSInteger selectedIndex;

@end
