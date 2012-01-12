//
//  FNSelectShowsViewController.h
//  Songhori
//
//  Created by Ali Nouri on 1/10/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNAccount.h" 

@interface FNSelectShowsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    FNAccount* _account; 
}

-(id) initWithAccount:(FNAccount*) acc; 


@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) FNAccount* account; 
@end
