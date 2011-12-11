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




-(void) recalculateLastCheckin
{
    NSTimeInterval max = self.lastCheckinDate; 
    
    for (YelpRestaurant* r in self.checkins) {
        if (r.checkinDate > max) 
            max = r.checkinDate; 
    }
    self.lastCheckinDate = max; 
}

@end



