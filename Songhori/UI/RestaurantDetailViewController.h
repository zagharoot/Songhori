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

//   This is the page we go to when we click on the restaurant popover view (to view more details/reviews) 

@interface RestaurantDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,RestaurantReviewDelegate>
{
    Restaurant* _restaurant; 
    
    //These are the review providers. Since there are not a lot of them, I haven't put them in an array etc.
    YelpReviewProvider* _yelpReviewProvider; 
    GoogleReviewProvider* _googleReviewProvider; 
}

-(id) initWithRestaurant:(Restaurant*) r; 


- (void) openGoogleMap;             //launches the map application with the restaurant in the center of it. 

- (void) openRestaurantWebsite;     //opens up the website for the restaurant (if available) 

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
