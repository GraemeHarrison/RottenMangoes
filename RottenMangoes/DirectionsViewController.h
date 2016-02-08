//
//  DirectionsViewController.h
//  RottenMangoes
//
//  Created by Graeme Harrison on 2016-02-02.
//  Copyright © 2016 Graeme Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Theatre.h"

@interface DirectionsViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UILabel *theatreLabel;
@property (strong, nonatomic) IBOutlet UITextView *directionsText;
@property (strong, nonatomic) IBOutlet UITextView *routeText;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) Theatre *theatre;
@property (strong, nonatomic) NSString *postalCode;


@end
