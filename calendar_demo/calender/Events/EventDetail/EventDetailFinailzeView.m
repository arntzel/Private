//
//  EventDetailFinailzeView.m
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailFinailzeView.h"
#import "EventDetailTimeVoteView.h"
#import "EventDetailRoundDateView.h"
#import "Utils.h"

#import <QuartzCore/QuartzCore.h>


static CGFloat const getstureDistance = 50;

@interface EventDetailFinailzeView()<UIGestureRecognizerDelegate>
{
    UIPanGestureRecognizer *panGesture;
}

@property (nonatomic, assign) CGFloat dragStart;
@end


@implementation EventDetailFinailzeView

- (void)dealloc {

    panGesture.delegate = nil;
    [panGesture release];
    
    [_finailzeView release];
    [_finailzeBtn release];
    [_voteStateBtn release];
    [_cfmedLabel release];
    [_declinesLabel release];
    [_removeView release];
    [_contentView release];
    

    self.eventTimeConflictLabel = nil;
    self.eventTimeLabel = nil;
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        
        panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHappened:)];
        panGesture.delegate = self;
        [self addGestureRecognizer:panGesture];
    }
    return self;
}

- (void)setTime:(NSString *)time
{
    self.eventTimeLabel.text = time;
}

- (void)setConflictCount:(NSInteger)count
{
    if (count > 0) {
        self.eventTimeConflictLabel.text = [NSString stringWithFormat:@"%d Conflicts", count];
        [self.eventTimeConflictLabel setHidden:NO];
//        [self.eventTimeLabel setCenter:CGPointMake(self.eventTimeLabel.center.x, 20)];
    }
    else
    {
        //[self.eventTimeLabel setCenter:CGPointMake(self.eventTimeLabel.center.x, self.frame.size.height / 2)];
        [self.eventTimeConflictLabel setHidden:YES];
    }
    
}

-(void) updateView:(ProposeStart *) eventTime
{
//    CGRect frame = self.frame;
//    frame.origin.x = 7;
//    frame.origin.y = 7;
//    self.frame = frame;

    NSString * label = [Utils getProposeStatLabel2:eventTime];
    self.eventTimeLabel.text = label;
    
    self.eventTimeLabel.attributedText = [OHASBasicHTMLParser attributedStringByProcessingMarkupInAttributedString:self.eventTimeLabel.attributedText];
    self.eventTimeLabel.centerVertically = YES;
    
    if(eventTime.finalized == 2) {
        self.userInteractionEnabled = NO;
        self.alpha = ALPHA;
    }
}

- (void)updateUI
{
//    [self.contentView.layer setCornerRadius:5.0f];
//    [self.contentView.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor];
//    [self.contentView.layer setBorderWidth:1.0f];
    
    [self.layer setCornerRadius:5.0f];
    [self.layer setShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.16f].CGColor];
    [self.layer setShadowRadius:3.0f];
    [self.layer setShadowOffset:CGSizeMake(0, 1.0f)];
    [self.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor];
    [self.layer setBorderWidth:1.0f];

    //_finailzeBtn.layer
    _finailzeBtn.layer.cornerRadius = 2;
//    _finailzeBtn.layer.shadowOffset =  CGSizeMake(0, 2);
//    _finailzeBtn.layer.shadowOpacity = 0.8;
//    _finailzeBtn.layer.shadowColor =  [UIColor blackColor].CGColor;
    _finailzeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    [_finailzeBtn.layer setBorderWidth:0.3f];
    //_finailzeBtn.layer.borderWidth = 1.0f;
    
    [_finailzeBtn addTarget:self action:@selector(setFinalze:) forControlEvents:UIControlEventTouchUpInside];
    [self.removeView setHidden:YES];
}

-(void) setFinalze:(id)sender
{
    if(self.delegate != nil) {
        [self.delegate onSetFinilzeTime];
    }
}


- (void)setToFinalizeViewMode
{
    [self.finailzeView setHidden:NO];
    [self.removeView setHidden:YES];
}

- (void)setToRemoveViewMode
{
    [self.finailzeView setHidden:YES];
    [self.removeView setHidden:NO];
}

- (void)gestureHappened:(UIPanGestureRecognizer *)sender
{
	CGPoint translatedPoint = [sender translationInView:self];
	switch (sender.state)
	{
		case UIGestureRecognizerStatePossible:
			
			break;
		case UIGestureRecognizerStateBegan:
			self.dragStart = sender.view.center.x;
			break;
		case UIGestureRecognizerStateChanged:
            if (translatedPoint.x >= 0) {
                self.center = CGPointMake(self.dragStart, self.center.y);
                break;
            }
            else
            {
                self.center = CGPointMake(self.dragStart + translatedPoint.x, self.center.y);
				if (-translatedPoint.x <= getstureDistance)
				{
                    [self setToFinalizeViewMode];
				}
				else
				{
                    [self setToRemoveViewMode];
				}
			}
			break;
		case UIGestureRecognizerStateEnded:
		case UIGestureRecognizerStateCancelled:
			if (translatedPoint.x < 0) {
                if (translatedPoint.x >= 0) {
                    self.center = CGPointMake(self.dragStart, self.center.y);
                }
                else
                {
                    if (-translatedPoint.x <= getstureDistance)
                    {
                        [self doResetPostionAnimation];
                    }
                    else
                    {
                        [self doDismissAnimation];
                    }
                }
            }
			break;
		case UIGestureRecognizerStateFailed:
			
			break;
	}
}

- (void)doResetPostionAnimation
{
    CGPoint resetCenterPoint = CGPointMake(self.dragStart, self.center.y);
    [self animationToCenterPoint:resetCenterPoint];
}

- (void)doDismissAnimation
{
    CGPoint dismissCenterPoint = CGPointMake(self.dragStart - 320, self.center.y);
    [self animationToCenterPoint:dismissCenterPoint];

    [self.delegate onRemovePropseStart];
}

- (void)animationToCenterPoint:(CGPoint)centerPoint
{
    //[self setUserInteractionEnabled:NO];
	[UIView animateWithDuration:0.25 delay:0
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
                         self.center = centerPoint;
					 } completion:^(BOOL finished) {
                         //[self setUserInteractionEnabled:YES];
					 }];
}

#pragma mark - UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
		return YES;
	
	CGPoint translation = [(UIPanGestureRecognizer*)gestureRecognizer translationInView:self];
    return fabs(translation.y) < fabs(translation.x);
}

+(EventDetailFinailzeView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailFinailzeView" owner:self options:nil];
    EventDetailFinailzeView * view = (EventDetailFinailzeView*)[nibView objectAtIndex:0];
    [view updateUI];
    
    return view;
}

+(EventDetailFinailzeView *) creatViewWithStartDate:(NSDate *)date;
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailFinailzeView" owner:self options:nil];
    EventDetailFinailzeView * view = (EventDetailFinailzeView*)[nibView objectAtIndex:0];
    [view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:243.0/255.0 blue:236.0/255.0 alpha:0.7]];
    [view updateUI];
    
    EventDetailRoundDateView *dateView = [[EventDetailRoundDateView alloc]initWithFrame:CGRectMake(0.0, 8.0, 50.0, 50.0) withDate:date];
    [view addSubview:dateView];
    return view;
}
@end
