//
//  RestaurantURLViewController.m
//  Songhori
//
//  Created by Ali Nouri on 7/3/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import "RestaurantURLViewController.h"

@interface RestaurantURLViewController ()

@end

@implementation RestaurantURLViewController
@synthesize webView;


-(id) initWithURL:(NSString *)u
{
    self = [super initWithNibName:nil bundle:nil]; 
    if (self)
    {
        request = [[NSURLRequest requestWithURL:[NSURL URLWithString:u]] retain]; 
    }
    
    return self; 
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return nil; 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.webView loadRequest:request]; 
    
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    
    [request release]; 
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [webView release];
    [super dealloc];
}
@end
