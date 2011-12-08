//
//  AccountManager.m
//  rlimage
//
//  Created by Ali Nouri on 7/2/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "AccountManager.h"


static AccountManager* theAccountManager;

@implementation AccountManager

@synthesize accounts = _accounts; 
@synthesize delegate=_delegate; 

//perform the singleton pattern
+(AccountManager*) standardAccountManager
{
    if (theAccountManager == nil)
        theAccountManager = [[AccountManager alloc] init]; 

    return theAccountManager;     
}


+(Account*) getAccountFromRestaurant:(Restaurant *)restaurant
{
    NSString* className = [[restaurant class] description]; 
    
    
    if ([className isEqualToString:@"FNRestaurant"])   //picture is from flickr
    {
        return [[AccountManager standardAccountManager] fnAccount]; 
    }

    
    if ([className isEqualToString:@"YelpRestaurant"]) 
        return [[AccountManager standardAccountManager] yelpAccount]; 
    
    //WEBSITE: handle other websites here 
    return nil; //couldn't find the downloader 
}





-(int) NUMBER_OF_ACCOUNTS
{
    return 2; //there are two accounts
    
    //todo: can we extract the number of available accounts from the enum? 
}

- (id)init
{
    self = [super init];
    if (self) 
    {
        _accounts = [[NSMutableArray alloc] initWithCapacity:self.NUMBER_OF_ACCOUNTS]; 
        
        //add food network account 
        FNAccount* fni = [[[FNAccount alloc] init] autorelease]; 
        fni.delegate = self; 
        [_accounts addObject:fni]; 
        
        
        YelpAccount* yi = [[[YelpAccount alloc] init] autorelease]; 
        yi.delegate = self; 
        //[_accounts addObject:yi]; //TODO: remove comment
        //WEBSITE: 
        
    }
    
    return self;
}

-(BOOL) hasAnyActiveAccount
{
    for (Account* a in self.accounts) {
        if ( [a isActive])
            return YES; 
    }
    
    return NO; 
}


-(void) sendRestaurantsInRegion:(MKCoordinateRegion)region zoomLevel:(int)zoomLevel
{
    for (Account* a in self.accounts) 
    {
        if ([a isActive])
            [a sendRestaurantsInRegion:region zoomLevel:zoomLevel]; 
    }    
}



-(void) restaudantDataDidBecomeAvailable:(NSArray *)restaurants forRegion:(MKCoordinateRegion)region fromProvider:(id)provider
{
    [self.delegate restaudantDataDidBecomeAvailable:restaurants forRegion:region fromProvider:self]; 
}


-(void) dealloc
{
    [_accounts release]; 
    
}

-(Account*) getAccountAtIndex:(int)index
{
    //todo: error check! 
    return [self.accounts objectAtIndex:index]; 
}

-(FNAccount*) fnAccount
{
    if ([self.accounts count] > FN_INDEX)
        return [self.accounts objectAtIndex:FN_INDEX]; 
    else
        return nil; 
}

-(YelpAccount*) yelpAccount
{
    if ([self.accounts count] > YELP_INDEX)
        return [self.accounts objectAtIndex:YELP_INDEX]; 
    else
        return nil; 
}


//WEBSITE: 

@end
