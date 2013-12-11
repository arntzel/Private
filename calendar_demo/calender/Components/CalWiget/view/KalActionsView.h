//
//  KalActionsView.h
//  Calvin
//
//  Created by Kevin Wu on 12/9/13.
//  Copyright (c) 2013 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol KalViewDelegate;
@interface KalActionsView : UIView
{
    id<KalViewDelegate> delegate;
}

-(id)initWithFrame:(CGRect)frame withDelegate:(id<KalViewDelegate>)theDelegate;
@end
