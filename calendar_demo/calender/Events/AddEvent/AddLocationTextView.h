//
//  AddLocationTextView.h
//  calender
//
//  Created by zyax86 on 9/3/13.
//  Copyright (c) 2013 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddLocationTextViewDelegate <NSObject>

- (void)addPlace:(NSString *)placeName;

@end

@interface AddLocationTextView : UIView

@property(nonatomic, assign) id<AddLocationTextViewDelegate> delegate;

- (void)dismiss;
- (void)show;

+ (AddLocationTextView *)createView;

@end
