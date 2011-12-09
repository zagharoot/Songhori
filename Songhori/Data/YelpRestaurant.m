//
//  YelpRestaurant.m
//  Songhori
//
//  Created by Ali Nouri on 12/6/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "YelpRestaurant.h"
#import "YelpUser.h"


@implementation YelpRestaurant
@synthesize annotation=_annotation; 


@dynamic latitude;
@dynamic longitude;
@dynamic y_id;
@dynamic name;
@dynamic checkinDate;
@dynamic checkinCount;
@dynamic user;


-(YelpRestaurantAnnotation*) annotation
{
    if (! _annotation)
        _annotation = [[YelpRestaurantAnnotation alloc] initWithYelpRestaurant:self]; 
    
    
    return _annotation; 
    
}


-(void) loadFromJSON:(id)json
{
        NSDictionary* business = [((NSDictionary*) json) objectForKey:@"business"]; 
        
        self.latitude = [[business objectForKey:@"latitude"] doubleValue]; 
        self.longitude = [[business objectForKey:@"longitude"] doubleValue]; 
        self.name = [business objectForKey:@"name"]; 
               
        NSDictionary* checkin = [((NSDictionary*) json) objectForKey:@"checkin"]; 
        self.checkinCount = [[checkin objectForKey:@"check_in_count"] intValue]; 
        self.checkinDate = [[checkin objectForKey:@"time_created"] intValue]; 
}


-(void) dealloc
{
    [_annotation release]; 
}


@end




@implementation YelpRestaurantAnnotation
@synthesize restaurant=_restaurant; 


-(id) initWithYelpRestaurant:(YelpRestaurant *)r
{
    self = [super init]; 
    if (self) 
    {
        _restaurant = r;    //this is an assign, so never release
        
        __coordinate.latitude = r.latitude; 
        __coordinate.longitude = r.longitude; 
        
        
//        CLLocationCoordinate2D loc; 
//        loc.latitude = r.latitude; 
//        loc.longitude = r.longitude; 
//        [self setCoordinate:loc]; 
    }
    return self; 
}


-(NSString*) detail
{
    NSString* result = [NSString stringWithFormat:@"number of checkins: %d\nlast on: %@", self.restaurant.checkinCount, self.restaurant.checkinDate]; 
    
    return result; 
}




@end


