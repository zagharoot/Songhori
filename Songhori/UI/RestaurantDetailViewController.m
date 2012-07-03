//
//  RestaurantDetailViewController.m
//  Songhori
//
//  Created by Ali Nouri on 12/16/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "RestaurantDetailViewController.h"

@implementation RestaurantDetailViewController
@synthesize tableView = _tableView;
@synthesize googleTableViewCell = _googleTableViewCell;
@synthesize yelpTableViewCell = _yelpTableViewCell;
@synthesize restaurant=_restaurant; 


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"RestaurantDetailViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(id) initWithRestaurant:(Restaurant *)r
{
    self = [super initWithNibName:@"RestaurantDetailViewController" bundle:[NSBundle mainBundle]]; 
    if (self) 
    {
        self.restaurant = r; 
    }
    
    return self; 
}

- (IBAction)openGoogleMap 
{
    NSString* str = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%f,%f", self.restaurant.coordinate.latitude, self.restaurant.coordinate.longitude]; 

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]]; 
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO]; 
    self.navigationController.title = self.restaurant.name;
    self.navigationItem.title = self.restaurant.name; 
    
    
    [super viewWillAppear:animated]; 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setGoogleTableViewCell:nil];
    [self setYelpTableViewCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_tableView release];
    [_googleTableViewCell release];
    [_yelpTableViewCell release];
    [super dealloc];
}



#pragma mark - table view delegates 

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 0) 
        return nil; 
    
    
    switch (indexPath.row) {
        case 0:                     //google cell
            return self.googleTableViewCell; 
            break;
        case 1:                     //yelp cell
            return self.yelpTableViewCell; 
            
        default:
            return nil; 
    }
}

-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section ==0)
        return 2; 
    else 
        return 0; 
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:                 //google cell
                [self openGoogleMap]; 
                break;
                
            default:
                break;
        }
    }
}






@end
