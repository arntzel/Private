

#import "AddLocationViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "GPlaceApi.h"
#import "GPlaceDataSource.h"
#import "NavgationBar.h"
#import "CSqlite.h"
#import "AddLocationTextView.h"

//#define NearBySearchRadius 5000
#define NearBySearchRadius 300

@interface AddLocationViewController ()<UISearchBarDelegate,GPlaceApiDelegate,GPlaceDataSourceDelegate,CLLocationManagerDelegate,NavgationBarDelegate,GMSMapViewDelegate>
{
    BOOL firstLocationUpdate_;
    CLLocationCoordinate2D currentCoordinate;
    CLLocationCoordinate2D myLocationCoordinate;
    
    GPlaceApi *GPTxtSearchApi;
    GPlaceApi *GPNearByApi;
    
    GPlaceDataSource *txtSearchDataSource;
    GPlaceDataSource *nearByDataSource;
    
    GMSMarker *nowLoacalmarker;
    GMSMarker *myLoacalmarker;
    GMSMarker *touchedLoacalmarker;
    CLLocationManager *locationManager;
    
    CSqlite *m_sqlite;
    
    BOOL shouldHiddenTouchedLocation;
    
    //AddLocationTextView *textView;
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
        
        m_sqlite = [[CSqlite alloc]init];
        [m_sqlite openSqlite];
        
       
    }
    return self;
}



- (GMSMarker *)touchedLoacalmarker
{
    if (touchedLoacalmarker == nil) {
        touchedLoacalmarker = [[GMSMarker alloc] init];
        touchedLoacalmarker.map = self.mapView;
        touchedLoacalmarker.title = @"Selected Location";
        //UIImage *iconImage = [UIImage imageNamed:@"colordot1.png"];
        touchedLoacalmarker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];;
    }
    return touchedLoacalmarker;
}

- (GMSMarker *)myLoacalmarker
{
    if (myLoacalmarker == nil) {
        myLoacalmarker = [[GMSMarker alloc] init];
        myLoacalmarker.map = self.mapView;
        myLoacalmarker.title = @"My Location";
        myLoacalmarker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
    }
    return myLoacalmarker;
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
    shouldHiddenTouchedLocation = YES;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.7294 longitude:-74.00 zoom:16];
    
    self.mapView = [GMSMapView mapWithFrame:CGRectMake(0, 88, 320, 156) camera:camera];
    self.mapView.settings.compassButton = YES;
    self.mapView.delegate = self;
//    self.mapView.settings.myLocationButton = YES;
    [self.view insertSubview:self.mapView belowSubview:self.locationSearchBar];
    
    UIButton *btnMyLocation = [[UIButton alloc] initWithFrame:CGRectMake(260, 100, 46, 46)];
    [self.mapView addSubview:btnMyLocation];
    [btnMyLocation setImage:[UIImage imageNamed:@"map_my_location.png"] forState:UIControlStateNormal];
    [btnMyLocation addTarget:self action:@selector(animationToMyLocation) forControlEvents:UIControlEventTouchUpInside];

    self.locationSearchBar.delegate = self;
    
    self.txtSearchTabView.dataSource = txtSearchDataSource;
    self.txtSearchTabView.delegate = txtSearchDataSource;
    self.txtSearchTabView.hidden = YES;
    
    self.nearBySearchTabView.dataSource = nearByDataSource;
    self.nearBySearchTabView.delegate = nearByDataSource;
    
    [self addTopBar];
    
    self.locationInputField.hidden = YES;
    [self.locationInputField addTarget:self action:@selector(addPlace) forControlEvents:UIControlEventEditingDidEndOnExit];

    if(self.location != nil) {
        
        self.locationInputField.text = self.location.location;
        
        self.locationInputField.hidden = NO;
        [self.locationInputField becomeFirstResponder];
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = self.location.lat;
        coordinate.longitude = self.location.lng;

        shouldHiddenTouchedLocation = NO;
        self.mapView.camera = [GMSCameraPosition cameraWithTarget:coordinate zoom:16];
        self.touchedLoacalmarker.position = coordinate;
        self.touchedLoacalmarker.map = mapView;        
    } else {
        [self startLocation];

    }    
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
                                                             zoom:16];
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

- (void)animationToMyLocation
{
    if (myLocationCoordinate.latitude == 0 && myLocationCoordinate.longitude == 0) {
        [self startLocation];
    }
    else
    {
        [mapView animateToLocation:myLocationCoordinate];
    }
}


- (void)startLocation
{
    if ([CLLocationManager locationServicesEnabled])
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter=0.5;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
    }
}

// location success
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    if (!firstLocationUpdate_) {
        firstLocationUpdate_ = YES;
        myLocationCoordinate = newLocation.coordinate;
//        myLocationCoordinate = [self zzTransGPS:myLocationCoordinate];
        self.myLoacalmarker.position = myLocationCoordinate;
        
        [GPNearByApi startRequestWithNearBySearchQuery:CGPointMake(myLocationCoordinate.latitude, myLocationCoordinate.longitude) Radius:NearBySearchRadius];
        self.mapView.camera = [GMSCameraPosition cameraWithTarget:myLocationCoordinate zoom:16];
    }
}

// location failed
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate_) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        myLocationCoordinate = location.coordinate;
        myLocationCoordinate = [self zzTransGPS:myLocationCoordinate];
        self.myLoacalmarker.position = myLocationCoordinate;
        
        [GPNearByApi startRequestWithNearBySearchQuery:CGPointMake(myLocationCoordinate.latitude, myLocationCoordinate.longitude) Radius:NearBySearchRadius];
        self.mapView.camera = [GMSCameraPosition cameraWithTarget:myLocationCoordinate zoom:16];
    }
}

-(CLLocationCoordinate2D)zzTransGPS:(CLLocationCoordinate2D)yGps
{
    int TenLat=0;
    int TenLog=0;
    TenLat = (int)(yGps.latitude*10);
    TenLog = (int)(yGps.longitude*10);
    NSString *sql = [[NSString alloc]initWithFormat:@"select offLat,offLog from gpsT where lat=%d and log = %d",TenLat,TenLog];
    LOG_D(@"%@",sql);
    sqlite3_stmt* stmtL = [m_sqlite NSRunSql:sql];
    int offLat=0;
    int offLog=0;
    while (sqlite3_step(stmtL)==SQLITE_ROW)
    {
        offLat = sqlite3_column_int(stmtL, 0);
        offLog = sqlite3_column_int(stmtL, 1);
        
    }
    
    yGps.latitude = yGps.latitude+offLat*0.0001;
    yGps.longitude = yGps.longitude + offLog*0.0001;
    return yGps;
}

#pragma mark - GMSMapViewDelegate
- (void)mapView:(GMSMapView *)_mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{    
    self.locationInputField.hidden = NO;
    [self.locationInputField becomeFirstResponder];
    self.touchedLoacalmarker.map = mapView;
    self.touchedLoacalmarker.position = coordinate;
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    //[textView dismiss];
    if (shouldHiddenTouchedLocation) {
        self.locationInputField.hidden = YES;
        [self.locationInputField resignFirstResponder];
        self.touchedLoacalmarker.map = nil;
    }
    else
    {
        shouldHiddenTouchedLocation = YES;
    }
}

#pragma mark - AddLocationTextViewDelegate
- (void)addPlace
{
    NSString * placeName = self.locationInputField.text;
    
    Location * location = [[Location alloc] init];
    location.location = placeName;
    location.lat = self.touchedLoacalmarker.position.latitude;
    location.lng = self.touchedLoacalmarker.position.longitude;
    [self.delegate setLocation:location];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
