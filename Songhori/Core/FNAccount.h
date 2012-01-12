//
//  FNAccount.h
//  songhori
//
//  Created by Ali Nouri on 7/2/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"
#import "FNRestaurantDataProvider.h" 

@interface FoodNetworkShow : NSObject
{
    NSString* _name; 
    NSString* _searchTerm; 
    FNRestaurantDataProvider* _dataProvider; 
    
    BOOL _active; 
}

-(id) initWithDelegate:(id<RestaurantDataDelegate>) delegate;


@property (nonatomic, retain) NSString* name; 
@property (nonatomic, retain) NSString* searchTerm; 
@property (nonatomic, retain) FNRestaurantDataProvider* dataProvider; 
@property (nonatomic) BOOL active; 

-(void) setActiveNoSave:(BOOL) active; 

@end


@interface FNAccount: Account
{
    
    NSMutableArray* _shows;       //list of shows
    
    NSMutableDictionary* showRequestProgress;   //tracks what accounts are pending request data 
}

-(void) loadShows; 
-(int) numberOfActiveAccounts; 


@property (nonatomic, retain) NSMutableArray* shows; 

@end
