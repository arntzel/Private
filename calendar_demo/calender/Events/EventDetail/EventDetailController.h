//
//  ViewController.h
//  detail
//
//  Created by zyax86 on 13-7-27.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"
#import "CoreDataModel.h"

@interface EventDetailController : BaseUIViewController

@property(assign) id<PopDelegate> popDelegate;

@property int eventID;


@end
