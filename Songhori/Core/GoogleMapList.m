//
//  GoogleMapList.m
//  Songhori
//
//  Created by Ali Nouri on 1/2/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import "GoogleMapList.h"


@implementation GoogleMapList
@synthesize account=_account; 


@dynamic url;
@dynamic name; 
@dynamic restaurants;
@dynamic lastSyncDate; 
@dynamic active; 



-(NSArray*) restaurantsInRegion:(MKCoordinateRegion) region zoomLevel:(int) zoomLevel;
{
    NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:100]; 
    
    //only retrieve the ones that fall in the region
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"latitude>%lf AND latitude<%lf AND longitude>%lf AND longitude < %lf", region.center.latitude-region.span.latitudeDelta/2.0, region.center.latitude+region.span.latitudeDelta/2.0, region.center.longitude-region.span.longitudeDelta/2.0, region.center.longitude+region.span.longitudeDelta/2.0]; 
    NSSet* filtered = [self.restaurants filteredSetUsingPredicate:predicate]; 
    
    for (GoogleMapRestaurant* r in filtered) 
    {
            [result addObject:r]; 
    }
    
    return [result autorelease]; 
}



@end
