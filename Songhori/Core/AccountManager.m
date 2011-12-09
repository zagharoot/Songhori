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
        accountRequestProgress = [[NSMutableDictionary alloc] initWithCapacity:2]; 
        
        //add food network account 
        FNAccount* fni = [[[FNAccount alloc] init] autorelease]; 
        fni.delegate = self; 
        [_accounts addObject:fni]; 
        [accountRequestProgress setValue:@"NO" forKey:fni.accountName]; 
        
        
        YelpAccount* yi = [[[YelpAccount alloc] init] autorelease]; 
        [accountRequestProgress setValue:@"NO" forKey:yi.accountName]; 
        yi.delegate = self; 
        [_accounts addObject:yi]; 
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
    for (Account* a in self.accounts) {
        [accountRequestProgress setValue:@"NO" forKey:a.accountName]; 
        if ([a isActive])
            [accountRequestProgress setValue:@"YES" forKey:a.accountName]; 
    }
    
    for (Account* a in self.accounts) 
    {
        if ([a isActive])
        {
            [a sendRestaurantsInRegion:region zoomLevel:zoomLevel]; 
        }
    }    
}



-(void) restaudantDataDidBecomeAvailable:(NSArray *)restaurants forRegion:(MKCoordinateRegion)region fromProvider:(id)provider
{
    [accountRequestProgress setValue:@"YES" forKey:[provider accountName]]; 
    [self.delegate restaudantDataDidBecomeAvailable:restaurants forRegion:region fromProvider:self]; 
    
    for (Account* a in self.accounts) {
        NSString* str = @"YES"; 
        
        if ([str compare:[accountRequestProgress valueForKey:a.accountName]])
            return; 
    }
    
    //all accounts are done. notify delegat if it reacts to it 
    if (self.delegate && [self.delegate respondsToSelector:@selector(allDataForRequestSent)])
        [self.delegate performSelector:@selector(allDataForRequestSent)]; 
}


-(void) dealloc
{
    [accountRequestProgress release]; 
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
        return  [self.accounts objectAtIndex:YELP_INDEX]; 
    else
        return nil; 
    
}


//WEBSITE: 

@end
