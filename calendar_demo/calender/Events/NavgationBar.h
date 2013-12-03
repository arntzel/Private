//
//  grayNavgationBar.h
//  test
//
//  Created by zyax86 on 13-7-7.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavgationBarDelegate <NSObject>

- (void)leftNavBtnClick;
- (void)rightNavBtnClick;

@end

@interface NavgationBar : UIImageView

@property(nonatomic, assign) id<NavgationBarDelegate> delegate;

- (void)setTitle:(NSString *)title;
- (void)setLeftBtnText:(NSString *)text;
- (void)setRightBtnText:(NSString *)text;

- (void) setRightBtnHidden:(BOOL)  hidden;

-(void) setRightBtnEnable:(BOOL) enable;

@end
