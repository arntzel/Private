//
//  EventDetailHeaderListView.h
//  detail
//
//  Created by 张亚 on 13-8-17.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailHeaderListView : UIView

- (id)initWithHeaderArray:(NSArray *)headerArray andStatusArray:(NSArray *) statusArray andCountLimit:(NSInteger)countLimit ShowArraw:(BOOL)arraw;

@end
