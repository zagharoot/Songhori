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
#import "OAuthProvider.h" 


@class RestaurantReviewProvider; 

@protocol RestaurantReviewDelegate <NSObject>

-(void) reviewer:(RestaurantReviewProvider*) provider forRestaurant:(Restaurant*) restaurant reviewDidFinish:(RestaurantReview*) review; 
@optional
-(void) reviewer:(RestaurantReviewProvider*) provider forRestaurant:(Restaurant *)restaurant reviewDidFailWithError:(NSError*) err; 

@end


/*
        This is an abstract class that is responsible for providing review and rating for restaurants 
 */
@interface RestaurantReviewProvider : NSObject 
{
    id<RestaurantReviewDelegate> _delegate; 
    Restaurant* _restaurant; 
    
}

-(void) fetchReviewsForRestaurant:(Restaurant*) restaurant observer:( id<RestaurantReviewDelegate>) observer; 

//these  methods are written by each provider
-(NSString*) urlForRestaurant:(Restaurant*) restaurant; 
-(NSDictionary*) argsForRestaurant:(Restaurant*) restaurant; 
-(RestaurantReview*) processResult:(NSDictionary*) response; 

@property (nonatomic, assign) id<RestaurantReviewDelegate> delegate; 
@property (nonatomic, retain) Restaurant* restaurant; 


@end



@interface OAuthRestaurantReviewProvider : RestaurantReviewProvider <OAuthRequestDelegate> 
{
    
    OAuthProviderContext* _apiContext;     
    OAuthProviderRequest* _apiRequest; 
    
    NSString* _accessToken; 
    NSString* _accessSecret; 
}


@property (nonatomic, retain) OAuthProviderContext* apiContext; 
@property (nonatomic, retain) OAuthProviderRequest* apiRequest; 


@property (nonatomic, readonly) NSString* apiKey; 
@property (nonatomic, readonly) NSString* apiSecret; 
@property (nonatomic, copy) NSString* accessToken; 
@property (nonatomic, copy) NSString* accessSecret; 


@end

@interface SimpleRestaurantReviewProvider : RestaurantReviewProvider <NSURLConnectionDataDelegate> 
{
    NSURLConnection* _urlConnection; 
    NSURLRequest* _urlRequest; 
    NSMutableData* _incomingData; 
    
}

@property (nonatomic, retain) NSURLConnection* urlConnection; 
@property (nonatomic, retain) NSURLRequest* urlRequest; 
@property (nonatomic, retain) NSMutableData* incomingData; 
@end


@interface YelpReviewProvider : OAuthRestaurantReviewProvider
{

}
  

@end


@interface GoogleReviewProvider : SimpleRestaurantReviewProvider
{
    
}

@end


@interface FoursquareReviewProvider : SimpleRestaurantReviewProvider
{
    
}

@end



