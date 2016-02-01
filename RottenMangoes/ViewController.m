//
//  ViewController.m
//  RottenMangoes
//
//  Created by Graeme Harrison on 2016-02-01.
//  Copyright © 2016 Graeme Harrison. All rights reserved.
//

#import "ViewController.h"
#import "Movie.h"
#import "MovieCell.h"
#import "MovieDetailViewController.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *moviesArray;
@property (strong,nonatomic) UICollectionViewFlowLayout *mainLayout;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainLayout = [[UICollectionViewFlowLayout alloc] init];
    self.mainLayout.itemSize = CGSizeMake(200, 200);
    self.mainLayout.minimumInteritemSpacing = 1;
    self.mainLayout.minimumLineSpacing = 1;
    self.mainLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.collectionViewLayout = self.mainLayout;
    self.mainLayout.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame), 40);
    
    self.moviesArray = [[NSMutableArray alloc] init];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=h8ym7ry7kkur36j7ku482y9z";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSError *jsonParsingError;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            if (!jsonParsingError) {
                for (NSDictionary *movieDictionary in jsonData[@"movies"]) {
                    Movie *movie = [[Movie alloc] init];
                    movie.title = movieDictionary[@"title"];
                    movie.image = movieDictionary[@"posters"][@"original"];
                    movie.idNum = movieDictionary[@"id"];
                    [self.moviesArray addObject:movie];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
            }
        }
    }];
    [dataTask resume];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        Movie *movie = self.moviesArray[indexPath.item];
        [movie getReviews];
        MovieDetailViewController *controller = (MovieDetailViewController *)[segue destinationViewController];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.moviesArray.count;
//    return 50;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //Maybe add more sections to view movies that aren't yet in theatres?
    //If method not included it defaults to 1.
    return 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *movieCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCell" forIndexPath:indexPath];
    Movie *movie = self.moviesArray[indexPath.item];
    movieCell.movieTitleLabel.text = movie.title;
    movieCell.movieImageView.contentMode = UIViewContentModeScaleAspectFit;
    movieCell.movieImageView.clipsToBounds = YES;
    movieCell.movieImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:movie.image]]];
    return movieCell;
}

@end
