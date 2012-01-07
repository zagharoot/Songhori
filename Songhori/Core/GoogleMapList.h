//
//  GoogleMapList.h
//  Songhori
//
//  Created by Ali Nouri on 1/2/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>
#import "GoogleMapRestaurant.h"

@class GoogleMapAccount; 
@interface GoogleMapList : NSManagedObject
{
    GoogleMapAccount* _account; 
    
}

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString* name; 
@property (nonatomic, retain) NSSet *restaurants;
@property (nonatomic) NSTimeInterval lastSyncDate;          //when was the last time we synced with the website
@property (nonatomic) BOOL active; 

@property (nonatomic, assign) GoogleMapAccount* account; 

-(NSArray*) restaurantsInRegion:(MKCoordinateRegion) region zoomLevel:(int) zoomLevel;


@end




@interface GoogleMapList (CoreDataGeneratedAccessors)

- (void)addRestaurantsObject:(GoogleMapRestaurant *)value;
- (void)removeRestaurantsObject:(GoogleMapRestaurant *)value;
- (void)addRestaurans:(NSSet *)values;
- (void)removeRestaurants:(NSSet *)values;
@end

