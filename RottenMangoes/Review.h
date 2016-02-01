//
//  Review.h
//  RottenMangoes
//
//  Created by Graeme Harrison on 2016-02-01.
//  Copyright © 2016 Graeme Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Review : NSObject

@property (strong, nonatomic) NSString *critic;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *freshness;
@property (strong, nonatomic) NSString *publication;
@property (strong, nonatomic) NSString *quote;
@property (strong, nonatomic) NSURL *link;

@end
