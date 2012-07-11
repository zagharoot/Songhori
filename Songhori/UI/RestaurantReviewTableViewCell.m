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
        [self.contentView addSubview:self.activityIndicator]; 
        [self.activityIndicator startAnimating]; 
        
        self.logoImageView = [[[UIImageView alloc] initWithImage:[self logoImage]] autorelease]; 
        [self.contentView addSubview:self.logoImageView]; 
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
    
    
    CGRect ar = CGRectMake(mr.size.width - 60, mr.size.height/2 - 15, 30,30);   //activityindicator rect 
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
{
    
    [self.activityIndicator removeFromSuperview]; 
    self.activityIndicator = nil; 
    
//    self.accessoryType = UITableViewCellAccessoryCheckmark;       
    [self setNeedsLayout]; 
    [self setNeedsDisplay]; 
}



-(void) reviewer:(RestaurantReviewProvider *)provider forRestaurant:(Restaurant *)restaurant reviewDidFailWithError:(NSError *)err
{
    [self.activityIndicator removeFromSuperview]; 
    self.activityIndicator = nil; 
    self.accessoryType = UITableViewCellAccessoryCheckmark; 
}



@end


@implementation YelpReviewTableViewCell
@synthesize ratingImageView=_ratingImageView; 
@synthesize reviewLabel=_reviewLabel; 
@synthesize reviewCntLabel=_reviewCntLabel; 


-(UIImageView*) ratingImageView
{
    if (_ratingImageView)
        return _ratingImageView; 
    
    _ratingImageView = [[UIImageView alloc] init]; 
    [self.contentView addSubview:_ratingImageView]; 
    return _ratingImageView; 
}

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
    
    _reviewLabel.font = [_reviewLabel.font fontWithSize:10]; 
    _reviewLabel.textColor = [UIColor darkGrayColor]; 
    _reviewLabel.backgroundColor = [UIColor clearColor]; 
    
    [self.contentView addSubview:_reviewLabel]; 
    _reviewLabel.text = @"Reviews"; 
    return _reviewLabel; 
}

-(UILabel*) reviewCntLabel
{
    if (_reviewCntLabel)
        return _reviewCntLabel; 
    
    _reviewCntLabel = [[UILabel alloc] init]; 
    _reviewCntLabel.font = [_reviewCntLabel.font fontWithSize:10]; 
    _reviewCntLabel.textColor = [UIColor darkGrayColor]; 
    _reviewCntLabel.backgroundColor = [UIColor clearColor]; 
    
    [self.contentView addSubview:_reviewCntLabel]; 
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
        CGRect rr = CGRectMake(mr.size.width - 83 - 47, mr.size.height/2 - 7, 83, 15   ); 
        self.ratingImageView.frame = rr; 
    }
    
    if (_reviewCntLabel)
    {
        CGRect rcl = CGRectMake(mr.size.width - 42 - 88, mr.size.height/2 + 10, 42, 21);     //the count label
        CGRect rrl = CGRectMake(mr.size.width - 42 - 44, mr.size.height/2 + 10, 42, 21);       //the word reviews label
        
        self.reviewCntLabel.frame = rcl; 
        self.reviewLabel.frame = rrl; 
    }
}



-(void) dealloc
{
    self.ratingImageView = nil; 
    self.reviewLabel = nil; 
    self.reviewCntLabel = nil; 
  
    //TODO: don't know why this causes crash 
//    [_provider release]; 
    
    [super dealloc]; 
}



#pragma mark- Restaurant review delegate methods 

-(void) reviewer:(RestaurantReviewProvider *)provider forRestaurant:(Restaurant *)restaurant reviewDidFinish:(RestaurantReview *)review
{
        self.reviewCntLabel.text = [NSString stringWithFormat:@"%d", review.numberOfReviews]; 
        
        NSData* idata = [NSData dataWithContentsOfURL:[NSURL URLWithString:review.ratingImageURL]]; 
        UIImage* img = [UIImage imageWithData:idata]; 
        self.ratingImageView.image = img; 
    
        
    [super reviewer:provider forRestaurant:restaurant reviewDidFinish:review]; 
}



-(void) reviewer:(RestaurantReviewProvider *)provider forRestaurant:(Restaurant *)restaurant reviewDidFailWithError:(NSError *)err
{
    [super reviewer:provider forRestaurant:restaurant reviewDidFailWithError:err]; 
        
}




@end

//-----------------------------------------------------------Foursquare --------------------------------------------------------------

@implementation FoursquareTableViewCell
@synthesize checkinLabel=_checkinLabel; 
@synthesize checkinCntLabel=_checkinCntLabel; 
@synthesize tipLabel=_tipLabel; 
@synthesize tipCntLabel=_tipCntLabel; 



-(UILabel*) checkinLabel
{
    if (_checkinLabel)
        return _checkinLabel; 
    
    _checkinLabel = [[UILabel alloc] init]; 
    _checkinLabel.font = [_checkinLabel.font fontWithSize:10]; 
    _checkinLabel.textColor = [UIColor darkGrayColor]; 
    _checkinLabel.backgroundColor = [UIColor clearColor]; 
    
    [self.contentView addSubview:_checkinLabel]; 
    _checkinLabel.text = @"Checkins"; 
    return _checkinLabel; 
}

