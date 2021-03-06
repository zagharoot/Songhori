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


//This is an abstract class to represent user account in a website
@interface Account: NSObject  <RestaurantDataDelegate> 
{
    UIImage* _logoImage; 
    
    id<RestaurantDataDelegate> _delegate; 
}

-(void) save; 
-(BOOL) syncData;       //try to sync any data we have offline. Return NO if we don't need syncing
-(void) syncDataForced; //sync data ignoring any preference
-(BOOL) isSyncable;     //does this account support syncing 


-(NSString*) accountName; 
-(void) didReceiveMemoryWarning; 

-(void) sendRestaurantsInRegion:(MKCoordinateRegion) region zoomLevel:(int) zoomLevel; //array of annotations

-(BOOL) isDeletable; 
-(BOOL) isCompound;         //returns true if the account consists of several configurable stuff in it (like food network)


@property (readonly, nonatomic) UIImage* logoImage; 
@property (nonatomic, assign) id<RestaurantDataDelegate> delegate; //we return array of Restaurant
@property (nonatomic) BOOL active; 
@property (nonatomic, retain) NSString* info; 
@end


//these are accounts that don't belong to fixed items (such as yelp,...)
@interface DynamicAccount : Account

-(void) deleteAccount; 
@end



