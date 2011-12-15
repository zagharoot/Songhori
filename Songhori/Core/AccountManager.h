//
//  AccountManager.h
//  rlimage
//
//  Created by Ali Nouri on 7/2/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNAccount.h"
#import "YelpAccount.h"
#import "Account.h"
#import "Restaurant.h"

//This is a class that keeps track of user accounts in different websites. There's only one instance of this class 
@interface AccountManager : NSObject <RestaurantDataDelegate> 
{
    NSMutableArray* _accounts;       //list of accounts: this is an array of Account*
    NSMutableDictionary* accountRequestProgress;   //tracks what accounts are pending request data 
    NSMutableDictionary* syncProgress;             //tracks what accounts are pending sync 
    
    id<RestaurantDataDelegate> _delegate; 
}

-(id) init; 
-(FNAccount*) fnAccount;                //WEBSITE: 
-(YelpAccount*) yelpAccount;        

-(void) save;                           //sends save command to each individual account 
-(BOOL) syncData;                     //sends updateData to each individual account (returns NO if we don't need)


-(BOOL) hasAnyActiveAccount; 
-(Account*) getAccountAtIndex:(int) index; 

+(AccountManager*) standardAccountManager;      //the singleton pattern: we only have one instance of the manager
+(Account*) getAccountFromRestaurant:(Restaurant*) restaurant;       //retrieves the corresponding account for a pictureInfo


-(void) sendRestaurantsInRegion:(MKCoordinateRegion) region zoomLevel:(int) zoomLevel;  //array of annotations




@property (readonly, nonatomic) NSArray* accounts; 
@property (readonly) int NUMBER_OF_ACCOUNTS; 
@property (nonatomic, assign) id<RestaurantDataDelegate> delegate; // we return array of Restaurant
@end
