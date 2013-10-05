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
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.7294 longitude:-74.00 zoom:16];
    
    mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    mapView.settings.compassButton = YES;
    [self.view addSubview:mapView];
    
    
    
}

- (void)updatePlaceWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude longitude:longitude zoom:16];
    self.myLoacalmarker.position = CLLocationCoordinate2DMake(latitude, longitude);
    [mapView setCamera:camera];
}

- (void)leftBtnPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnPress:(id)sender
{
    
}

@end
