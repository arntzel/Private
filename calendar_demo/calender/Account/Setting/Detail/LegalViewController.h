//
//  LegalViewController.h
//  Calvin
//
//  Created by tu changwei on 13-9-27.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "SettingsBaseViewController.h"
typedef enum LegalType
{
    TermsOfUs = 1,
    PrivacyPolicy,
    AboutUs
    
}legalType;
@interface LegalViewController : SettingsBaseViewController<UIWebViewDelegate>

@property (assign, nonatomic) legalType type;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Indi;

@end
