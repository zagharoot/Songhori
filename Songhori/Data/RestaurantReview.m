//
//  RestaurantReview.m
//  Songhori
//
//  Created by Ali Nouri on 7/3/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import "RestaurantReview.h"
#import "Restaurant.h"


@implementation RestaurantReview

@synthesize restaurant=_restaurant; 
@synthesize numberOfReviews=_numberOfReviews; 
@synthesize rating=_rating; 
@synthesize ratingImageURL= _ratingImageURL; 
@synthesize providerClass; 
@synthesize reviewID=_reviewID; 
@synthesize originalData=_originalData; 

-(id) initWithRestaurant:(Restaurant *)r
{
    self = [super init]; 
    if (self)
    {
        self.restaurant = r; 
    }
    
    return self; 
    
}


-(void) dealloc
{
    self.ratingImageURL = nil; 
    self.reviewID = nil; 
    self.originalData = nil; 
    
    [super dealloc]; 
}



@end
