//
//  ShareLoginBase.h
//  MRCamera
//
//  Created by 亚 张 on 12-8-14.
//  Copyright (c) 2012年 Microrapid. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShareLoginBase;

@protocol ShareLoginDelegate <NSObject>
@optional
- (void)shareDidLogin:(ShareLoginBase *)shareLogin;
- (void)shareDidNotLogin:(ShareLoginBase *)shareLogin;
- (void)shareDidNotNetWork:(ShareLoginBase *)shareLogin;
- (void)shareDidLogout:(ShareLoginBase *)shareLogin;
- (void)shareDidLoginErr:(ShareLoginBase *)shareLogin;
- (void)shareDidLoginTimeOut:(ShareLoginBase *)shareLogin;
@end

@interface ShareLoginBase : NSObject

@property(nonatomic,assign) id<ShareLoginDelegate> delegate;

- (void)shareLogin;
- (void)shareLoginOut;

@end
