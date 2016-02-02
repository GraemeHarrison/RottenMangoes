//
//  MapViewController.m
//  RottenMangoes
//
//  Created by Graeme Harrison on 2016-02-02.
//  Copyright © 2016 Graeme Harrison. All rights reserved.
//

#import "MapViewController.h"
#import "Movie.h"
#import "Theatre.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) BOOL initialLocationSet;
@property (strong, nonatomic) NSMutableArray *theatresArray;
@property (strong, nonatomic) NSString *postalCode;
@property (strong, nonatomic) Movie *movie;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    self.initialLocationSet = NO;
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }

    self.theatresArray = [[NSMutableArray alloc]init];
    
//    [self loadTheatreLocationData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)loadTheatreLocationData {
    self.movie = [[Movie alloc]init];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [NSString stringWithFormat:@"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=%@&movie=%@", self.postalCode, self.movie.title];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSError *jsonParsingError;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            if (!jsonParsingError) {
                for (NSDictionary *theatreDictionary in jsonData[@"theatres"]) {
                    Theatre *theatre = [[Theatre alloc] init];
                    theatre.name = theatreDictionary[@"name"];
                    theatre.address = theatreDictionary[@"address"];
                    theatre.idNum = theatreDictionary[@"id"];
                    theatre.coordinate = CLLocationCoordinate2DMake([theatreDictionary[@"lat"]doubleValue], [theatreDictionary[@"lng"]doubleValue]);
                    [self.theatresArray addObject:theatre];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                });
            }
        }
    }];
    [dataTask resume];
    
    for (Theatre *theatre in self.theatresArray) {
        MKPointAnnotation *marker = [[MKPointAnnotation alloc] init];
        marker.coordinate = theatre.coordinate;
        marker.title = theatre.name;
        [self.mapView addAnnotation:marker];
    }
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"Authorization changed");
    
    // If the user's allowed us to use their location, we can start getting location updates
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *userLocation = [locations lastObject];
    
    if (!self.initialLocationSet) {
        self.initialLocationSet = YES;
        
        CLLocationCoordinate2D userCoordinate = userLocation.coordinate;
        MKCoordinateRegion userRegion = MKCoordinateRegionMake(userCoordinate, MKCoordinateSpanMake(0.01, 0.01));
        
        [self.mapView setRegion:userRegion animated:YES];
      
        CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
        [geoCoder reverseGeocodeLocation:userLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (!error) {
                CLPlacemark *placemark = [placemarks lastObject];
                self.postalCode = placemark.postalCode;
                NSLog(@"Postal Code: %@", placemark.postalCode);
                
            }
        }];
    }
    NSLog(@"%@", locations);
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
