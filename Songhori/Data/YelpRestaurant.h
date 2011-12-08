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

@interface YelpRestaurant : NSManagedObject
{
    YelpRestaurantAnnotation* _annotation; 
}

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, retain) NSString * y_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) NSTimeInterval checkinDate;
@property (nonatomic) int16_t checkinCount;
@property (nonatomic, retain) YelpUser *user;


@property (nonatomic, readonly) YelpRestaurantAnnotation* annotation; 

-(void) loadFromJSON:(id) json; 


@end


@interface YelpRestaurantAnnotation : Restaurant {
    YelpRestaurant* _restaurant; 
}

-(id) initWithYelpRestaurant:(YelpRestaurant*) r; 

@property (nonatomic, readonly) YelpRestaurant* restaurant; 
@end