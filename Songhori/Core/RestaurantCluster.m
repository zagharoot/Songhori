//
//  RestaurantCollection.m
//  FoodNetworkLocal
//
//  Created by Ali Nouri on 10/2/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "Restaurant.h"

@implementation RestaurantCluster

@synthesize count=_count; 



-(id) initWithJSONData:(id) json
{
    NSArray* data = (NSArray*) json; 
    self = [super init]; 
    if (self) 
    {
        __coordinate.latitude = [[data objectAtIndex:1] doubleValue];
        __coordinate.longitude = [[data objectAtIndex:2] doubleValue]; 
        _title = @"cluster"; 
        _subtitle =  @""; 
        _count  = 0;  
        
        @try {
            
            id t = [data objectAtIndex:3]; 
            if ([t respondsToSelector:@selector(length)])
            {
                _title = [[data objectAtIndex:3] copy]; 
                _subtitle = [[data objectAtIndex:4] copy]; 
                
                
            }else
            {
                _count = [t intValue];    
                _title = [[NSString alloc] initWithFormat:@"%d Restaurants", self.count, nil]; 
            }
            
        }
        @catch (NSException *exception) {
            _count = 0;  
            
        }
        @finally {
            
        }
        
        
        
    }
    
    
    return self; 
    
    
    
}





@end
