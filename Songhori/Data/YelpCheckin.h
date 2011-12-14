//
//  YelpCheckin.h
//  Songhori
//
//  Created by Ali Nouri on 12/12/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class YelpRestaurant;

@interface YelpCheckin : NSManagedObject

@property (nonatomic, retain) NSString * y_id;
@property (nonatomic, retain) NSString* jsonData; 
@property (nonatomic) NSTimeInterval visitDate;
@property (nonatomic, retain) YelpRestaurant *restaurant;


@end
