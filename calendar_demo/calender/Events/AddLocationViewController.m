

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
    
    GMSMarker *nowLoacalmarker;
    CLLocationManager *manager;
}
@property (weak, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) Location* markedLocation;
@property (strong, nonatomic) NSMutableArray* nearByMarkers;
@end

@implementation AddLocationViewController
@synthesize delegate;
@synthesize mapView;
@synthesize markedLocation;
@synthesize nearByMarkers;

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
        
        self.nearByMarkers = [NSMutableArray array];
    }
    return self;
}

- (GMSMarker *)nowLoacalmarker
{
    if (nowLoacalmarker == nil) {
        nowLoacalmarker = [[GMSMarker alloc] init];
        nowLoacalmarker.map = self.mapView;
        nowLoacalmarker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
    }
    return nowLoacalmarker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
                                                            longitude:151.2086
                                                                 zoom:14];
    
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
        
        for (Location *loc in array) {
            if (![loc.location isEqualToString:self.markedLocation.location]) {
                [mutArray addObject:loc];
            }
        }
        
        [nearByDataSource setData:mutArray];
        [self updateNearByMarkersFromLocations:array];
        [self.nearBySearchTabView reloadData];
    }
}

- (void)updateNearByMarkersFromLocations:(NSArray *)locations
{
    for (GMSMarker *maker in self.nearByMarkers) {
        maker.map = nil;
    }
    
    [self.nearByMarkers removeAllObjects];
    for (Location *loc in locations) {
        if ([loc.location isEqualToString:self.markedLocation.location]) {
            continue;
        }
        
        GMSMarker *nearBymarker = [[GMSMarker alloc] init];
        nearBymarker.map = self.mapView;
        nearBymarker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
        nearBymarker.position = CLLocationCoordinate2DMake(loc.lat, loc.lng);
        nearBymarker.title = loc.location;
        
        [self.nearByMarkers addObject:nearBymarker];
    }
    
}

- (void)didSelectPlace:(Location *)location GPlaceDataSource:(GPlaceDataSource*)dataSource
{
    if (dataSource == txtSearchDataSource) {
        self.markedLocation = location;
        self.txtSearchTabView.hidden = YES;
        currentCoordinate = CLLocationCoordinate2DMake(location.lat, location.lng);
        self.mapView.camera = [GMSCameraPosition cameraWithTarget:currentCoordinate
                                                             zoom:18];
        self.nowLoacalmarker.position = currentCoordinate;
        self.nowLoacalmarker.title = location.location;
        
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
        [GPNearByApi startRequestWithNearBySearchQuery:CGPointMake(currentCoordinate.latitude, currentCoordinate.longitude) Radius:NearBySearchRadius];
        self.mapView.camera = [GMSCameraPosition cameraWithTarget:currentCoordinate
                                                         zoom:16];
    }
}

- (void)viewDidUnload {
    [self setLocationSearchBar:nil];
    [self setTxtSearchTabView:nil];
    [self setNearBySearchTabView:nil];
    [super viewDidUnload];
}
@end
