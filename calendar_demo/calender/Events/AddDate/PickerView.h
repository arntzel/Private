//
//  PickerView.h
//  AddDate
//
//  Created by zyax86 on 13-7-3.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerViewProtocal.h"


@interface PickerView : UIView<PickerViewProtocal>

@property (nonatomic,assign) id <PickerViewDelegate> delegate;
@property (nonatomic,assign) NSString *UnitString;

- (id)initWithFrame:(CGRect)frame;
- (void)scrollToIndex:(NSInteger)index WithAnimation:(BOOL)animation;
- (void)reloadData;
@end
