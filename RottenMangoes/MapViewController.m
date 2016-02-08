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
#import "TheatreTableViewCell.h"
#import "DirectionsViewController.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) BOOL initialLocationSet;
@property (strong, nonatomic) NSMutableArray *theatresArray;
@property (strong, nonatomic) NSString *postalCode;
@property (assign, nonatomic) BOOL isPostalCodeSet;
@property (strong, nonatomic) Movie *movie;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *textField;

@end

@implementation MapViewController

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        
        self.movie = (Movie*) self.detailItem;
        //        NSLog(@"movie title: %@", self.movie.title);
        
        self.initialLocationSet = NO;
        self.isPostalCodeSet = NO;
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        self.theatresArray = [[NSMutableArray alloc]init];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.textField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)loadTheatreLocationData:(CLLocation*)location {
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [NSString stringWithFormat:@"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=%@&movie=%@", [self.postalCode stringByReplacingOccurrencesOfString:@" " withString:@"%20"], [self.movie.title stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSError *jsonParsingError;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            if (!jsonParsingError) {
                for (NSDictionary *theatreDictionary in jsonData[@"theatres"]) {
                    Theatre *theatre = [[Theatre alloc] init];
                    theatre.title = theatreDictionary[@"name"];
                    theatre.subtitle = theatreDictionary[@"address"];
                    theatre.idNum = theatreDictionary[@"id"];
                    theatre.coordinate = CLLocationCoordinate2DMake([theatreDictionary[@"lat"]doubleValue], [theatreDictionary[@"lng"]doubleValue]);
                    theatre.location = [[CLLocation alloc]initWithLatitude:theatre.coordinate.latitude longitude:theatre.coordinate.longitude];
                    theatre.distance = [location distanceFromLocation:theatre.location];
                    [self.theatresArray addObject:theatre];
                }
                if (self.theatresArray.count == 0) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Something Ain't Right"
                                                                                             message:@"Dude, this movie ain't showing here yo."
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                    //We add buttons to the alert controller by creating UIAlertActions:
                    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:nil]; //You can use a block here to handle a press on this button
                    [alertController addAction:actionOk];
                    [self presentViewController:alertController animated:YES completion:nil];                    }
                
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES];
                self.theatresArray = [[self.theatresArray sortedArrayUsingDescriptors:@[sortDescriptor] ]mutableCopy];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //                        for (Theatre *theatre in self.theatresArray) {
                    //                            MKPointAnnotation *marker = [[MKPointAnnotation alloc] init];
                    //                            marker.coordinate = theatre.coordinate;
                    //                            marker.title = theatre.title;
                    //                            marker.subtitle = theatre.subtitle;
                    //                            [self.mapView addAnnotation:marker];
                    //                        }
                    [self.mapView addAnnotations:self.theatresArray];
                    [self.tableView reloadData];
                });
            }
        }
    }];
    [dataTask resume];
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    //    NSLog(@"Authorization changed");
    
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
        MKCoordinateRegion userRegion = MKCoordinateRegionMake(userCoordinate, MKCoordinateSpanMake(0.08, 0.08));
        [self.mapView setRegion:userRegion animated:YES];
        
        CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
        [geoCoder reverseGeocodeLocation:userLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (!error) {
                CLPlacemark *placemark = [placemarks lastObject];
                self.postalCode = placemark.postalCode;
                [self loadTheatreLocationData:userLocation];
            }
        }];
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textField) {
        [self.theatresArray removeAllObjects];
        self.postalCode = self.textField.text;
        [self.textField resignFirstResponder];
        
        CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
        [geoCoder geocodeAddressString:self.postalCode completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (!error) {
                CLPlacemark *placemark = [placemarks lastObject];
                CLLocation *location = placemark.location;
                CLLocationCoordinate2D userCoordinate = placemark.location.coordinate;
                MKCoordinateRegion userRegion = MKCoordinateRegionMake(userCoordinate, MKCoordinateSpanMake(0.08, 0.08));
                [self.mapView setRegion:userRegion animated:YES];
                [self loadTheatreLocationData:location];
            }
        }];
    }
    return YES;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.theatresArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TheatreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TheatreCell" forIndexPath:indexPath];
    Theatre *theatre = self.theatresArray[indexPath.row];
    cell.theatreTitle.text = theatre.title;
    double distanceInKm = theatre.distance / 1000.0;
    cell.distanceLabel.text = [NSString stringWithFormat:@"Distance: %.2fKm",distanceInKm];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    Theatre *theatre = self.theatresArray[indexPath.row];
//    [self getDirections:theatre];
    }

//-(void)getDirections:(Theatre *)theatre {
//    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
//    [geoCoder geocodeAddressString:self.postalCode completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        if (!error) {
//            CLPlacemark *placemark = [placemarks lastObject];
//            CLLocationCoordinate2D userCoordinate = placemark.location.coordinate;
//            double userLat = userCoordinate.latitude;
//            double userLong = userCoordinate.longitude;
//            
//            double destinationLat = theatre.coordinate.latitude;
//            double destinationLong = theatre.coordinate.longitude;
//            
//            MKPlacemark *source = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(userLat, userLong) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil]];
//            
//            MKMapItem *srcMapItem = [[MKMapItem alloc]initWithPlacemark:source];
//            [srcMapItem setName:@""];
//            
//            MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(destinationLat, destinationLong) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
//            
//            MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
//            [distMapItem setName:@""];
//            
//            MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
//            [request setSource:srcMapItem];
//            [request setDestination:distMapItem];
//            [request setTransportType:MKDirectionsTransportTypeWalking];
//            
//            MKDirections *direction = [[MKDirections alloc]initWithRequest:request];
//            
//            [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
//                
//                NSLog(@"response = %@",response); // Response
//                NSArray *arrRoutes = [response routes];
//                [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                    
//                    MKRoute *route = obj;
//                    
//                    MKPolyline *line = [route polyline];
//                    [self.mapView addOverlay:line];
//                    NSLog(@"Rout Name : %@",route.name); // Route name
//                    NSLog(@"Total Distance (in Meters) :%f",route.distance); // Route distance
//                    
//                    NSArray *steps = [route steps];
//                    
//                    NSLog(@"Total Steps : %lu",(unsigned long)[steps count]); // Steps count
//                    
//                    [steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                        NSLog(@"Rout Instruction : %@",[obj instructions]); // Route instruction
//                        NSLog(@"Rout Distance : %f",[obj distance]); // Route distance
//                    }];
//                }];
//            }];
//        }
//    }];
//
//}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDirections"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Theatre *theatre = self.theatresArray[indexPath.row];
        DirectionsViewController *controller = (DirectionsViewController *)[segue destinationViewController];
        controller.theatre = theatre;
        controller.postalCode = self.postalCode;
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

//
//- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
//}

@end
