//
//  RestaurantReviewProvider.h
//  Songhori
//
//  Created by Ali Nouri on 7/3/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestaurantReview.h"
#import "Restaurant.h"


@class RestaurantReviewProvider; 

@protocol RestaurantReviewDelegate <NSObject>

-(void) reviewer:(RestaurantReviewProvider*) provider forRestaurant:(Restaurant*) restaurant reviewDidFinish:(RestaurantReview*) review; 
@optional
-(void) reviewer:(RestaurantReviewProvider*) provider forRestaurant:(Restaurant *)restaurant reviewDidFailWithError:(NSError*) err; 

@end


/*
        This is an abstract class that is responsible for providing review and rating for restaurants 
 */
@interface RestaurantReviewProvider : NSObject <NSURLConnectionDelegate> 
{
    id<RestaurantReviewDelegate> _delegate; 
    Restaurant* _restaurant; 
    
    NSMutableURLRequest* _request; 
    NSMutableData* _incomingData; 
    NSURLConnection* _urlConnection; 
}

-(void) fetchReviewsForRestaurant:(Restaurant*) restaurant observer:( id<RestaurantReviewDelegate>) observer; 
-(NSString*) urlForRestaurant:(Restaurant*) restaurant; 

@property (nonatomic, assign) id<RestaurantReviewDelegate> delegate; 
@property (nonatomic, assign) Restaurant* restaurant; 

@property (nonatomic, retain) NSURLConnection* urlConnection; 
@property (nonatomic, retain) NSMutableData* incomingData; 
@property (nonatomic, retain) NSMutableURLRequest* request; 

@end




@interface YelpReviewProvider : RestaurantReviewProvider
{
}

@end


@interface GoogleReviewProvider : RestaurantReviewProvider
{
    
}

@end

