//
//  loginMainView.h
//  test
//
//  Created by zyax86 on 8/26/13.
//  Copyright (c) 2013 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginMainAccessViewDelegate <NSObject>

- (void)btnSignUpSelected;

- (void)btnSignInSelected;

@end

@interface LoginMainAccessView : UIView

@property(nonatomic,weak) id<LoginMainAccessViewDelegate> delegate;

+ (LoginMainAccessView *)creatView;

@end
