//
//  RestaurantDetailViewController.h
//  Songhori
//
//  Created by Ali Nouri on 12/16/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"
#import "DYRateView.h" 
#import "RestaurantReviewTableViewCell.h" 


//   This is the page we go to when we click on the restaurant popover view (to view more details/reviews) 

@interface RestaurantDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    Restaurant* _restaurant; 
    
    NSMutableArray* reviewCells;  //array of RestaurantReviewTableViewCell
}

-(id) initWithRestaurant:(Restaurant*) r; 


- (void) openGoogleMap;             //launches the map application with the restaurant in the center of it. 

- (void) openRestaurantWebsite;     //opens up the website for the restaurant (if available) 

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) Restaurant* restaurant; 


@end
