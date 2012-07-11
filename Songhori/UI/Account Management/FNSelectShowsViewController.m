//
//  FNSelectShowsViewController.m
//  Songhori
//
//  Created by Ali Nouri on 1/10/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import "FNSelectShowsViewController.h"

@interface FNSelectShowsViewController ()

@end

@implementation FNSelectShowsViewController
@synthesize tableView;
@synthesize account; 


-(id) initWithAccount:(FNAccount *)acc
{
    self = [super initWithNibName:@"FNSelectShowsViewController" bundle:[NSBundle mainBundle]]; 
    if (self) 
    {
        self.account = acc; 
    }
    
    return self; 
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return nil; //not the designated initializer 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"Food Network"; 
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    
    self.account = nil; 
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    self.account = nil; 
    [tableView release];
    [super dealloc];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.account.shows.count; 
}

- (UITableViewCell *)tableView:(UITableView *)tableViewLocal cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)   //this is the account section 
    {
     
        UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""] autorelease]; 
        FoodNetworkShow* show = (FoodNetworkShow*)  [self.account.shows objectAtIndex:indexPath.row]; 

        cell.textLabel.text =  show.name; 
        
        if (show.active)
            cell.accessoryType = UITableViewCellAccessoryCheckmark; 
        else {
            cell.accessoryType = UITableViewCellAccessoryNone; 
        }
        return cell; 
    }
    
    return nil; 
}

-(void) tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FoodNetworkShow* show = (FoodNetworkShow*)  [self.account.shows objectAtIndex:indexPath.row]; 

    show.active = ! show.active; 
    
    UITableViewCell* cell = [tv cellForRowAtIndexPath:indexPath]; 
    
    if (show.active)
        cell.accessoryType = UITableViewCellAccessoryCheckmark; 
    else {
        cell.accessoryType = UITableViewCellAccessoryNone; 
    }
    
    [tv deselectRowAtIndexPath:indexPath animated:NO]; 
}



#pragma mark - Table view delegate


-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Please select the shows"; 
        default:
            break;
    }
    
    return @""; 
}





@end
