//
//  AccountsUIViewController.m
//  photoReX
//
//  Created by Ali Nouri on 11/12/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "AccountsUIViewController.h"
#import "AccountManager.h"
#import "AccountTableViewCell.h"
#import "GoogleMapAccount.h"
#import "NewAccountViewControllerViewController.h"

@implementation AccountsUIViewController
@synthesize closeBtn=_closeBtn; 

-(UIBarButtonItem*) closeBtn
{
    
    if (!_closeBtn)
    {
        _closeBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closePage:)]; 
    }
    
    return _closeBtn; 
}


-(void) closePage:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES]; 
}

- (IBAction)addAccount:(id)sender 
{
    NewAccountViewControllerViewController* ncv = [[NewAccountViewControllerViewController alloc] initWithSourceURL:@"http://maps.google.com/maps/ms?authuser=0&vps=3&ie=UTF8&msa=0&output=kml&msid=211222265741387435446.000455b6b5ca8e9986c8b"]; 

    [self presentModalViewController:ncv animated:YES]; 


//    GoogleMapAccount* ga = [[GoogleMapAccount alloc] initWithURL:@"http://maps.google.com/maps/ms?authuser=0&vps=3&ie=UTF8&msa=0&output=kml&msid=211222265741387435446.000455b6b5ca8e9986c8b"]; 
//    ga.delegate = self; 


//    [[AccountManager standardAccountManager] addAccount:ga]; 
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    [super viewWillAppear:animated]; 
    
    [self.navigationController setNavigationBarHidden:NO]; 
    self.navigationItem.title = @"Settings"; 
    self.navigationItem.rightBarButtonItem = self.closeBtn; 
    [self.navigationItem setHidesBackButton:YES]; 
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault; 
}

- (void)viewDidLoad
{
    accountCells = [[NSMutableDictionary alloc] initWithCapacity:5]; 
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
}

- (void)viewDidUnload
{
    [_closeBtn release]; 
    [tableView release];
    tableView = nil;
    [super viewDidUnload];
    
    [accountCells release]; 
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma -mark TableView delegate functions 

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section ) {
        case 0:
            return [AccountManager standardAccountManager].NUMBER_OF_ACCOUNTS+1; 
            break;
        case 1:         //ui section 
            return 0; 
        default:
            return 0; 
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableViewLocal cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)   //this is the account section 
    {
        
        if (indexPath.row < [AccountManager standardAccountManager].NUMBER_OF_ACCOUNTS)
        {
            static NSString *CellIdentifier = @"Cell";
            Account* account = [[AccountManager standardAccountManager] getAccountAtIndex:indexPath.row]; 
            CGRect frame = CGRectMake(0, 0, 320, 60); 
            
            AccountTableViewCell *cell = (AccountTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[AccountTableViewCell alloc] initWithFrame:frame andAccount:account andTableController:self] autorelease]; 
            }
            
            // Configure the cell...
            cell.theAccount = account; 
            
            // add the cell to the account cell dictionary 
            [accountCells setValue:cell forKey:[NSString stringWithFormat:@"%d", indexPath.row]]; 
            
            return cell;
            
        } else              //a cell for adding an account
        {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"add others"]; 
            if (cell == nil) 
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"add others"]; 
            
            cell.textLabel.text = @"Add Others"; 
            
            return cell; 
            
        }
        
    } else if (indexPath.section==1) //this is the UI config section 
    {
        return nil; 
    }
    
    
    return nil; 
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0 && indexPath.row == [AccountManager standardAccountManager].NUMBER_OF_ACCOUNTS)
    {
        NewAccountViewControllerViewController* na = [[NewAccountViewControllerViewController alloc] init]; 
        [self presentModalViewController:na animated:YES]; 
        [na release]; 
    }
}


-(void) tableView:(UITableView *)tv willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AccountTableViewCell* cell = (AccountTableViewCell*) [tv cellForRowAtIndexPath:indexPath]; 
    
    [cell.deactivateSwitch setHidden:YES]; 
    
}


-(void) tableView:(UITableView *)tv didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountTableViewCell* cell = (AccountTableViewCell*) [tv cellForRowAtIndexPath:indexPath]; 
    
    [cell.deactivateSwitch setHidden:NO]; 
}


 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
     AccountManager* am = [AccountManager standardAccountManager]; 
     
     if (indexPath.section==0 &&  indexPath.row < am.NUMBER_OF_ACCOUNTS)
         return [[[AccountManager standardAccountManager].accounts objectAtIndex:indexPath.row] isDeletable]; 
     else 
         return NO; 
 }



 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
     [[AccountManager standardAccountManager] deleteAccountAtIndex:indexPath.row]; 
     [tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate



-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Restaurant Sources"; 
        case 1:
            return @"User Interface"; 
            
        default:
            break;
    }

    return @""; 
}



- (void)dealloc {
    [tableView release];
    [super dealloc];
}
@end
