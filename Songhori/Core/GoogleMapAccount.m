//
//  GoogleMapAccount.m
//  Songhori
//
//  Created by Ali Nouri on 1/2/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import "GoogleMapAccount.h"
#import "AccountManager.h"

@implementation GoogleMapAccount
@synthesize active=_active; 
@synthesize list=_list; 


-(id) initWithGoogleMapList:(GoogleMapList *)l
{
    self = [super init]; 
    if(self)
    {
        model = [AccountManager standardAccountManager].coreModel; 
        context = [AccountManager standardAccountManager].coreContext; 
        _list = [l retain]; 
        l.account = self; 
    }
    
    return self; 
}


-(BOOL) active
{
    return self.list.active; 
}


-(void) setActive:(BOOL)active
{
    self.list.active = active; 
}



-(void) save
{
    
}


-(BOOL) syncData
{
    BOOL result=NO; 
    //only resync if we haven't already today 

        NSTimeInterval diff = [NSDate timeIntervalSinceReferenceDate] - self.list.lastSyncDate; 
        if (diff > 86400)       //it's been more than one day 
        {
            result = YES; 
            
            
            //TODO: write the code for resync 
        }
    return result; 
}


-(NSString*) accountName
{
    return @"GoogleMapList"; 
}

-(void) didReceiveMemoryWarning
{
    
}

-(void) sendRestaurantsInRegion:(MKCoordinateRegion) region zoomLevel:(int) zoomLevel
{
    if (!self.active)
        return; 

    NSMutableArray* result = [NSMutableArray arrayWithCapacity:100]; 
    
    
        NSArray* res = [self.list restaurantsInRegion:region zoomLevel:zoomLevel]; 
        
        for (GoogleMapRestaurant* a in res) {
            [result addObject:a.annotation]; 
        }
    [self.delegate restaudantDataDidBecomeAvailable: result forRegion:region fromProvider:self];     
}














@end
