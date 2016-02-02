//
//  Theatre.h
//  RottenMangoes
//
//  Created by Graeme Harrison on 2016-02-02.
//  Copyright © 2016 Graeme Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Theatre : NSObject

@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *idNum;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;

@end
