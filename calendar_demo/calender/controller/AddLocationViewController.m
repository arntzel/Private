//
//  AddLocationViewController.m
//  calender
//
//  Created by zyax86 on 13-5-26.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "AddLocationViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "GPlaceApi.h"
#import "GPlaceDataSource.h"

@interface AddLocationViewController ()<UISearchBarDelegate,GPlaceApiDelegate,GPlaceDataSourceDelegate>
{
    BOOL firstLocationUpdate_;
    CLLocationCoordinate2D currentCoordinate;
    
    GPlaceApi *GPApi;
    GPlaceDataSource *txtSearchDataSource;
}
@property (weak, nonatomic) GMSMapView *mapView;
@end

@implementation AddLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        GPApi = [[GPlaceApi alloc] init];
        GPApi.delegate = self;
        
        txtSearchDataSource = [[GPlaceDataSource alloc] init];
        txtSearchDataSource.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
                                                            longitude:151.2086
                                                                 zoom:12];
    
    self.mapView = [GMSMapView mapWithFrame:CGRectMake(0, 44, 320, 200) camera:camera];
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    [self.view insertSubview:self.mapView belowSubview:self.locationSearchBar];
    
    
    // Listen to the myLocation property of GMSMapView.
    [self.mapView addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        self.mapView.myLocationEnabled = YES;
    });
    
    
    
    self.locationSearchBar.delegate = self;
    self.txtSearchTabView.dataSource = txtSearchDataSource;
    self.txtSearchTabView.delegate = txtSearchDataSource;
    self.txtSearchTabView.hidden = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [GPApi startRequestWithStringQuery:searchText];
}

- (void)upDateWithArray:(NSArray *)array
{
    [txtSearchDataSource setData:array];
    [self.txtSearchTabView reloadData];
    self.txtSearchTabView.hidden = NO;
}

- (void)didSelectPlace:(CGPoint)place
{
    self.txtSearchTabView.hidden = YES;
    currentCoordinate = CLLocationCoordinate2DMake(place.x, place.y);
    self.mapView.camera = [GMSCameraPosition cameraWithTarget:currentCoordinate
                                                         zoom:14];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - KVO updates

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate_) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        currentCoordinate = location.coordinate;
        self.mapView.camera = [GMSCameraPosition cameraWithTarget:currentCoordinate
                                                         zoom:14];
    }
}

- (void)viewDidUnload {
    [self setLocationSearchBar:nil];
    [self setTxtSearchTabView:nil];
    [self setNearBySearchTabView:nil];
    [super viewDidUnload];
}
@end
