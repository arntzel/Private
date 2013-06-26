//
//  YourEventCell.m
//  calender
//
//  Created by xiangfang on 13-6-23.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "YourEventCell.h"

@implementation YourEventCell


-(void) refreshView:(Event*) event
{
    
}


+(YourEventCell*) createView {

    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"YourEventCell" owner:self options:nil];
    YourEventCell * view = (YourEventCell*)[nibView objectAtIndex:0];
    return view;

}

@end
