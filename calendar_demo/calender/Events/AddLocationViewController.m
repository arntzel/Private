

#import "AddLocationViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "GPlaceApi.h"
#import "GPlaceDataSource.h"
#import "NavgationBar.h"

//#define NearBySearchRadius 5000
#define NearBySearchRadius 300

@interface AddLocationViewController ()<UISearchBarDelegate,GPlaceApiDelegate,GPlaceDataSourceDelegate,CLLocationManagerDelegate,NavgationBarDelegate>
{
    BOOL firstLocationUpdate_;
    CLLocationCoordinate2D currentCoordinate;
    
    GPlaceApi *GPTxtSearchApi;
    GPlaceApi *GPNearByApi;
    
    GPlaceDataSource *txtSearchDataSource;
    GPlaceDataSource *nearByDataSource;
    
    GMSMarker *marker;
    CLLocationManager *manager;
}
@property (weak, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) Location* markedLocation;
@end

@implementation AddLocationViewController
@synthesize delegate;
@synthesize mapView;
@synthesize markedLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        GPTxtSearchApi = [[GPlaceApi alloc] init];
        GPTxtSearchApi.delegate = self;
        
        GPNearByApi = [[GPlaceApi alloc] init];
        GPNearByApi.delegate = self;
        
        txtSearchDataSource = [[GPlaceDataSource alloc] init];
        txtSearchDataSource.delegate = self;
        
        nearByDataSource = [[GPlaceDataSource alloc] init];
        nearByDataSource.delegate = self;
    }
    return self;
}

- (GMSMarker *)marker
{
    if (marker == nil) {
        marker = [[GMSMarker alloc] init];
        marker.map = self.mapView;
    }
    return marker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
                                                            longitude:151.2086
                                                                 zoom:12];
    
    self.mapView = [GMSMapView mapWithFrame:CGRectMake(0, 88, 320, 156) camera:camera];
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
    
    self.nearBySearchTabView.dataSource = nearByDataSource;
    self.nearBySearchTabView.delegate = nearByDataSource;
    
    [self addTopBar];
}

- (void)addTopBar
{
    NavgationBar * navBar = [[NavgationBar alloc] init];
    [navBar setTitle:@"Add Place"];
    [navBar setLeftBtnText:@"Cancel"];
    [navBar setRightBtnText:@"Add"];
    
    [self.view addSubview:navBar];
    navBar.delegate = self;
    [navBar setRightBtnHidden:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""] || searchText == nil) {
        [self.locationSearchBar resignFirstResponder];
        self.txtSearchTabView.hidden = YES;
    }
    else
    {
        [GPTxtSearchApi startRequestWithTxtSearchQuery:searchText];
    }
}

- (void)upDateWithArray:(NSArray *)array GPlaceApi:(GPlaceApi *)api
{
    if (api == GPTxtSearchApi) {
        [txtSearchDataSource setData:array];
        [self.txtSearchTabView reloadData];
        self.txtSearchTabView.hidden = NO;
    }
    else if (api == GPNearByApi)
    {
        NSMutableArray *mutArray = [NSMutableArray array];
        if (self.markedLocation) {
            [mutArray addObject:self.markedLocation];
        }
        [mutArray addObjectsFromArray:array];
        [nearByDataSource setData:mutArray];
        [self.nearBySearchTabView reloadData];
    }

}

- (void)didSelectPlace:(Location *)location GPlaceDataSource:(GPlaceDataSource*)dataSource
{
    if (dataSource == txtSearchDataSource) {
        self.markedLocation = location;
        self.txtSearchTabView.hidden = YES;
        currentCoordinate = CLLocationCoordinate2DMake(location.lat, location.lng);
        self.mapView.camera = [GMSCameraPosition cameraWithTarget:currentCoordinate
                                                             zoom:14];
        self.marker.position = currentCoordinate;
        [self.mapView animateToLocation:currentCoordinate];        
        
        [GPNearByApi startRequestWithNearBySearchQuery:CGPointMake(currentCoordinate.latitude, currentCoordinate.longitude) Radius:NearBySearchRadius];
        [self.locationSearchBar resignFirstResponder];
    }
    else if (dataSource == nearByDataSource)
    {
        [self.delegate setLocation:location];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)tableViewDidScroll:(GPlaceDataSource *)tableViewSource
{
    if (tableViewSource == nearByDataSource)
    {
        self.txtSearchTabView.hidden = YES;
    }
    
    [self.locationSearchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)leftNavBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavBtnClick
{
    
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
        
        self.mapView.myLocationEnabled = YES;
        
        [GPNearByApi startRequestWithNearBySearchQuery:CGPointMake(currentCoordinate.latitude, currentCoordinate.longitude) Radius:NearBySearchRadius];
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
