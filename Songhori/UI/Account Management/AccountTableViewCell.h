//
//  AccountTableViewCell.h
//  rlimage
//
//  Created by Ali Nouri on 7/4/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"

@class AccountsUIViewController; 

@interface AccountTableViewCell : UITableViewCell 
{
    NSString* imgPath; 
    UIImageView* _img;                  //account image logo 
    Account* _account; 
    AccountsUIViewController* parent;         
}


@property (nonatomic, retain) UIImageView* logoImageView; 
@property (nonatomic, retain) Account* theAccount; 

@property (nonatomic, retain) UISwitch* deactivateSwitch; 

- (id) initWithFrame:(CGRect)frame andAccount:(Account*) a andTableController:(AccountsUIViewController*) p; 

-(void) deactivateAccount:(id) sender; 
@end
