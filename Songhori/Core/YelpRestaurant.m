//
//  Restaurant.m
//  FoodNetworkLocal
//
//  Created by Ali Nouri on 9/25/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//
/*
#import "Restaurant.h"

static UIImage* YelpLogo; 


@implementation YelpRestaurant


-(id) initWithJSONData:(id) json 
{
    self = [super init]; 
    if (self) 
    {
        NSDictionary* business = [((NSDictionary*) json) objectForKey:@"business"]; 
        
        __coordinate.latitude = [[business objectForKey:@"latitude"] doubleValue]; 
        __coordinate.longitude = [[business objectForKey:@"longitude"] doubleValue]; 
        self.name = [business objectForKey:@"name"]; 
        self.detail =  [business objectForKey:@"address1"];
        
        NSDictionary* checkin = [((NSDictionary*) json) objectForKey:@"checkin"]; 
        int cnt = [[checkin objectForKey:@"check_in_count"] intValue]; 
        int time = [[checkin objectForKey:@"time_created"] intValue]; 
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:time]; 
        self.detail = [NSString stringWithFormat:@"been here %d times\ndate: %@\n", cnt, date]; 
    }
    return self; 
}

-(void) dealloc
{
    [_name release]; 
    [_detail release]; 
    [super dealloc]; 
    
}


-(UIImage*) logo
{
    if (!YelpLogo)
    {
        YelpLogo = [[UIImage imageNamed:@"yelpLogo.png"] retain]; 
    }
    
    return YelpLogo; 
}


@end
 */
