//
//  RestaurantDetailViewController.h
//  Songhori
//
//  Created by Ali Nouri on 12/16/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"
#import "RestaurantReviewProvider.h"
#import "DYRateView.h" 


@interface RestaurantDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,RestaurantReviewDelegate>
{
    Restaurant* _restaurant; 
    
    YelpReviewProvider* _yelpReviewProvider; 
    GoogleReviewProvider* _googleReviewProvider; 
}

-(id) initWithRestaurant:(Restaurant*) r; 

- (void) openGoogleMap;

- (void) openRestaurantWebsite; 

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UITableViewCell *googleTableViewCell;
@property (retain, nonatomic) IBOutlet UITableViewCell *yelpTableViewCell;
@property (retain, nonatomic) IBOutlet UILabel *yelpNumberOfReviewsLabel;
@property (retain, nonatomic) IBOutlet UILabel *googleNumberOfReviewsLabel;

@property (retain, nonatomic) IBOutlet UIImageView *yelpRatingImageView;
@property (nonatomic, retain) Restaurant* restaurant; 

@property (retain, nonatomic) IBOutlet DYRateView *googleRatingView;

@property (nonatomic, retain) YelpReviewProvider* yelpReviewProvider; 
@property (nonatomic, retain) GoogleReviewProvider* googleReviewProvider; 


@end
