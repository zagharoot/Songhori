//
//  RestaurantReviewTableViewCellCell.h
//  Songhori
//
//  Created by Ali Nouri on 7/10/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//


#import "RestaurantReviewProvider.h"
#import <UIKit/UIKit.h>
#import "DYRateView.h" 

@interface RestaurantReviewTableViewCell : UITableViewCell <RestaurantReviewDelegate>
{
        
    UIImageView* _logoImageView; 
    UIActivityIndicatorView* _activityIndicator; 
    
}


@property (nonatomic, retain) UIActivityIndicatorView* activityIndicator; 
@property (nonatomic, retain) UIImageView* logoImageView; 
@property (nonatomic, readonly) RestaurantReviewProvider* provider; 

-(UIImage*) logoImage;      //each provider should have its own



@end





@interface YelpReviewTableViewCell : RestaurantReviewTableViewCell
{
    UIImageView* _ratingImageView; 
    UILabel* _reviewLabel; 
    UILabel* _reviewCntLabel; 
    
    
    YelpReviewProvider* _provider; 
}


@property (nonatomic, retain) UIImageView* ratingImageView; 
@property (nonatomic, retain) UILabel* reviewLabel; 
@property (nonatomic, retain) UILabel* reviewCntLabel; 

@end





@interface GoogleReviewTableViewCell : RestaurantReviewTableViewCell
{
    DYRateView* _ratingView; 
    
    GoogleReviewProvider* _provider; 
}

@property (nonatomic, retain) DYRateView* ratingView; 

@end



@interface FoursquareTableViewCell : RestaurantReviewTableViewCell
{
    UILabel* _checkinLabel; 
    UILabel* _checkinCntLabel; 
    
    UILabel* _tipLabel; 
    UILabel* _tipCntLabel; 
    
    
    FoursquareReviewProvider* _provider; 
    
}




@property (nonatomic, retain) UILabel* checkinLabel; 
@property (nonatomic, retain) UILabel* checkinCntLabel; 

@property (nonatomic, retain) UILabel* tipLabel; 
@property (nonatomic, retain) UILabel* tipCntLabel; 





@end