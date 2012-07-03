//
//  RestaurantDetailViewController.h
//  Songhori
//
//  Created by Ali Nouri on 12/16/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"


@interface RestaurantDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    Restaurant* _restaurant; 
}

-(id) initWithRestaurant:(Restaurant*) r; 

- (IBAction)openGoogleMap;

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UITableViewCell *googleTableViewCell;
@property (retain, nonatomic) IBOutlet UITableViewCell *yelpTableViewCell;

@property (nonatomic, retain) Restaurant* restaurant; 
@end
