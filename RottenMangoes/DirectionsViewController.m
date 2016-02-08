//
//  DirectionsViewController.m
//  RottenMangoes
//
//  Created by Graeme Harrison on 2016-02-02.
//  Copyright © 2016 Graeme Harrison. All rights reserved.
//

#import "DirectionsViewController.h"

@interface DirectionsViewController ()

//@property (strong, nonatomic) NSMutableArray *directionsArray;

@end

@implementation DirectionsViewController

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.theatre) {
        
//        Theatre *theatre = (Theatre *) self.detailItem;
        self.theatreLabel.text = self.theatre.title;
        [self getDirections];
        
        
        
    }
}

- (void)getDirections {
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder geocodeAddressString:self.postalCode completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            CLPlacemark *placemark = [placemarks lastObject];
            CLLocationCoordinate2D userCoordinate = placemark.location.coordinate;
            double userLat = userCoordinate.latitude;
            double userLong = userCoordinate.longitude;
            
            double destinationLat = self.theatre.coordinate.latitude;
            double destinationLong = self.theatre.coordinate.longitude;
            
            MKPlacemark *source = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(userLat, userLong) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil]];
            
            MKMapItem *srcMapItem = [[MKMapItem alloc]initWithPlacemark:source];
            [srcMapItem setName:@""];
            
            MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(destinationLat, destinationLong) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
            
            MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
            [distMapItem setName:@""];
            
            MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
            [request setSource:srcMapItem];
            [request setDestination:distMapItem];
            [request setTransportType:MKDirectionsTransportTypeWalking];
            
            MKDirections *direction = [[MKDirections alloc]initWithRequest:request];
            
            [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
                
                NSLog(@"response = %@",response); // Response
                NSArray *arrRoutes = [response routes];
                [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    
                    MKRoute *route = obj;
                    
//                    MKPolyline *line = [route polyline];
//                    [self.mapView addOverlay:line];
                    NSLog(@"Route Name : %@",route.name); // Route name
                    NSLog(@"Total Distance (in Meters) :%f",route.distance); // Route distance
                    
                    NSArray *steps = [route steps];
                    
                    NSLog(@"Total Steps : %lu",(unsigned long)[steps count]); // Steps count
                    
                    NSMutableArray *directionsArray = [[NSMutableArray alloc]init];
                    [steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        
                        [directionsArray addObject:[obj instructions]];
                        NSString *distance = [NSString stringWithFormat:@"%.2fKm", [obj distance]/1000];
                        [directionsArray addObject:distance];
                        
                        NSLog(@"Instruction : %@",[obj instructions]); // Route instruction
                        NSLog(@"Distance : %f",[obj distance]); // Route distance
                        
                        double distanceInKm = self.theatre.distance / 1000.0;

                        self.directionsText.text = [NSString stringWithFormat:@"Instruction: %@", directionsArray];
                        
                        self.routeText.text = [NSString stringWithFormat:@"Route: %@ \nDistance: %.2f \nSteps: %lu", route.name, distanceInKm, (unsigned long)[steps count]];
                    }];
                }];
            }];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
