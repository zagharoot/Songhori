//
//  YelpRestaurant.h
//  Songhori
//
//  Created by Ali Nouri on 12/6/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Restaurant.h"

@class YelpUser;
@class YelpRestaurantAnnotation; 

#define BUSINESS_LOOKUP_API     @"http://api.yelp.com/v2/business/"

#define YWSID       eWttnhjwtIn33JRWFb2wVg          //this is ywsid for api version 1.0 

#define CONSUMER_KEY        @"oGh6qFD1JCawaSJcTMYM_w"
#define CONSUMER_SECRET     @"KU5IJYgdIIKlXW6kWko2xfxUSDw"
#define TOKEN               @"eBcbXmC6BlHAH23VOb2UsPGSpH7_VuNh"
#define TOKEN_SECRET        @"qnTr-pols2Odq4j99qBaXPhnou4"


@class YelpRestaurant; 

@protocol YelpRestaurantDelegate <NSObject>
@optional
-(void) detailDataDidDownloadForRestaurant:(YelpRestaurant*) restaurant; 
@end


@interface YelpRestaurant : NSManagedObject
{
    YelpRestaurantAnnotation* _annotation; 
    id<YelpRestaurantDelegate> _delegate; 
}

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, retain) NSString * y_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * jsonData; 
@property (nonatomic) NSTimeInterval checkinDate;
@property (nonatomic) int16_t checkinCount;
@property (nonatomic, retain) YelpUser *user;


@property (nonatomic, readonly) YelpRestaurantAnnotation* annotation; 
@property (nonatomic, assign) id<YelpRestaurantDelegate> delegate; 


-(void) loadFromJSON:(id) json;         //given checkin json data, load attributes (this only has id, checkin count and date) 
-(void) loadDetailsFromWebsite;         //this uses the business id to get more information from the website 
-(BOOL) isDetailDataAvailable;          //returns true if the details of the restaurant data is available 

@end


@interface YelpRestaurantAnnotation : Restaurant {
    YelpRestaurant* _restaurant; 
}

-(id) initWithYelpRestaurant:(YelpRestaurant*) r; 

@property (nonatomic, readonly) YelpRestaurant* restaurant; 
@end