-(UILabel*) checkinCntLabel
{
    if (_checkinCntLabel)
        return _checkinCntLabel; 
    
    _checkinCntLabel = [[UILabel alloc] init]; 
    _checkinCntLabel.font = [_checkinCntLabel.font fontWithSize:10]; 
    _checkinCntLabel.textColor = [UIColor darkGrayColor]; 
    _checkinCntLabel.backgroundColor = [UIColor clearColor]; 
    
    [self.contentView addSubview:_checkinCntLabel]; 
    [_checkinCntLabel setTextAlignment:UITextAlignmentRight]; 
    _checkinCntLabel.text = @"0"; 
    
    return _checkinCntLabel; 
}

-(UILabel*) tipLabel
{
    if (_tipLabel)
        return _tipLabel; 
    
    _tipLabel = [[UILabel alloc] init]; 
    _tipLabel.font = [_tipLabel.font fontWithSize:10]; 
    _tipLabel.textColor = [UIColor darkGrayColor]; 
    _tipLabel.backgroundColor = [UIColor clearColor]; 
    
    [self.contentView addSubview:_tipLabel]; 
    _tipLabel.text = @"Tips"; 
    return _tipLabel; 
}

-(UILabel*) tipCntLabel
{
    if (_tipCntLabel)
        return _tipCntLabel; 
    
    _tipCntLabel = [[UILabel alloc] init]; 
    _tipCntLabel.font = [_tipCntLabel.font fontWithSize:10]; 
    _tipCntLabel.textColor = [UIColor darkGrayColor]; 
    _tipCntLabel.backgroundColor = [UIColor clearColor]; 
    
    [self.contentView addSubview:_tipCntLabel]; 
    [_tipCntLabel setTextAlignment:UITextAlignmentRight]; 
    _tipCntLabel.text = @"0"; 
    
    return _tipCntLabel; 
}


-(RestaurantReviewProvider*) provider
{
    if (_provider)
        return _provider; 
    
    _provider = [[FoursquareReviewProvider alloc] init]; 
    
    return _provider;     
}

-(UIImage*) logoImage
{
    return [UIImage imageNamed:@"YelpAccountTableCell.png"]; 
}


-(void) layoutSubviews
{
    [super layoutSubviews]; 
    
    
    CGRect mr = self.bounds; 
    
    if (_tipCntLabel)
    {
        CGRect tcl = CGRectMake(mr.size.width - 42 - 88, mr.size.height/2 - 25, 42, 21);     //the count label
        CGRect trl = CGRectMake(mr.size.width - 42 - 44, mr.size.height/2 - 25, 42, 21);       //the word reviews label
        
        self.checkinCntLabel.frame = tcl; 
        self.checkinLabel.frame = trl; 

        CGRect rcl = CGRectMake(mr.size.width - 42 - 88, mr.size.height/2 + 5, 42, 21);     //the count label
        CGRect rrl = CGRectMake(mr.size.width - 42 - 44, mr.size.height/2 + 5, 42, 21);       //the word reviews label
        
        self.tipCntLabel.frame = rcl; 
        self.tipLabel.frame = rrl; 

    
    }
}

-(void) reviewer:(RestaurantReviewProvider *)provider forRestaurant:(Restaurant *)restaurant reviewDidFinish:(RestaurantReview *)review
{
    
    self.checkinCntLabel.text = [NSString stringWithFormat:@"%d", (int)review.numberOfReviews]; 
    self.tipCntLabel.text =     [NSString stringWithFormat:@"%d", (int)review.rating]; 
    
    [super reviewer:provider forRestaurant:restaurant reviewDidFinish:review]; 
}



-(void) reviewer:(RestaurantReviewProvider *)provider forRestaurant:(Restaurant *)restaurant reviewDidFailWithError:(NSError *)err
{
    [super reviewer:provider forRestaurant:restaurant reviewDidFailWithError:err]; 
}



@end




//----------------------------------------------------------------------Google --------------------------------------------------------



@implementation GoogleReviewTableViewCell
@synthesize ratingView=_ratingView; 

-(RestaurantReviewProvider*) provider
{
    if (_provider)
        return _provider; 
    
    _provider = [[GoogleReviewProvider alloc] init]; 
    
    return _provider;     
}

-(DYRateView*) ratingView
{
    if (_ratingView)
        return _ratingView; 
    
    
    _ratingView = [[DYRateView alloc] init]; 
    _ratingView.editable = NO; 
    _ratingView.backgroundColor = [UIColor clearColor]; 
    _ratingView.opaque = NO; 
    
    [self.contentView addSubview:_ratingView]; 
    
    return _ratingView; 
}

-(UIImage*) logoImage
{
    return [UIImage imageNamed:@"GoogleMapListTableCell.png"]; 
}

-(void) layoutSubviews
{
    [super layoutSubviews]; 
    
    
    CGRect mr = self.bounds; 
    
    if (_ratingView)
    {
        CGRect rr = CGRectMake(mr.size.width - 100 - 36, mr.size.height/2 - 7, 100, 15   ); 
        self.ratingView.frame = rr; 
    }    
}


-(void) dealloc
{
    [_ratingView release]; 
    
    [super dealloc]; 
}


 #pragma mark- Restaurant review delegate methods 
 
 -(void) reviewer:(RestaurantReviewProvider *)provider forRestaurant:(Restaurant *)restaurant reviewDidFinish:(RestaurantReview *)review
 {
     self.ratingView.rate = review.rating;
 
     [super reviewer:provider forRestaurant:restaurant reviewDidFinish:review]; 
 }
 
 
 
 -(void) reviewer:(RestaurantReviewProvider *)provider forRestaurant:(Restaurant *)restaurant reviewDidFailWithError:(NSError *)err
 {
     [super reviewer:provider forRestaurant:restaurant reviewDidFailWithError:err]; 
 }



@end


