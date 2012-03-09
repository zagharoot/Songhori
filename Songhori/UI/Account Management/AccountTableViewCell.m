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
@synthesize detailLabel=_detailLabel;  

//this is a retain property
-(void) setTheAccount:(Account *)theAccount
{    
    [_account release]; 
    _account = [theAccount retain]; 
    
    self.detailLabel.text = theAccount.info;  
    
    [self setNeedsDisplay]; 
}


-(UILabel*) detailLabel
{
    if (!_detailLabel)
    {
        _detailLabel = [[UILabel alloc] initWithFrame:self.bounds]; 
        _detailLabel.text = @""; 
        _detailLabel.textAlignment = UITextAlignmentRight; 
        _detailLabel.backgroundColor = [UIColor clearColor]; 
        _detailLabel.font = [UIFont systemFontOfSize:10]; 
        _detailLabel.textColor = [UIColor grayColor]; 
    }
    
    return _detailLabel; 
    
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


-(UIButton*) refreshBtn
{
    if (!_refreshBtn)
    {
        _refreshBtn = [UIButton buttonWithType:UIButtonTypeInfoLight]; 
        [_refreshBtn addTarget:self action:@selector(refreshAccount:) forControlEvents:UIControlEventTouchUpInside]; 
    }
    
    return _refreshBtn; 
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
        [self.contentView addSubview:self.detailLabel]; 

        self.clipsToBounds = YES; 
        
        if (! [self.theAccount isCompound])
        {
            [self.contentView addSubview:self.deactivateSwitch]; 
            self.selectionStyle = UITableViewCellSelectionStyleNone; 
            self.accessoryType = UITableViewCellAccessoryNone; 
        }else {
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
        }
        
        if ([self.theAccount isSyncable])
            [self.contentView addSubview:self.refreshBtn]; 
    }
    
    return self; 
}


-(void) deactivateAccount:(id)sender
{
    self.theAccount.active  = [self.deactivateSwitch isOn]; 
    self.detailLabel.text = self.theAccount.info;  
}


-(void) refreshAccount:(id)sender
{
    [self.theAccount syncDataForced]; 
}

//define how the contents are displayed in the bounding box
-(void) layoutSubviews
{
    [super layoutSubviews];     
    
    CGRect b = self.bounds; 
    
    b.origin.x = b.size.width - 110; 
    b.origin.y = b.size.height/2 - 15; 
    
    if (![self.theAccount isCompound])
        self.deactivateSwitch.frame = b; 
    
    
    b = self.bounds;     
    //the refresh button 
    b.origin.x = 5; 
    b.origin.y = (b.size.height - 30)/2; 
    b.size.height = 30; 
    b.size.width = 30; 
    
    if ([self.theAccount isSyncable])
        self.refreshBtn.frame = b; 
    
    
    b = self.bounds; 
    
    b.origin.x = 50; // 5; 
    b.origin.y = (b.size.height- 40)/2; //40 is the height of the logo image
    b.size.height = 40; 
    b.size.width = 195; 
    
    self.logoImageView.frame = b; 
    
    
    
    b = self.bounds; 
    
    b.origin.x = 50; 
    b.origin.y = b.size.height - 22; 
    b.size.width = b.size.width - 50 - 110; 
    b.size.height = 22; 
    
    self.detailLabel.frame = b; 
    
}


-(void) dealloc
{
    self.logoImageView = nil; 
    self.theAccount = nil; 
    self.deactivateSwitch = nil; 
    self.refreshBtn = nil; 
    
    [super dealloc]; 
}


@end
