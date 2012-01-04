//
//  FNAccount.h
//  songhori
//
//  Created by Ali Nouri on 7/2/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"
#import "FNRestaurantDataProvider.h" 

@interface FNAccount: Account
{
    BOOL _active; 
    
    FNRestaurantDataProvider* dataProvider; 
}



@end
