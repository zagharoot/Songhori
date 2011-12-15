//
//  Account.h
//  rlimage
//
//  Created by Ali Nouri on 7/2/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Restaurant.h" 

enum ACCOUNT_INDEX  //WEBSITE: add the website here 
{
    NOT_AVAILABLE = -1, 
    FN_INDEX = 0, 
    YELP_INDEX = 1, 
};




//This is an abstract class to represent user account in a website
@interface Account: NSObject  <RestaurantDataDelegate> 
{
    UIImage* _logoImage; 
    
    id<RestaurantDataDelegate> _delegate; 
}

-(BOOL) isActive;         //returns true if the account has been set up and ready to use
-(void) save; 
-(BOOL) syncData;       //try to sync any data we have offline. Return NO if we don't need syncing

-(NSString*) accountName; 
-(void) didReceiveMemoryWarning; 

-(void) sendRestaurantsInRegion:(MKCoordinateRegion) region zoomLevel:(int) zoomLevel; //array of annotations


@property (readonly, nonatomic) UIImage* logoImage; 
@property (nonatomic, assign) id<RestaurantDataDelegate> delegate; //we return array of Restaurant
@end




