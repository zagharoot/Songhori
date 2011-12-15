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
#import "YelpCheckin.h" 

@class YelpUser;
@class YelpRestaurantAnnotation; 

#define BUSINESS_LOOKUP_API     @"http://api.yelp.com/v2/business/"



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
@property (nonatomic) NSTimeInterval lastCheckinDate;
@property (nonatomic) int16_t checkinCount;
@property (nonatomic, retain) YelpUser *user;
@property (nonatomic, retain) NSSet *checkins;


@property (nonatomic, readonly) YelpRestaurantAnnotation* annotation; 
@property (nonatomic, assign) id<YelpRestaurantDelegate> delegate; 


-(void) loadDetailsFromWebsite;         //this uses the business id to get more information from the website 
-(BOOL) isDetailDataAvailable;          //returns true if the details of the restaurant data is available 
-(void) addCheckin:(YelpCheckin*) checkin; 
-(void) notifyDelegateOfDetailDownloadFinish:(BOOL) success; 

@end


@interface YelpRestaurant (CoreDataGeneratedAccessors)

- (void)addCheckinsObject:(YelpCheckin *)value;
- (void)removeCheckinsObject:(YelpCheckin *)value;
- (void)addCheckins:(NSSet *)values;
- (void)removeCheckins:(NSSet *)values;
@end




@interface YelpRestaurantAnnotation : Restaurant {
    YelpRestaurant* _restaurant; 
}

-(id) initWithYelpRestaurant:(YelpRestaurant*) r; 

@property (nonatomic, readonly) YelpRestaurant* restaurant; 
@end