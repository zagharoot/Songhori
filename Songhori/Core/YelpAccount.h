//
//  YelpAccount.h
//  Songhori
//
//  Created by Ali Nouri on 12/3/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "Account.h"
#import "YelpRestaurantDataProvider.h"

@interface YelpAccount : Account 
{
    YelpRestaurantDataProvider* _dataProvider; 
    BOOL _active; 
}

-(void) activateAccount:(NSString*) username; 

@property (nonatomic, readonly) BOOL active; 
@property (nonatomic, retain) YelpRestaurantDataProvider* dataProvider; 

@end
