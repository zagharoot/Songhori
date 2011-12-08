//
//  YelpRestaurantDataProvider.h
//  songhori
//
//  Created by Ali Nouri on 7/30/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "Restaurant.h"
#import <Foundation/Foundation.h>
#import "SBJsonParser.h"
#import "YelpUser.h"
#import "CoreData/CoreData.h"

#define SERVER_ADDRESS   @"http://api.yelp.com/"

#define SERVICE_CHECKIN   @"feed?device_type=iPhone%2F5.0&efs=68%2F4yS5IBAHy%2BlFRxl0AcCje3h%2FBEr7roNMHNG6PUwRH1MzKzNrK4T7sBe9nB5LOzgrB4GhXQLXvnetQlpIR1pNmssGbmHvSio%2BqOnq1Kln94h%2FiLJCGqc5AklnRs7yP&locale=en_US&time=1317564504&type=me&session_token=GwWiRQjvVQDt5Xjoa9kO0adRZLsySfKQ&ywsid=gpfz_nbS33avFWL0Ozgz3Q&cc=US&lang=en&accuracy=0.006214&signature=yg8ZYgEyNczSFkmrGVrcng%3D%3D&app_version=5.4.1" 

// This class takes care of receiving information from our own web server (image recommendations). 
// 


@interface YelpRestaurantDataProvider : NSObject
{
    NSMutableURLRequest* _requestCheckin; 
    YelpUser* userData; 
    
    NSManagedObjectContext* context; 
    NSManagedObjectModel* model; 
    
    id<RestaurantDataDelegate> _delegate; 
}


-(id) initWithUserid:(NSString*) u; 
-(void) sendRestaurantsInRegion:(MKCoordinateRegion) region; //array of YelpRestaurant




-(void) loadCheckins; 
-(YelpRestaurant*) createYelpRestaurantWithJsonData:(id) json; 
-(YelpUser*) createYelpUserWithUsername:(NSString*) username; 

@property (retain, readonly) NSMutableURLRequest* requestCheckin;
@property (nonatomic, assign) id<RestaurantDataDelegate> delegate;  //we send array of YelpRestaurant

@end
