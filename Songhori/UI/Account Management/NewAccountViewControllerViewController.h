//
//  NewAccountViewControllerViewController.h
//  Songhori
//
//  Created by Ali Nouri on 1/6/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"
#import "Restaurant.h" 

@interface NewAccountViewControllerViewController : UIViewController <RestaurantDataDelegate>
{
    Account* _theAccount; 
}

@property (retain, nonatomic) IBOutlet UITextField *urlTextbox;

-(id) initWithSourceURL:(NSString*) url; 
- (IBAction)processNewAccount;

@property (nonatomic, retain) Account* theAccount; 
@property (nonatomic, retain) NSString* initialURL;         //if present, we fill the text edit with it and automatically call submit
@end
