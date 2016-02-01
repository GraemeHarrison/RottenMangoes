//
//  Movie.m
//  RottenMangoes
//
//  Created by Graeme Harrison on 2016-02-01.
//  Copyright © 2016 Graeme Harrison. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (instancetype)initWithTitle:(NSString *)title image:(NSString *)image
{
    self = [super init];
    if (self) {
        _title = title;
        _image = image;
    }
    return self;
}

@end
