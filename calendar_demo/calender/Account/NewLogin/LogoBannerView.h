//
//  LogoBannerView.h
//  Calvin
//
//  Created by Kevin Wu on 3/8/14.
//  Copyright (c) 2014 Pencil Me, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnboardingViewController.h"
@interface LogoBannerView : UIView
{
    id<OnBoardingViewControllerDelegate> delegate;
}
@property (strong, nonatomic) id<OnBoardingViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIButton *gLoginBtn;
@property (strong, nonatomic) IBOutlet UIButton *otherOptionsBtn;

+(LogoBannerView *) createWithDelegate:(id<OnBoardingViewControllerDelegate>) thedelegate;

@end
