//
//  YelpUser.h
//  Songhori
//
//  Created by Ali Nouri on 12/6/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SBJsonParser.h"
#import <MapKit/MapKit.h>



@class YelpRestaurant;

@interface YelpUser: NSManagedObject

@property (nonatomic) NSTimeInterval lastCheckinDate;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *checkins;
@end

@interface YelpUser (CoreDataGeneratedAccessors)

- (void)addCheckinsObject:(YelpRestaurant *)value;
- (void)removeCheckinsObject:(YelpRestaurant *)value;
- (void)addCheckins:(NSSet *)values;
- (void)removeCheckins:(NSSet *)values;
@end



