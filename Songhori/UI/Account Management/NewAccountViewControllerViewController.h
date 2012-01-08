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
    DynamicAccount* _theAccount; 
}

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) IBOutlet UITextField *urlTextbox;

-(id) initWithSourceURL:(NSString*) url; 
- (IBAction)processNewAccount;
- (IBAction)cancelPage:(id)sender;

@property (nonatomic, retain) DynamicAccount* theAccount; 
@property (nonatomic, retain) NSString* initialURL;         //if present, we fill the text edit with it and automatically call submit
@end
