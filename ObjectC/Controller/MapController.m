#import "MapController.h"
#import <GoogleMaps/GoogleMaps.h>
@interface MapController ()
@end
@implementation MapController
- (void)viewDidLoad {
    [super viewDidLoad];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:10.735544682184536
                                                              longitude:106.73095878421248
                                                                   zoom:6];
    GMSMapView *mapView = [GMSMapView mapWithFrame:self.view.frame camera:camera];
    mapView.myLocationEnabled = YES;
		mapView.mapType = kGMSTypeSatellite;
    [self.view addSubview:mapView];

    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(10.735544682184536, 106.73095878421248);
    marker.title = @"Quan 7";
    marker.snippet = @"Viet Nam";
    marker.map = mapView;
}
-(void)viewDidDisappear:(BOOL)animated{

}
@end
