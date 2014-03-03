
//
//  EventDetailPlaceView.m
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailPlaceView.h"
#import <QuartzCore/QuartzCore.h>
#import <GoogleMaps/GoogleMaps.h>
#import "GPlaceApi.h"
#import "UIColor+Hex.h"

@interface EventDetailPlaceView()
{
    UIView *maskView;
    BOOL isLocation;
}

@property (retain, nonatomic) GMSMapView *gmsMapView;
@property(retain, nonatomic) GMSMarker * marker;

@end

@implementation EventDetailPlaceView

- (void)updateUI
{
    isLocation = NO;
    //[self setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.2]];
    [self setBackgroundColor:[UIColor clearColor]];
//    [self.contentView.layer setCornerRadius:5.0f];
//    [self.contentView.layer setShadowRadius:1.0f];
//    [self.contentView.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor];
//    [self.contentView.layer setBorderWidth:1.0f];
    

    
//    [self.layer setCornerRadius:5.0f];
//    [self.layer setShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.16f].CGColor];
//    [self.layer setShadowRadius:3.0f];
//    [self.layer setShadowOffset:CGSizeMake(0, 1.0f)];
//    [self.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor];
//    [self.layer setBorderWidth:1.0f];
    
    

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:CAL_DEFAULT_LOCATION_LAT longitude:CAL_DEFAULT_LOCATION_LNG zoom:12];
    self.gmsMapView = [GMSMapView mapWithFrame:CGRectMake(5, 27, 145, 40) camera:camera];
    _gmsMapView.settings.compassButton = NO;
    _gmsMapView.camera = camera;
    _gmsMapView.userInteractionEnabled = NO;
    [self.contentView addSubview:_gmsMapView];
    
    

    [_gmsMapView.layer setShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.20f].CGColor];
    [_gmsMapView.layer setShadowOffset:CGSizeMake(0, 1.0f)];
    [_gmsMapView.layer setShadowRadius:1.0f];
    
    [[self locationNameLabel] setTextColor:[UIColor generateUIColorByHexString:@"#7c7c7c"]];

}

- (void)addMask:(BOOL)canChangeLocation
{
    maskView = [[UIView alloc] initWithFrame:CGRectMake(2, 13, 147, 40)];
    [maskView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:maskView];
    [maskView setHidden:YES];
    [maskView setUserInteractionEnabled:NO];
    
    UIView *glassView = [[UIView alloc] initWithFrame:maskView.frame];
    [glassView setAlpha:0.7f];
    [glassView setBackgroundColor:[UIColor whiteColor]];
    [glassView.layer setCornerRadius:3.0f];
    [glassView.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.2f].CGColor];
    [glassView.layer setBorderWidth:1.0f];
    [glassView.layer setShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.20f].CGColor];
    [glassView.layer setShadowOffset:CGSizeMake(0, 1.0f)];
    [glassView.layer setShadowRadius:1.0f];
    [maskView addSubview:glassView];
    
    if (canChangeLocation) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(27, 18, 94, 30)];
        [maskView addSubview:label];
        [label setText:@"Pick a location"];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
        [label setTextColor:[UIColor blackColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *arrawView = [[UIImageView alloc] initWithFrame:CGRectMake(132, 26, 10, 14)];
        [maskView addSubview:arrawView];
        arrawView.image = [UIImage imageNamed:@"notch.png"];
    }
}

+(EventDetailPlaceView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailPlaceView" owner:self options:nil];
    EventDetailPlaceView * view = (EventDetailPlaceView*)[nibView objectAtIndex:0];
    [view updateUI];
    
    return view;
}

- (BOOL)haveLocation
{
    return isLocation;
}

-(void) setLocation:(Location *) location
{
    return;
    
    if (location == nil ) {
        isLocation = NO;
    }
    else
    {
        isLocation = YES;
    }
    
    if (isLocation == NO) {
        location = [[Location alloc] init];
        location.lat = CAL_DEFAULT_LOCATION_LAT;
        location.lng = CAL_DEFAULT_LOCATION_LNG;
        location.location = @"No Location";
        
        [maskView setHidden:NO];
    }
    else
    {
        [maskView setHidden:YES];
    }
    
    self.locationNameLabel.text = location.location;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.lat longitude:location.lng zoom:12];
    _gmsMapView.camera = camera;
    
    if (isLocation) {
        // 在map中间做一个标记
        self.marker = [[GMSMarker alloc] init];
        _marker.position = CLLocationCoordinate2DMake(location.lat, location.lng);
        _marker.map = _gmsMapView;
    }

    
    _gmsMapView.userInteractionEnabled = NO;
}

- (void)dealloc {
    self.gmsMapView = nil;
    self.locationNameLabel = nil;
    self.marker = nil;
}
@end
