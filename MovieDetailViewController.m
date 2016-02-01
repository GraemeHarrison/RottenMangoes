//
//  MovieDetailViewController.m
//  RottenMangoes
//
//  Created by Graeme Harrison on 2016-02-01.
//  Copyright © 2016 Graeme Harrison. All rights reserved.
//

#import "MovieDetailViewController.h"

@interface MovieDetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *critic1;
@property (strong, nonatomic) IBOutlet UILabel *critic2;
@property (strong, nonatomic) IBOutlet UILabel *critic3;
@property (strong, nonatomic) IBOutlet UILabel *date1;
@property (strong, nonatomic) IBOutlet UILabel *date2;
@property (strong, nonatomic) IBOutlet UILabel *date3;
@property (strong, nonatomic) IBOutlet UILabel *freshness1;
@property (strong, nonatomic) IBOutlet UILabel *freshness2;
@property (strong, nonatomic) IBOutlet UILabel *freshness3;
@property (strong, nonatomic) IBOutlet UILabel *publication1;
@property (strong, nonatomic) IBOutlet UILabel *publication2;
@property (strong, nonatomic) IBOutlet UILabel *publication3;
@property (strong, nonatomic) IBOutlet UILabel *quote1;
@property (strong, nonatomic) IBOutlet UILabel *quote2;
@property (strong, nonatomic) IBOutlet UILabel *quote3;
@property (strong, nonatomic) IBOutlet UILabel *link1;
@property (strong, nonatomic) IBOutlet UILabel *link2;
@property (strong, nonatomic) IBOutlet UILabel *link3;

@end

@implementation MovieDetailViewController

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
        
        Movie *movie = (Movie *) self.detailItem;
        
        if ([movie.reviewsArray count]>0) {
            Review *review1 = [movie.reviewsArray objectAtIndex:0];
            self.critic1.text = [NSString stringWithFormat:@"Critic: %@", review1.critic];
            self.date1.text = [NSString stringWithFormat:@"Date: %@", review1.date];
            self.freshness1.text = [NSString stringWithFormat:@"Freshness: %@", review1.freshness];
            self.publication1.text = [NSString stringWithFormat:@"Publication: %@", review1.publication];
            self.quote1.text = [NSString stringWithFormat:@"Quote: %@", review1.quote];
            self.link1.text = [NSString stringWithFormat:@"Link: %@", review1.link];
        }
        
        if ([movie.reviewsArray count]>1) {
            Review *review2 = [movie.reviewsArray objectAtIndex:1];
            self.critic2.text = [NSString stringWithFormat:@"Critic: %@", review2.critic];
            self.date2.text = [NSString stringWithFormat:@"Date: %@", review2.date];
            self.freshness2.text = [NSString stringWithFormat:@"Freshness: %@", review2.freshness];
            self.publication2.text = [NSString stringWithFormat:@"Publication: %@", review2.publication];
            self.quote2.text = [NSString stringWithFormat:@"Quote: %@", review2.quote];
            self.link2.text = [NSString stringWithFormat:@"Link: %@", review2.link];
        }
        
        if ([movie.reviewsArray count]>2) {
            Review *review3 = [movie.reviewsArray objectAtIndex:2];
            self.critic3.text = [NSString stringWithFormat:@"Critic: %@", review3.critic];
            self.date3.text = [NSString stringWithFormat:@"Date: %@", review3.date];
            self.freshness3.text = [NSString stringWithFormat:@"Freshness: %@", review3.freshness];
            self.publication3.text = [NSString stringWithFormat:@"Publication: %@", review3.publication];
            self.quote3.text = [NSString stringWithFormat:@"Quote: %@", review3.quote];
            self.link3.text = [NSString stringWithFormat:@"Link: %@", review3.link];
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
