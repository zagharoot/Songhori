//
//  RestaurantReview.h
//  Songhori
//
//  Created by Ali Nouri on 7/3/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Restaurant; 

@interface RestaurantReview : NSObject
{
    Restaurant* _restaurant; 
    
    //info
    NSString* _ratingImageURL; 
    double _rating; 
    int _numberOfReviews; 
    NSString* _reviewID;        //this is the ID that the provider uses to identify this restaurant or the review
    NSDictionary* _originalData; //the data received from the website 
}


-(id) initWithRestaurant:(Restaurant*) r; 


@property (nonatomic, assign) Restaurant* restaurant; 
@property (nonatomic) double rating; 
@property (nonatomic) int numberOfReviews; 
@property (nonatomic, copy) NSString* ratingImageURL; 
@property (nonatomic, copy) NSString* reviewID; 
@property (nonatomic, retain) NSDictionary* originalData; 

@property (nonatomic,retain) Class providerClass;               //this says who's providing this review

@end
