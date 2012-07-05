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
    
    [super dealloc]; 
}



@end
