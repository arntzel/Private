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

@interface EventDetailPlaceView()

@property (retain, nonatomic) GMSMapView *gmsMapView;
@property(retain, nonatomic) GMSMarker * marker;

@end

@implementation EventDetailPlaceView

- (void)updateUI
{
    [self.contentView.layer setCornerRadius:5.0f];
    [self.contentView.layer setShadowRadius:1.0f];
    [self.contentView.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor];
    [self.contentView.layer setBorderWidth:1.0f];
    

    
    [self.layer setCornerRadius:5.0f];
    [self.layer setShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.16f].CGColor];
    [self.layer setShadowRadius:3.0f];
    [self.layer setShadowOffset:CGSizeMake(0, 1.0f)];
    [self.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor];
    [self.layer setBorderWidth:1.0f];
    
    

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.7294 longitude:-74.00 zoom:12];
    self.gmsMapView = [[GMSMapView mapWithFrame:CGRectMake(0, 0, 152, 59) camera:camera] retain];
    _gmsMapView.settings.compassButton = NO;
    _gmsMapView.camera = camera;
    _gmsMapView.userInteractionEnabled = NO;
    [self.contentView addSubview:_gmsMapView];

    [_gmsMapView.layer setShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.20f].CGColor];
    [_gmsMapView.layer setShadowOffset:CGSizeMake(0, 1.0f)];
    [_gmsMapView.layer setShadowRadius:1.0f];
}

+(EventDetailPlaceView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailPlaceView" owner:self options:nil];
    EventDetailPlaceView * view = (EventDetailPlaceView*)[nibView objectAtIndex:0];
    [view updateUI];
    
    return view;
}

-(void) setLocation:(Location *) location
{
    self.locationNameLabel.text = location.location;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.lat longitude:location.lng zoom:12];
    _gmsMapView.camera = camera;
    // 在map中间做一个标记
    self.marker = [[[GMSMarker alloc] init] autorelease];
    
    _marker.position = CLLocationCoordinate2DMake(location.lat, location.lng);
    _marker.map = _gmsMapView;
    
    _gmsMapView.userInteractionEnabled = NO;
}

- (void)dealloc {
    self.gmsMapView = nil;
    self.locationNameLabel = nil;
    self.marker = nil;
    
    [_contentView release];
    [super dealloc];
}
@end
