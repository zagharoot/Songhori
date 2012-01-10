//
//  YelpAccount.h
//  Songhori
//
//  Created by Ali Nouri on 12/3/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "Account.h"
#import "YelpRestaurantDataProvider.h"

@class AccountManager;
@interface YelpAccount : Account 
{
    YelpRestaurantDataProvider* _dataProvider; 
}

-(id) init; 
-(int) totalNumberOfCheckins; 

+(NSString*) YWSID;
+(NSString*) CONSUMER_KEY; 
+(NSString*) CONSUMER_SECRET; 
+(NSString*) TOKEN; 
+(NSString*) TOKEN_SECRET; 
+(void)      loadSettings; 

@property (nonatomic, retain) YelpRestaurantDataProvider* dataProvider; 

@end
