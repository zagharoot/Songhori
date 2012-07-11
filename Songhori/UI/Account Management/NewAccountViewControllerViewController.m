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
@synthesize activityIndicator;
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
    [self.activityIndicator stopAnimating]; 
    
    if (self.initialURL)
    {
        //TODO: copy to text edit and call submit
        self.urlTextbox.text = self.initialURL; 
        [self processNewAccount]; 
        
    }
    
}

- (void)viewDidUnload
{
    [self setUrlTextbox:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.initialURL = nil; 
    self.theAccount = nil; 
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//use the url to construct the account and download detail data 
-(IBAction)processNewAccount
{
    
        self.theAccount = [[[GoogleMapAccount alloc] initWithURL:self.urlTextbox.text] autorelease]; 
        self.theAccount.delegate = self; 
    
    [self.activityIndicator startAnimating]; 
}

- (IBAction)cancelPage:(id)sender {
    [self dismissModalViewControllerAnimated:YES]; 
}


-(IBAction) addAcountAndExit
{
    if (self.theAccount) 
        [[AccountManager standardAccountManager] addAccount:self.theAccount]; 
    
    [self dismissModalViewControllerAnimated:YES]; 
}




- (void)dealloc {
    [urlTextbox release];
    [activityIndicator release];
    [super dealloc];
}

#pragma mark- delegate methods 

-(void) syncFinished:(id)provider
{
    //data download complete. now we can populate the table 
    [self.activityIndicator stopAnimating]; 
    [self addAcountAndExit]; 
    
}


-(void) syncFailedToFinishForProvider:(id) provider withError:(NSError*) err
{
    //TODO: show an error dialog box 
}


#pragma mark- restaurant data delegate 

-(void) restaudantDataDidBecomeAvailable:(NSArray*) restaurants forRegion:(MKCoordinateRegion) region fromProvider:(id) provider
{
    
}


@end






