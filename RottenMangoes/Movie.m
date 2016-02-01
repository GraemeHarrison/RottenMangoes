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
        _reviewsArray = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)getReviews:(void(^)(void))callBack {
    
    if (!self.reviewsArray) {
        self.reviewsArray = [[NSMutableArray alloc]init];
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies/%@/reviews.json?apikey=j9fhnct2tp8wu2q9h75kanh9&page_limit=3", self.idNum];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            NSError *jsonParsingError;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            NSLog(@"JSON data: %@", jsonData);
            if (!jsonParsingError) {
                NSLog(@"%@", self.title);
                for (NSDictionary *reviewDictionary in jsonData[@"reviews"]) {
                        Review *review = [[Review alloc] init];
                        review.critic = reviewDictionary[@"critic"];
                        review.date = reviewDictionary[@"posters"][@"date"];
                        review.freshness = reviewDictionary[@"freshness"];
                        review.publication = reviewDictionary[@"publication"];
                        review.quote = reviewDictionary[@"quote"];
                        review.link = reviewDictionary[@"link"];
                        [self.reviewsArray addObject:review];
                    NSLog(@"critic: %@", review.critic);

                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.collectionView reloadData];
                    callBack();
                });
            }
        }
    }];
    [dataTask resume];
}


@end
