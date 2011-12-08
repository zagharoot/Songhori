//
//  FNAccount.m
//  songhori
//
//  Created by Ali Nouri on 7/2/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "FNAccount.h"

@implementation FNAccount
@synthesize active=_active; 
- (id)init
{
    self = [super init];
    if (self) 
    {
        //read user defaults for the frobKey
        NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; 
        id aa = [ud valueForKey:@"FNAccountActive"]; 
        if (aa)
        {
            _active = [aa boolValue]; 
            
            if (_active)
            {
                dataProvider = [[FNRestaurantDataProvider alloc] init ]; 
                dataProvider.delegate = self; 
            }
        }
        else
            _active = NO; 
    }
    
    return self;
}


-(NSString*) accountName
{
    return @"FNAccount" ; 
}


-(BOOL) isActive
{
    return _active; 
}

-(void) setActive:(BOOL)active
{
    if (active) 
    {
        if (!dataProvider)
        {
            dataProvider = [[FNRestaurantDataProvider alloc] init ]; 
            dataProvider.delegate = self; 
        }
    }else
        [dataProvider release]; 
    
    
        //replace the value in the userdefaults
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; 
    
        [ud setValue:[NSNumber numberWithBool:active] forKey:@"FNAccountActive"]; 
    
    _active = active; 
}


-(void) sendRestaurantsInRegion:(MKCoordinateRegion)region zoomLevel:(int)zoomLevel
{
    if (! self.active)
        return; 
    
    if (! dataProvider)
        return; 
    
    [dataProvider sendRestaurantsInRegion:region zoomLevel:zoomLevel]; 
}

-(void) restaudantDataDidBecomeAvailable:(NSArray *)restaurants forRegion:(MKCoordinateRegion)region fromProvider:(id)provider
{
    [self.delegate restaudantDataDidBecomeAvailable:restaurants forRegion:region fromProvider:self]; 
}

@end
