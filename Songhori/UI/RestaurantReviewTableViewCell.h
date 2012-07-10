//
//  RestaurantReviewTableViewCellCell.h
//  Songhori
//
//  Created by Ali Nouri on 7/10/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantReviewTableViewCell : UITableViewCell
{
        
    UIImageView* _logoImageView; 
    UIActivityIndicatorView* _activityIndicator; 
    
}


@property (nonatomic, retain) UIActivityIndicatorView* activityIndicator; 
@property (nonatomic, retain) UIImageView* logoImageView; 


-(UIImage*) logoImage;      //each provider should have its own



@end





@interface YelpReviewTableViewCell : RestaurantReviewTableViewCell
{
    UIImageView* _ratingImageView; 
    UILabel* _reviewLabel; 
    UILabel* _reviewCntLabel; 
}


@property (nonatomic, retain) UIImageView* ratingImageView; 
@property (nonatomic, retain) UILabel* reviewLabel; 
@property (nonatomic, retain) UILabel* reviewCntLabel; 

@end