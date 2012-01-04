//
//  YelpDataProvider.m
//  Songhori
//
//  Created by Ali Nouri on 12/6/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "YelpUser.h"
#import "YelpRestaurant.h"


@implementation YelpUser

@dynamic lastCheckinDate;
@dynamic lastSyncDate; 
@dynamic username;
@dynamic checkins;
@dynamic active; 



-(void) recalculateLastCheckin
{
    NSTimeInterval max = self.lastCheckinDate; 
    
    for (YelpRestaurant* r in self.checkins) {
        if (r.lastCheckinDate > max) 
            max = r.lastCheckinDate; 
    }
    self.lastCheckinDate = max; 
}

@end



