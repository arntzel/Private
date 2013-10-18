//
//  AddDateEntryView.h
//  test
//
//  Created by zyax86 on 13-7-7.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProposeStart.h"

@class AddDateEntryView;
@protocol AddDateEntryViewDelegate <NSObject>

- (void)removeEventDataView:(AddDateEntryView *)dateEntry;

@end

@interface AddDateEntryView : UIView

@property(nonatomic,assign) id<AddDateEntryViewDelegate> delegate;

@property (retain, nonatomic) ProposeStart *eventData;

@property (retain, nonatomic) IBOutlet UIImageView *DateResultView;
@property (retain, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *duringTimeLabel;

+(AddDateEntryView *) createDateEntryView;

@end
