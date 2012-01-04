//
//  AccountTableViewCell.m
//  rlimage
//
//  Created by Ali Nouri on 7/4/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "AccountTableViewCell.h"
#import "AccountsUIViewController.h" 


@implementation AccountTableViewCell
@synthesize logoImageView=_img; 
@synthesize theAccount = _account; 
@synthesize deactivateSwitch=_deactivateSwitch; 

//this is a retain property
-(void) setTheAccount:(Account *)theAccount
{    
    [_account release]; 
    _account = [theAccount retain]; 
    
    [self setNeedsDisplay]; 
}



-(UISwitch*) deactivateSwitch
{
    if (!_deactivateSwitch)
    {
        _deactivateSwitch = [[UISwitch alloc] init]; 
        [_deactivateSwitch setOn:self.theAccount.active]; 
        [_deactivateSwitch addTarget:self action:@selector(deactivateAccount:) forControlEvents:UIControlEventValueChanged]; 
        
    }
        
    return _deactivateSwitch; 
}

//create the image view lazily
-(UIImageView*) logoImageView
{
    if (_img == nil) 
    {
        _img = [[UIImageView alloc] init]; 
        [self.contentView addSubview:_img]; 
    }
    
    return _img; 
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    //disable this method all together? 
    return nil; 
    
/*    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
*/

}


- (id) initWithFrame:(CGRect)frame andAccount:(Account*) a andTableController:(AccountsUIViewController *)p
{
//    if (self = [super initWithFrame:frame]) 
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"])
    {
        self.theAccount = a; 
        parent = p; 
        
        self.logoImageView.image = a.logoImage; 
        
        [self.contentView addSubview:self.logoImageView]; 
        [self.contentView addSubview:self.deactivateSwitch]; 
        
        self.clipsToBounds = YES; 
        self.selectionStyle = UITableViewCellSelectionStyleNone; 
    }
    
    return self; 
}


-(void) deactivateAccount:(id)sender
{
    self.theAccount.active  = [self.deactivateSwitch isOn]; 
}


//define how the contents are displayed in the bounding box
-(void) layoutSubviews
{
    [super layoutSubviews];     
    
    CGRect b = self.bounds; 
    
    b.origin.x = b.size.width - 110; 
    b.origin.y = b.size.height/2 - 15; 
    
    self.deactivateSwitch.frame = b; 
    
    
    b = self.bounds; 
    
    b.origin.x = 5; 
    b.origin.y = (b.size.height- 40)/2; //40 is the height of the logo image
    b.size.height = 40; 
    b.size.width = 195; 
    
    self.logoImageView.frame = b; 
    
}


-(void) dealloc
{
    self.logoImageView = nil; 
    self.theAccount = nil; 
    self.deactivateSwitch = nil; 
    
    [super dealloc]; 
}


@end
