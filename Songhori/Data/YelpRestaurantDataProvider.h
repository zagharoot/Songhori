//
//  YelpRestaurantDataProvider.h
//  songhori
//
//  Created by Ali Nouri on 7/30/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "YelpRestaurant.h"
#import <Foundation/Foundation.h>
#import "SBJsonParser.h"
#import "YelpUser.h"
#import "CoreData/CoreData.h"

#define SERVER_ADDRESS   @"http://api.yelp.com/"

#define SERVICE_CHECKIN    @"check_ins?device_type=iPhone%2F5.0.1&efs=68%2F4yS5IBAHy%2BlFRxl0AcCVzCfEV2HSixTmktt%2FYVkrFi%2FmaFRYCn3MOgZrf5LsaFkFrdmCE2%2F3GyqGcYCKqA6pv1cAo0q9KBII5b%2F09ypJ47czyfSOzlhM3jklPx7%2B6&limit=20&time=1323444026&locale=en_US&session_token=GwWiRQjvVQDt5Xjoa9kO0adRZLsySfKQ&ywsid=gpfz_nbS33avFWL0Ozgz3Q&cc=US&lang=en&accuracy=0.006214&signature=SBbhws9b4HwgDq0f2RfPbA%3D%3D&app_version=5.4.4" 



// This class takes care of receiving information from our own web server (image recommendations). 
// 


@interface YelpRestaurantDataProvider : NSObject <YelpRestaurantDelegate>
{
    NSMutableURLRequest* _requestCheckin; 
    YelpUser* _userData; 
    
    NSManagedObjectContext* context; 
    NSManagedObjectModel* model; 
    
    id<RestaurantDataDelegate> _delegate; 
    
    
    int _outstandingRestaurantDownloads;         //this indicates how many more restaurants need to be downloaded 
}


-(id) initWithUserid:(NSString*) u; 
-(void) sendRestaurantsInRegion:(MKCoordinateRegion) region; //array of YelpRestaurant

-(NSURL*) urlForPage:(int) pageNumber; 
-(void) save; 
-(BOOL) syncData; 
-(void) incrementActivity; 
-(void) decrementActivity; 

-(void) loadCheckins:(int) pageNumber;  
-(YelpRestaurant*) createYelpRestaurantWithID:(NSString*) y_id; 
-(YelpUser*) createYelpUserWithUsername:(NSString*) username; 
-(YelpCheckin*) createCheckinWithJsonData:(id) json;         //creates the YelpCheckin objects and returns it. automatically links the wires to restaurant and userData 

@property (retain, nonatomic) NSMutableURLRequest* requestCheckin;
@property (nonatomic, assign) id<RestaurantDataDelegate> delegate;  //we send array of YelpRestaurant
@property (nonatomic, retain) YelpUser* userData; 
@property (atomic) int outstandingDownloads; 
@end
