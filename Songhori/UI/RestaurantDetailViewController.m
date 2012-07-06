//
//  RestaurantDetailViewController.m
//  Songhori
//
//  Created by Ali Nouri on 12/16/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "RestaurantDetailViewController.h"
#import "RestaurantURLViewController.h" 


@implementation RestaurantDetailViewController
@synthesize tableView = _tableView;
@synthesize googleTableViewCell = _googleTableViewCell;
@synthesize yelpTableViewCell = _yelpTableViewCell;
@synthesize yelpNumberOfReviewsLabel = _yelpNumberOfReviewsLabel;
@synthesize googleNumberOfReviewsLabel = _googleNumberOfReviewsLabel;
@synthesize yelpRatingImageView = _yelpRatingImageView;
@synthesize restaurant=_restaurant; 
@synthesize foursquareTableViewCell = _foursquareTableViewCell;
@synthesize googleRatingView = _googleRatingView;
@synthesize foursquareCheckinsLabel = _foursquareCheckinsLabel;

@synthesize yelpReviewProvider=_yelpReviewProvider; 
@synthesize googleReviewProvider=_googleReviewProvider; 
@synthesize foursquareReviewProvider=_foursquareReviewProvider; 
@synthesize foursquareTipsLabel = _foursquareTipsLabel;


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
        
        self.yelpReviewProvider = [[[YelpReviewProvider alloc] init] autorelease]; 
        self.googleReviewProvider = [[[GoogleReviewProvider alloc] init] autorelease]; 
        self.foursquareReviewProvider = [[[FoursquareReviewProvider alloc] init] autorelease]; 
        
        
        [self.yelpReviewProvider fetchReviewsForRestaurant:r observer:self]; 
        [self.googleReviewProvider fetchReviewsForRestaurant:r observer:self]; 
        [self.foursquareReviewProvider fetchReviewsForRestaurant:r observer:self]; 
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
    
    self.googleTableViewCell.alpha = 0.00001; 
    self.googleRatingView.editable = NO; 
    self.googleRatingView.backgroundColor = [UIColor clearColor]; 
    self.googleRatingView.opaque = NO; 
    
}

- (void)viewDidUnload
{
    self.yelpReviewProvider = nil; 
    self.googleReviewProvider = nil; 
    self.foursquareReviewProvider = nil; 
    
    [self setTableView:nil];
    [self setGoogleTableViewCell:nil];
    [self setYelpTableViewCell:nil];
    [self setYelpNumberOfReviewsLabel:nil];
    [self setGoogleNumberOfReviewsLabel:nil];
    [self setYelpRatingImageView:nil];
    [self setYelpNumberOfReviewsLabel:nil];
    [self setGoogleNumberOfReviewsLabel:nil];
    [self setGoogleRatingView:nil];
    [self setFoursquareTipsLabel:nil];
    [self setFoursquareCheckinsLabel:nil];
    [self setFoursquareTableViewCell:nil];
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
//    self.yelpReviewProvider = nil; 
//    self.googleReviewProvider = nil; 
    
    [_tableView release];
    [_googleTableViewCell release];
    [_yelpTableViewCell release];
    [_yelpNumberOfReviewsLabel release];
    [_googleNumberOfReviewsLabel release];
    [_yelpRatingImageView release];
    [_yelpNumberOfReviewsLabel release];
    [_googleNumberOfReviewsLabel release];
    [_googleRatingView release];
    [_foursquareTipsLabel release];
    [_foursquareCheckinsLabel release];
    [_foursquareTableViewCell release];
    [super dealloc];
}



#pragma mark - table view delegates 

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0 ) 
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
    
    
    switch (indexPath.row) {
        case 0:                     //google cell
            return self.googleTableViewCell; 
            break;
        case 1:                     //yelp cell
            return self.yelpTableViewCell; 
        case 2:                     //foursquare cell
            return self.foursquareTableViewCell; 
        default:
            return nil; 
    }
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"More Info"; 
        case 1:
            return @"Reviews"; 
        default:
            return @""; 
            break;
    }
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 44; 
        case 1:
            return 80; 
            
        default:
            return 44; 
    }
    
    
}

-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    switch (section) {
        case 0:
            return 2; 
        case 1:
            return 3;
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
    if (indexPath.section == 0)
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


#pragma mark- Restaurant review delegate methods 

-(void) reviewer:(RestaurantReviewProvider *)provider forRestaurant:(Restaurant *)restaurant reviewDidFinish:(RestaurantReview *)review
{
    if ([provider isKindOfClass:[YelpReviewProvider class]])        //a yelp review
    {
        self.yelpNumberOfReviewsLabel.text = [NSString stringWithFormat:@"%d", review.numberOfReviews]; 
        
        NSData* idata = [NSData dataWithContentsOfURL:[NSURL URLWithString:review.ratingImageURL]]; 
        UIImage* img = [UIImage imageWithData:idata]; 
        self.yelpRatingImageView.image = img; 
        
        self.yelpTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark; 
        
    }else if ([provider isKindOfClass:[GoogleReviewProvider class]])    //a google review
    {
        self.googleRatingView.alpha = 1.0; 
        self.googleRatingView.rate = review.rating;
        
        self.googleTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark; 
    }else if ([provider isKindOfClass:[FoursquareReviewProvider class]])
    {
        self.foursquareCheckinsLabel.text = [NSString stringWithFormat:@"%d", (int)review.numberOfReviews]; 
        self.foursquareTipsLabel.text =     [NSString stringWithFormat:@"%d", (int)review.rating]; 

        self.foursquareTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark; 
    }
    
}



-(void) reviewer:(RestaurantReviewProvider *)provider forRestaurant:(Restaurant *)restaurant reviewDidFailWithError:(NSError *)err
{
    if ([provider isKindOfClass:[YelpReviewProvider class]])        //a yelp review
    {
        self.yelpTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark; 
        
    }else if ([provider isKindOfClass:[GoogleReviewProvider class]]) //a google review
    {
        self.googleTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark; 
    }else if ([provider isKindOfClass:[FoursquareReviewProvider class]])
    {
        self.foursquareTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark; 
    }
    

    
}


@end
