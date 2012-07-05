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



@interface RestaurantDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,RestaurantReviewDelegate>
{
    Restaurant* _restaurant; 
    
    YelpReviewProvider* yelpReviewProvider; 
    GoogleReviewProvider* googleReviewProvider; 
}

-(id) initWithRestaurant:(Restaurant*) r; 

- (void) openGoogleMap;

- (void) openRestaurantWebsite; 

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UITableViewCell *googleTableViewCell;
@property (retain, nonatomic) IBOutlet UITableViewCell *yelpTableViewCell;

@property (nonatomic, retain) Restaurant* restaurant; 
@end
