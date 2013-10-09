//
//  EventDetailFinailzeView.m
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailFinailzeView.h"
#import "EventDetailTimeVoteView.h"
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

-(void) updateView:(ProposeStart *) eventTime
{
    CGRect frame = self.frame;
    frame.origin.x = 7;
    frame.origin.y = 7;
    self.frame = frame;

    self.eventTimeLabel.text = [self getTimeLable:eventTime];
    
    if(eventTime.finalized == 2) {
        self.userInteractionEnabled = NO;
        [self.removeView setHidden:YES];
        self.alpha = ALPHA;
    }
}

-(NSString *) getTimeLable:(ProposeStart *) eventTime
{
    NSString * startTime = [Utils formateTimeAMPM:eventTime.start];
    NSString * endTime = [Utils formateTimeAMPM:[eventTime getEndTime]];
    NSString * lable = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
    return lable;
}

- (void)updateUI
{
    [self.contentView.layer setCornerRadius:5.0f];
    [self.contentView.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor];
    [self.contentView.layer setBorderWidth:1.0f];
    
    [self.layer setCornerRadius:5.0f];
    [self.layer setShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.16f].CGColor];
    [self.layer setShadowRadius:3.0f];
    [self.layer setShadowOffset:CGSizeMake(0, 1.0f)];
    [self.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor];
    [self.layer setBorderWidth:1.0f];

    [_finailzeBtn addTarget:self action:@selector(setFinalze:) forControlEvents:UIControlEventTouchUpInside];
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
    [self setUserInteractionEnabled:NO];
	[UIView animateWithDuration:0.25 delay:0
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
                         self.center = centerPoint;
					 } completion:^(BOOL finished) {
                         [self setUserInteractionEnabled:YES];
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
@end
