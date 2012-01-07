//
//  AccountsUIViewController.h
//  photoReX
//
//  Created by Ali Nouri on 11/12/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountsUIViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableDictionary* accountCells; //this is a dictionary from indexPath to AccountTableViewCell necessary to compute the row height
    
    IBOutlet UITableView *tableView;
    
    UIBarButtonItem * _closeBtn; 
}

-(void) closePage:(id) sender; 

- (IBAction)addAccount:(id)sender;

@property (nonatomic, retain) UIBarButtonItem* closeBtn; 
@end
