//
//  FNAccount.m
//  songhori
//
//  Created by Ali Nouri on 7/2/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "FNAccount.h"

@implementation FoodNetworkShow
@synthesize dataProvider=_dataProvider; 
@synthesize name=_name; 
@synthesize searchTerm=_searchTerm; 
@synthesize active = _active; 


-(id) initWithDelegate:(id<RestaurantDataDelegate>) delegate
{
    self = [super init]; 
    if (self)
{
    _dataProvider = [[FNRestaurantDataProvider alloc] initWithShow:self andDelegate:delegate]; 
}
    return self; 
}


-(void) dealloc
{
    self.dataProvider = nil; 
    [super dealloc]; 
}
                        
                        
@end


@implementation FNAccount
@synthesize shows=_shows; 



- (id)init
{
    self = [super init];
    if (self) 
    {
        [self loadShows]; 
    }
    
    return self;
}


-(void) loadShows
{
    _shows = [[NSMutableArray alloc] initWithCapacity:10]; 
    showRequestProgress = [[NSMutableDictionary alloc] initWithCapacity:10] ;
    
    
    FoodNetworkShow* sh = [[FoodNetworkShow alloc] initWithDelegate:self]; 
    sh.name = @"Best thing I ever ate"; 
    sh.searchTerm = @"The+Best+Thing+I+Ever+Ate"; 
    sh.active = YES; 
    [showRequestProgress setValue:@"NO" forKey:sh.name]; 
    
    [_shows addObject:sh]; 
    [sh release]; 
    
    
    sh = [[FoodNetworkShow alloc] initWithDelegate:self]; 
    sh.name = @"Diners, Drive-Ins and Dives"; 
    sh.searchTerm = @"Diners%2C+Drive-ins+and+Dives"; 
    sh.active = YES; 
    [showRequestProgress setValue:@"NO" forKey:sh.name]; 
    
    [_shows addObject:sh]; 
    [sh release]; 
    
}


-(NSString*) info
{
    int aa = [self numberOfActiveAccounts]; 
    if (aa==0)
        return @"No selected show"; 
    else {
        return [NSString stringWithFormat:@"%d shows selected", aa]; 
    }
}


-(NSString*) accountName
{
    return @"FNAccount" ; 
}

//because we have several shows
-(BOOL) isCompound
{
    return YES; 
}

-(BOOL) active
{
    if ([self numberOfActiveAccounts]>0)
        return YES; 
    else {
        return NO; 
    }
}


-(int) numberOfActiveAccounts
{
    int result = 0; 
    for (FoodNetworkShow* s in self.shows) {
        if (s.active)
            result++; 
    }
    return result; 
}

-(void) sendRestaurantsInRegion:(MKCoordinateRegion)region zoomLevel:(int)zoomLevel
{    
    for (FoodNetworkShow* s in self.shows) {
        [showRequestProgress setValue:@"NO" forKey:s.name]; 
        if (s.active)
            [showRequestProgress setValue:@"YES" forKey:s.name]; 
    }
    
    for (FoodNetworkShow* s in self.shows) 
    {
        if (s.active)
        {
            [s.dataProvider sendRestaurantsInRegion:region zoomLevel:zoomLevel]; 
        }
    }    
}

-(void) allDataForRequestSent:(id)provider
{
    FNRestaurantDataProvider* dp = (FNRestaurantDataProvider*) provider; 
    [showRequestProgress setValue:@"NO" forKey:dp.networkShow.name]; 
    
    for (FoodNetworkShow* s in self.shows) {
        NSString* str = @"YES"; 
        
        if ([str compare:[showRequestProgress valueForKey:s.name]]== NSOrderedSame)
            return; 
    }
    //all shows are done. notify delegat if it reacts to it 
    if (self.delegate && [self.delegate respondsToSelector:@selector(allDataForRequestSent:)])
        [self.delegate performSelector:@selector(allDataForRequestSent:) withObject:self]; 

}
                        
                        
-(void) restaudantDataDidBecomeAvailable:(NSArray *)restaurants forRegion:(MKCoordinateRegion)region fromProvider:(id)provider
{
    [self.delegate restaudantDataDidBecomeAvailable:restaurants forRegion:region fromProvider:self]; 
}

-(void) restaurantDataFailedToLoadForProvider:(id)provider withError:(NSError *)err
{
    if ([self.delegate respondsToSelector:@selector(restaurantDataFailedToLoadForProvider:withError:)])
        [self.delegate restaurantDataFailedToLoadForProvider:self withError:err]; 
}


-(void) dealloc
{
    self.shows = nil; 
    [showRequestProgress release]; 
    
    [super dealloc]; 
}

@end
