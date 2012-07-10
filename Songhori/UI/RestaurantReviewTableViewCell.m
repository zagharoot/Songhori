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


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
            
        self.activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease]; 
        
        
        self.logoImageView = [[[UIImageView alloc] initWithImage:[self logoImage]] autorelease]; 
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
    
    CGRect lr = CGRectMake(9, 13, 195, 40);     //logo rect 
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


@end


@implementation YelpReviewTableViewCell
@synthesize ratingImageView=_ratingImageView; 
@synthesize reviewLabel=_reviewLabel; 
@synthesize reviewCntLabel=_reviewCntLabel; 

-(UIImage*) logoImage
{
    return [UIImage imageNamed:@"YelpAccountTableCell.png"]; 
}

-(UILabel*) reviewLabel
{
    if (_reviewLabel)
        return _reviewLabel; 
    
    _reviewLabel = [[UILabel alloc] init]; 
    _reviewLabel.text = @"Reviews"; 
    return _reviewLabel; 
}

-(UILabel*) reviewCntLabel
{
    if (_reviewCntLabel)
        return _reviewCntLabel; 
    
    _reviewCntLabel = [[UILabel alloc] init]; 
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
        CGRect rr = CGRectMake(mr.size.width - 60, mr.size.height/2 - 30, 50, 10   ); 
        self.ratingImageView.frame = rr; 
    }
    
    if (_reviewCntLabel)
    {
        CGRect rcl = CGRectMake(mr.size.width - 60, mr.size.height/2 + 10, 40, 15);     //the count label
        CGRect rrl = CGRectMake(mr.size.width - 25, mr.size.height/2+10, 30, 15);       //the word reviews label
        
        self.reviewCntLabel.frame = rcl; 
        self.reviewLabel.frame = rrl; 
    }
    
    
    
    
}



-(void) dealloc
{
    self.ratingImageView = nil; 
    self.reviewLabel = nil; 
    self.reviewCntLabel = nil; 
    
    
    [super dealloc]; 
}



@end



