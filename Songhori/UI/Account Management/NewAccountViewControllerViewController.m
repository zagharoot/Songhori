//
//  NewAccountViewControllerViewController.m
//  Songhori
//
//  Created by Ali Nouri on 1/6/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import "NewAccountViewControllerViewController.h"
#import "AccountManager.h"
#import "GoogleMapAccount.h"

@interface NewAccountViewControllerViewController ()

@end

@implementation NewAccountViewControllerViewController
@synthesize urlTextbox;
@synthesize initialURL;
@synthesize theAccount=_theAccount; 

-(id) initWithSourceURL:(NSString *)url
{
    self = [self init]; 
    if (self) 
    {
        self.initialURL = url; 
    }
    
    return self; 
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.initialURL)
    {
        //TODO: copy to text edit and call submit
        
        
    }
    
}

- (void)viewDidUnload
{
    [self setUrlTextbox:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.initialURL = nil; 
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) syncFinished:(id)provider
{
    //data download complete. now we can populate the table 
}

//use the url to construct the account and download detail data 
-(IBAction)processNewAccount
{
        GoogleMapAccount* ga = [[GoogleMapAccount alloc] initWithURL:self.urlTextbox.text]; 
        ga.delegate = self; 
}


-(IBAction) addAcountAndExit
{
    if (self.theAccount) 
        [[AccountManager standardAccountManager] addAccount:self.theAccount]; 
    
    [self dismissModalViewControllerAnimated:YES]; 
}




- (void)dealloc {
    [urlTextbox release];
    [super dealloc];
}
@end
