//
//  RestaurantDetailViewController.m
//  Songhori
//
//  Created by Ali Nouri on 12/16/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "RestaurantDetailViewController.h"
#import "RestaurantURLViewController.h" 

//the sections in the table view
#define MOREINFO_SECTION    1
#define REVIEW_SECTION      0



@implementation RestaurantDetailViewController
@synthesize tableView = _tableView;
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
        
                
        //make the tableview cells 
        reviewCells = [[NSMutableArray alloc] initWithCapacity:3]; 
        
        YelpReviewTableViewCell* ytc = [[YelpReviewTableViewCell alloc] init]; 
        [ytc.provider fetchReviewsForRestaurant:r observer:ytc]; 
        [reviewCells addObject:ytc]; 
        [ytc release]; 
        

        GoogleReviewTableViewCell* gtc = [[GoogleReviewTableViewCell alloc] init]; 
        [gtc.provider fetchReviewsForRestaurant:r observer:gtc]; 
        [reviewCells addObject:gtc]; 
        [gtc release]; 
        
        
        FoursquareTableViewCell* ftc = [[FoursquareTableViewCell alloc] init]; 
        [ftc.provider fetchReviewsForRestaurant:r observer:ftc]; 
        [reviewCells addObject:ftc]; 
        [ftc release]; 
        
    }
    
    return self; 
}

- (void)openGoogleMap 
{
    NSString* str = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%f,%f", self.restaurant.coordinate.latitude, self.restaurant.coordinate.longitude]; 

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]]; 
}

-(void) openRestaurantWebsite
{
    RestaurantURLViewController* rvc = [[RestaurantURLViewController alloc] initWithURL:self.restaurant.url]; 
    
    [self.navigationController pushViewController:[rvc autorelease] animated:YES]; 
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
    
    
}

- (void)viewDidUnload
{    
    [self setTableView:nil];
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
    //TODO: don't know why uncommenting this will crash
    //    self.yelpReviewProvider = nil; 
    //    self.googleReviewProvider = nil; 

    [reviewCells release]; 
    
    [_tableView release];
    [super dealloc];
}



#pragma mark - table view delegates 

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == MOREINFO_SECTION ) 
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"general"]; 
        if (!cell)
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"general"] autorelease]; 
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Open In Map App"; 
                break;
            case 1: 
                cell.textLabel.text = @"Open Restaurant Website"; 
            default:
                break;
        }
        
        return cell; 
    }
    

    if (indexPath.row < [reviewCells count])
        return [reviewCells objectAtIndex:indexPath.row]; 
    else
        return nil; 
    
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case MOREINFO_SECTION:
            return @"More Info"; 
        case REVIEW_SECTION:
            return @"Reviews"; 
        default:
            return @""; 
            break;
    }
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case MOREINFO_SECTION:
            return 44; 
        case REVIEW_SECTION:
            return 80; 
            
        default:
            return 44; 
    }
    
    
}

-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    switch (section) {
        case MOREINFO_SECTION:
            return 2; 
        case REVIEW_SECTION:
            return [reviewCells count];
            break;
            
        default:
            return 0; 
            break;
    }
    
}

-(int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2; 
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == MOREINFO_SECTION)
    {
        switch (indexPath.row) {
            case 0:                 //google 
                [self openGoogleMap]; 
                break;
                
            case 1: 
                [self openRestaurantWebsite]; 
                
            default:
                break;
        }
    }
}



@end
