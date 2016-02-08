//
//  MovieCell.h
//  RottenMangoes
//
//  Created by Graeme Harrison on 2016-02-01.
//  Copyright © 2016 Graeme Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *movieImageView;

-(void)setMovieCellLabels:(Movie *)movie;
-(void)setMovieCellImage:(Movie *)movie;

@end
