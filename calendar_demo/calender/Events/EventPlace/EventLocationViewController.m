//
//  EventLocationViewController.m
//  Calvin
//
//  Created by zyax86 on 10/5/13.
//  Copyright (c) 2013 fang xiang. All rights reserved.
//

#import "EventLocationViewController.h"
#import "EventDetailNavigationBar.h"
#import <GoogleMaps/GoogleMaps.h>

@interface EventLocationViewController ()<EventDetailNavigationBarDelegate>
{
    EventDetailNavigationBar *navBar;
    GMSMapView *mapView;
    GMSMarker *myLoacalmarker;
    
    Location *location;
}

//@property(nonatomic,strong) GMSMapView *mapView;

@end

@implementation EventLocationViewController
//@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (GMSMarker *)myLoacalmarker
{
    if (myLoacalmarker == nil) {
        myLoacalmarker = [[GMSMarker alloc] init];
        myLoacalmarker.map = mapView;
        myLoacalmarker.title = @"My Location";
        myLoacalmarker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
    }
    return myLoacalmarker;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addMapView];
    [self addNavBar];

}

- (void)addNavBar
{
    navBar = [EventDetailNavigationBar creatView];
    navBar.rightbtn.hidden = YES;
    navBar.delegate = self;
    [self.view addSubview:navBar];
}

- (void)addMapView
{
    float lat;
    float lng;
    if (location) {
        lat = location.lat;
        lng = location.lng;
    }
    else
    {
        lat = 40.7294;
        lng = -74.00;
    }
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat longitude:lng zoom:16];
    [mapView setCamera:camera];
    mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    mapView.settings.compassButton = YES;
    self.myLoacalmarker.position = CLLocationCoordinate2DMake(lat, lng);
    [self.view addSubview:mapView];
}

- (void)setPlaceLocation:(Location *)location_
{
    location = location_;
}

- (void)leftBtnPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnPress:(id)sender
{
    
}

@end
