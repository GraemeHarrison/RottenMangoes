//
//  Movie.h
//  RottenMangoes
//
//  Created by Graeme Harrison on 2016-02-01.
//  Copyright © 2016 Graeme Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Review.h"

@interface Movie : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *idNum;
@property (strong, nonatomic) NSMutableArray *reviewsArray;

-(instancetype)initWithTitle:(NSString*)title image:(NSString*)image;

-(void)getReviews;

@end
