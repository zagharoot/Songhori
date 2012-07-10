//
//  RestaurantReviewTableViewCellCell.m
//  Songhori
//
//  Created by Ali Nouri on 7/10/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import "RestaurantReviewTableViewCell.h"

@implementation RestaurantReviewTableViewCell
@synthesize activityIndicator=_activityIndicator; 
@synthesize logoImageView=_logoImageView; 


///these should be overwritten by each provider cell: 
-(RestaurantReviewProvider*) provider
{
    return nil; 
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
            
        self.activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease]; 
        [self addSubview:self.activityIndicator]; 
        [self.activityIndicator startAnimating]; 
        
        self.logoImageView = [[[UIImageView alloc] initWithImage:[self logoImage]] autorelease]; 
        [self addSubview:self.logoImageView]; 
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) layoutSubviews
{    
    [super layoutSubviews]; 

    CGRect mr = self.bounds; 
    
    CGRect lr = CGRectMake(8,20, 195, 40);     //logo rect 
    self.logoImageView.frame = lr; 
    
    
    CGRect ar = CGRectMake(mr.size.width - 40, mr.size.height/2 - 15, 30,30);   //activityindicator rect 
    self.activityIndicator.frame = ar;     
}


-(void) dealloc
{
    self.activityIndicator = nil; 
    self.logoImageView = nil; 
    
    [super dealloc]; 
}



-(UIImage*) logoImage
{ return nil; } 

#pragma mark- Restaurant review delegate methods 

-(void) reviewer:(RestaurantReviewProvider *)provider forRestaurant:(Restaurant *)restaurant reviewDidFinish:(RestaurantReview *)review
{}



-(void) reviewer:(RestaurantReviewProvider *)provider forRestaurant:(Restaurant *)restaurant reviewDidFailWithError:(NSError *)err
{}



@end


@implementation YelpReviewTableViewCell
@synthesize ratingImageView=_ratingImageView; 
@synthesize reviewLabel=_reviewLabel; 
@synthesize reviewCntLabel=_reviewCntLabel; 


-(RestaurantReviewProvider*) provider
{
    if (_provider)
        return _provider; 
    
    _provider = [[YelpReviewProvider alloc] init]; 
    
    return _provider;     
}


-(UIImage*) logoImage
{
    return [UIImage imageNamed:@"YelpAccountTableCell.png"]; 
}

-(UILabel*) reviewLabel
{
    if (_reviewLabel)
        return _reviewLabel; 
    
    _reviewLabel = [[UILabel alloc] init]; 
    [self addSubview:_reviewLabel]; 
    _reviewLabel.text = @"Reviews"; 
    return _reviewLabel; 
}

-(UILabel*) reviewCntLabel
{
    if (_reviewCntLabel)
        return _reviewCntLabel; 
    
    _reviewCntLabel = [[UILabel alloc] init]; 
    [self addSubview:_reviewCntLabel]; 
    [_reviewCntLabel setTextAlignment:UITextAlignmentRight]; 
    _reviewCntLabel.text = @"0"; 
    
    return _reviewCntLabel; 
}



-(void) layoutSubviews
{
    [super layoutSubviews]; 
    
    
    CGRect mr = self.bounds; 
    
    if (_ratingImageView)
    {
        CGRect rr = CGRectMake(mr.size.width - 100 - 36, mr.size.height/2 - 7, 100, 15   ); 
        self.ratingImageView.frame = rr; 
    }
    
    if (_reviewCntLabel)
    {
        CGRect rcl = CGRectMake(mr.size.width - 42 - 88, mr.size.height/2 + 10, 42, 21);     //the count label
        CGRect rrl = CGRectMake(mr.size.width - 42 - 40, mr.size.height/2 + 10, 42, 21);       //the word reviews label
        
        self.reviewCntLabel.frame = rcl; 
        self.reviewLabel.frame = rrl; 
    }
}



-(void) dealloc
{
    self.ratingImageView = nil; 
    self.reviewLabel = nil; 
    self.reviewCntLabel = nil; 
    
    [_provider release]; 
    
    [super dealloc]; 
}

/*
#pragma mark- Restaurant review delegate methods 

-(void) reviewer:(RestaurantReviewProvider *)provider forRestaurant:(Restaurant *)restaurant reviewDidFinish:(RestaurantReview *)review
{
    if ([provider isKindOfClass:[YelpReviewProvider class]])        //a yelp review
    {
        self.yelpNumberOfReviewsLabel.text = [NSString stringWithFormat:@"%d", review.numberOfReviews]; 
        
        NSData* idata = [NSData dataWithContentsOfURL:[NSURL URLWithString:review.ratingImageURL]]; 
        UIImage* img = [UIImage imageWithData:idata]; 
        self.yelpRatingImageView.image = img; 
        
        self.yelpTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark; 
        
    }else if ([provider isKindOfClass:[GoogleReviewProvider class]])    //a google review
    {
        self.googleRatingView.alpha = 1.0; 
        self.googleRatingView.rate = review.rating;
        
        self.googleTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark; 
    }else if ([provider isKindOfClass:[FoursquareReviewProvider class]])
    {
        self.foursquareCheckinsLabel.text = [NSString stringWithFormat:@"%d", (int)review.numberOfReviews]; 
        self.foursquareTipsLabel.text =     [NSString stringWithFormat:@"%d", (int)review.rating]; 
        
        self.foursquareTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark; 
    }
    
}



-(void) reviewer:(RestaurantReviewProvider *)provider forRestaurant:(Restaurant *)restaurant reviewDidFailWithError:(NSError *)err
{
    if ([provider isKindOfClass:[YelpReviewProvider class]])        //a yelp review
    {
        self.yelpTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark; 
        
    }else if ([provider isKindOfClass:[GoogleReviewProvider class]]) //a google review
    {
        self.googleTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark; 
    }else if ([provider isKindOfClass:[FoursquareReviewProvider class]])
    {
        self.foursquareTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark; 
    }
    
    
    
}
*/



#pragma mark- Restaurant review delegate methods 

-(void) reviewer:(RestaurantReviewProvider *)provider forRestaurant:(Restaurant *)restaurant reviewDidFinish:(RestaurantReview *)review
{
        self.reviewCntLabel.text = [NSString stringWithFormat:@"%d", review.numberOfReviews]; 
        
        NSData* idata = [NSData dataWithContentsOfURL:[NSURL URLWithString:review.ratingImageURL]]; 
        UIImage* img = [UIImage imageWithData:idata]; 
        self.ratingImageView.image = img; 
        
        [self.activityIndicator removeFromSuperview]; 
        self.activityIndicator = nil; 
    
        self.accessoryType = UITableViewCellAccessoryCheckmark;         
}



-(void) reviewer:(RestaurantReviewProvider *)provider forRestaurant:(Restaurant *)restaurant reviewDidFailWithError:(NSError *)err
{
    [self.activityIndicator removeFromSuperview]; 
    self.activityIndicator = nil; 
    self.accessoryType = UITableViewCellAccessoryCheckmark; 
        
}




@end



