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
@interface GoogleMapAccount : DynamicAccount
{
    NSManagedObjectContext* context; 
    NSManagedObjectModel* model; 
   
    GoogleMapList* _list;                 //this is array of GoogleMapLists
    
 
    //ivars for downloading data 
    NSMutableURLRequest* _request; 
    NSMutableData* _incomingData; 
    NSURLConnection* _urlConnection; 
    
}

-(id) initWithGoogleMapList:(GoogleMapList*) l; 

-(id) initWithURL:(NSString*) url;                     //this one creates an account from the specified url

@property (nonatomic) BOOL active; 
@property (nonatomic, retain) GoogleMapList* list; 

@property (nonatomic, retain) NSURLConnection* urlConnection; 
@property (nonatomic, retain) NSMutableData* incomingData; 
@property (nonatomic, retain) NSMutableURLRequest* request; 


@end
