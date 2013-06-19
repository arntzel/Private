

#import "AddLocationViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "GPlaceApi.h"
#import "GPlaceDataSource.h"

#define NearBySearchRadius 5000

@interface AddLocationViewController ()<UISearchBarDelegate,GPlaceApiDelegate,GPlaceDataSourceDelegate>
{
    BOOL firstLocationUpdate_;
    CLLocationCoordinate2D currentCoordinate;
    
    GPlaceApi *GPTxtSearchApi;
    GPlaceApi *GPNearByApi;
    
    GPlaceDataSource *txtSearchDataSource;
    GPlaceDataSource *nearByDataSource;
}
@property (weak, nonatomic) GMSMapView *mapView;
@end

@implementation AddLocationViewController

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
    
    self.nearBySearchTabView.dataSource = nearByDataSource;
    self.nearBySearchTabView.delegate = nearByDataSource;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [GPTxtSearchApi startRequestWithTxtSearchQuery:searchText];
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
        [nearByDataSource setData:array];
        [self.nearBySearchTabView reloadData];
    }

}

- (void)didSelectPlace:(CGPoint)place GPlaceDataSource:(GPlaceDataSource *)dataSource
{
    if (dataSource == txtSearchDataSource) {
        self.txtSearchTabView.hidden = YES;
        currentCoordinate = CLLocationCoordinate2DMake(place.x, place.y);
        self.mapView.camera = [GMSCameraPosition cameraWithTarget:currentCoordinate
                                                             zoom:14];
        
        
        [GPNearByApi startRequestWithNearBySearchQuery:CGPointMake(currentCoordinate.latitude, currentCoordinate.longitude) Radius:NearBySearchRadius];
        [self.locationSearchBar resignFirstResponder];
    }
    else if (dataSource == nearByDataSource)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
