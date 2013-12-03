//
//  AddEventPlaceView.m
//  calender
//
//  Created by fang xiang on 13-7-11.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "AddEventPlaceView.h"

#import <GoogleMaps/GoogleMaps.h>
#import "GPlaceApi.h"
#import "GPlaceDataSource.h"

@implementation AddEventPlaceView {

    GMSMapView * gmsMapView;
    GMSMarker *marker;
    UIView *maskView;
}


-(void)dealloc
{
    [maskView release];
    self.label = nil;
    self.btnPickerLocation = nil;

    [marker release];
    
    if(gmsMapView != nil) {
        [gmsMapView removeFromSuperview];
        [gmsMapView release];
    }
    
    [super dealloc];
}

- (void)awakeFromNib
{
    maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 60)];
    [maskView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:maskView];
    [maskView setHidden:YES];
    [maskView setUserInteractionEnabled:NO];
    
    UIView *glassView = [[UIView alloc] initWithFrame:maskView.frame];
    [glassView setAlpha:0.7f];
    [glassView setBackgroundColor:[UIColor whiteColor]];
    [maskView addSubview:glassView];
    [glassView release];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(27, 18, 94, 30)];
    [maskView addSubview:label];
    [label release];
    [label setText:@"Pick a location"];
    [label setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:14]];
    [label setTextColor:[UIColor blackColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *arrawView = [[UIImageView alloc] initWithFrame:CGRectMake(132, 26, 10, 14)];
    [maskView addSubview:arrawView];
    [arrawView release];
    arrawView.image = [UIImage imageNamed:@"arrow.png"];
    
    [self setLocation:nil];
}

-(void) setLocation:(Location*) location
{
    BOOL isLocation = NO;
    if (location == nil || (location.lat == 0 && location.lng == 0)) {
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
    
    self.label.text = location.location;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.lat
                                                            longitude:location.lng
                                                                 zoom:13];
    if(gmsMapView == nil) {

        gmsMapView = [GMSMapView mapWithFrame:self.mapView.bounds camera:camera];
        [gmsMapView retain];
        
        gmsMapView.settings.compassButton = NO;
        [self.mapView addSubview:gmsMapView];
        
    } else {
        gmsMapView.camera = camera;
    }
    
    // 在map中间做一个标记
    
    if (isLocation) {
        if(marker == nil) {
            marker = [[GMSMarker alloc] init];
        }
        marker.position = CLLocationCoordinate2DMake(location.lat, location.lng);
        marker.map = gmsMapView;
    }

    gmsMapView.userInteractionEnabled = NO;
}

@end
