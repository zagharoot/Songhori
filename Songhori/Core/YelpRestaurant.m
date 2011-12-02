//
//  Restaurant.m
//  FoodNetworkLocal
//
//  Created by Ali Nouri on 9/25/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "Restaurant.h"


@implementation YelpRestaurant


-(id) initWithJSONData:(id) json 
{
    NSArray* data = (NSArray*) json; 
    self = [super init]; 
    if (self) 
    {
        __coordinate.latitude = [[data objectAtIndex:1] doubleValue];
        __coordinate.longitude = [[data objectAtIndex:2] doubleValue]; 
        _title = @""; 
        _subtitle =  @""; 

        @try {
            
            id t = [data objectAtIndex:3]; 
            if ([t respondsToSelector:@selector(length)])
            {
                _title = [[data objectAtIndex:3] copy]; 
                _subtitle = [[data objectAtIndex:4] copy]; 
            }

        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }

    
    return self; 
}

-(void) dealloc
{
    [_title release]; 
    [_subtitle release]; 
    [super dealloc]; 
    
}

@end
