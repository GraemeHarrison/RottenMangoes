//
//  MovieCell.m
//  RottenMangoes
//
//  Created by Graeme Harrison on 2016-02-01.
//  Copyright © 2016 Graeme Harrison. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

-(void)setMovieCellLabels:(Movie *)movie {
    self.movieTitleLabel.text = movie.title;
}

-(void)setMovieCellImage:(Movie *)movie {
    self.movieImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.movieImageView.clipsToBounds = YES;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:movie.imageURLString]];
    NSURLSessionDownloadTask *download = [session downloadTaskWithRequest:urlRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            
            dispatch_async(dispatch_get_main_queue(),^{
                self.movieImageView.image = image;
            });
        }
    }];
    [download resume];
}

-(void)prepareForReuse {
//    if ([self setMovieCellImage:(Movie *)]) {
//        [[self setMovieCellImage:(Movie *)] cancel];
//    }
}

@end
