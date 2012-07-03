//
//  RestaurantURLViewController.h
//  Songhori
//
//  Created by Ali Nouri on 7/3/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantURLViewController : UIViewController
{
    NSURLRequest* request; 
}

-(id) initWithURL: (NSString*) u; 

@property (retain, nonatomic) IBOutlet UIWebView *webView;

@end
