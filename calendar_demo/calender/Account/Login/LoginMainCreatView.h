//
//  LoginMainCreatView.h
//  login
//
//  Created by zyax86 on 9/23/13.
//  Copyright (c) 2013 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginMainCreatViewDelegate <NSObject>

- (void)btnFacebookSignUpDidClick;

- (void)btnGoogleSignUpDidClick;

- (void)btnSignUpDidClickWithName:(NSString *)name Email:(NSString *)_email Password:(NSString *)_password HeadPhoto:(UIImage *)headPhoto;
@end

@interface LoginMainCreatView : UIView

+(LoginMainCreatView *) creatView;

@property(nonatomic,weak) id<LoginMainCreatViewDelegate> delegate;

@end
