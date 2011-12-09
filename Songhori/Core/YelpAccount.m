//
//  YelpAccount.m
//  Songhori
//
//  Created by Ali Nouri on 12/3/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "YelpAccount.h"
#import "YelpRestaurant.h"

@implementation YelpAccount
@synthesize dataProvider=_dataProvider; 
@synthesize active=_active; 

- (id)init
{
    self = [super init];
    if (self) 
    {
        //read user defaults for the frobKey
        NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; 
        id aa = [ud valueForKey:@"YelpAccountUsername"]; 
        if (aa)
        {
            _active = YES; 
            self.dataProvider = [[[YelpRestaurantDataProvider alloc] initWithUserid:aa] autorelease];
            self.dataProvider.delegate = self; 
        }
        else
            _active = NO; 
    }
    
    return self;
}


-(NSString*) accountName
{
    return @"YelpAccount" ; 
}


-(BOOL) isActive
{
    return _active; 
}

-(void) deactivateAccount
{
    _active = NO; 
    
    //replace the value in the userdefaults
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; 
    
    [ud setValue:nil forKey:@"YelpAccountUsername"]; 
    
    [_dataProvider release]; 
}

-(void) activateAccount:(NSString *)username
{
    if ([self isActive])    //TODO: what about if we want to change the username? 
        return; 
    
    //replace the value in the userdefaults
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; 
    
    [ud setValue:username forKey:@"YelpAccountUsername"]; 

    self.dataProvider = [[[YelpRestaurantDataProvider alloc] initWithUserid:username] autorelease];
    self.dataProvider.delegate = self; 
    
    
    _active = YES;  
}


-(void) restaudantDataDidBecomeAvailable:(NSArray *)restaurants forRegion:(MKCoordinateRegion)region fromProvider:(id)provider
{
    //the array we get is of YelpRestaurant, but we need to change it to YelpRestaurantAnnotation
    
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:100]; 
    for (YelpRestaurant* r in restaurants) {
        [result addObject: r.annotation]; 
    }

    [self.delegate restaudantDataDidBecomeAvailable:result forRegion:region fromProvider:self]; 

}


-(void) sendRestaurantsInRegion:(MKCoordinateRegion)region zoomLevel:(int)zoomLevel
{
    if (![self isActive])
        return; 
    
    if (! self.dataProvider)
        return; 
    
    [self.dataProvider sendRestaurantsInRegion:region];     
}


@end
