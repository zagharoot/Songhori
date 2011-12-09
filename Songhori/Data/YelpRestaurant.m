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


static UIImage* YelpLogo; 



//-----------------------------------------------------------
@implementation YelpRestaurantAnnotation
@synthesize restaurant=_restaurant; 


-(NSString*) name
{
    return self.restaurant.name; 
}



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


-(UIImage*) logo
{
    if (!YelpLogo)
    {
        YelpLogo = [[UIImage imageNamed:@"YelpLogo.png"] retain]; 
    }
    
    return YelpLogo; 
}




-(NSString*) detail
{
    int cnt = self.restaurant.checkinCount; 
    NSTimeInterval t = self.restaurant.checkinDate; 
    NSDate* d = [NSDate dateWithTimeIntervalSince1970:t]; 
    
    
    NSString* result = [NSString stringWithFormat:@"number of checkins: %d\nlast on: %@", cnt, d]; 
    
    return result; 
}




@end


