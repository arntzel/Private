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
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)dealloc
{
    self.label = nil;
    self.btnPick = nil;

    [marker release];
    
    if(gmsMapView != nil) {
        [gmsMapView removeFromSuperview];
        [gmsMapView release];
    }
    
    [super dealloc];
}

-(void) setLocation:(Location*) location
{
    self.label.text = location.location;

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.lat
                                                            longitude:location.lng
                                                                 zoom:10];
    if(gmsMapView == nil) {

        gmsMapView = [GMSMapView mapWithFrame:self.mapView.bounds camera:camera];
        [gmsMapView retain];
        
        gmsMapView.settings.compassButton = YES;
        [self.mapView addSubview:gmsMapView];
        
    } else {
        gmsMapView.camera = camera;
    }
    
    // 在map中间做一个标记
    if(marker == nil) {
        marker = [[GMSMarker alloc] init];
    }
    
    marker.position = CLLocationCoordinate2DMake(location.lat, location.lng);
    marker.map = gmsMapView;
}

@end
