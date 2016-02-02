//
//  Theatre.h
//  RottenMangoes
//
//  Created by Graeme Harrison on 2016-02-02.
//  Copyright © 2016 Graeme Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Theatre : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *idNum;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (assign, nonatomic) double distance;
@property (nonatomic) CLLocation* location;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
