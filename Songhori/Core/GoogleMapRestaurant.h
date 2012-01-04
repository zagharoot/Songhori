//
//  GoogleMapRestaurant.h
//  Songhori
//
//  Created by Ali Nouri on 1/2/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Restaurant.h"

@class GoogleMapList;
@class GoogleMapRestaurantAnnotation; 

@interface GoogleMapRestaurant : NSManagedObject
{
    GoogleMapRestaurantAnnotation* _annotation; 
    
    
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic) double longitude;
@property (nonatomic) double latitude;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) GoogleMapList *account;


@property (nonatomic, readonly) GoogleMapRestaurantAnnotation* annotation; 

@end






@interface GoogleMapRestaurantAnnotation : Restaurant {
    GoogleMapRestaurant* _restaurant; 
}

-(id) initWithGoogleMapRestaurant:(GoogleMapRestaurant*) r; 

@property (nonatomic, readonly) GoogleMapRestaurant* restaurant; 
@end