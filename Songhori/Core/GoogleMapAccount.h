//
//  GoogleMapAccount.h
//  Songhori
//
//  Created by Ali Nouri on 1/2/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import "Account.h"
#import "GoogleMapList.h"
#import "GoogleMapRestaurant.h"


// This represents one google map list. if we have multiple, we need multiple obj of this 
@interface GoogleMapAccount : Account
{
    NSManagedObjectContext* context; 
    NSManagedObjectModel* model; 
   
    GoogleMapList* _list;                 //this is array of GoogleMapLists
}


-(id) initWithGoogleMapList:(GoogleMapList*) l; 

@property (nonatomic) BOOL active; 
@property (nonatomic, retain) GoogleMapList* list; 
@end
