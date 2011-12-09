//
//  RLWebserviceClient.m
//  rlimage
//
//  Created by Ali Nouri on 7/30/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "YelpRestaurantDataProvider.h"
#import "YelpRestaurant.h"

@implementation YelpRestaurantDataProvider

@synthesize requestCheckin=_requestCheckin;
@synthesize delegate=_delegate; 
@synthesize userData=_userData; 

- (id)initWithUserid:(NSString*) u
{
    self = [super init];
    if (self) {

        model = [[NSManagedObjectModel mergedModelFromBundles:nil] retain]; 
        
        NSPersistentStoreCoordinator* prs = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model]; 
        
        
        //get the path to the document
        NSArray* documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentRootPath = [documentPaths objectAtIndex:0];
        
        NSString* path = [NSString stringWithFormat:@"%@/yelp.data", documentRootPath]; 
        NSURL* curl = [NSURL fileURLWithPath:path]; 
        NSError* error = nil; 
        
        if (![prs addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:curl options:nil error:&error])
        {
            [prs release]; 
            return nil; 
        }
        
        context = [[NSManagedObjectContext alloc] init ]; 
        context.persistentStoreCoordinator = prs; 
        [prs release]; 
        context.undoManager = nil; 
        
        
        
        NSFetchRequest* fetchRequest = [[[NSFetchRequest alloc] init] autorelease]; 
        NSEntityDescription* e = [[model entitiesByName] objectForKey:@"YelpUser"]; 
        fetchRequest.entity = e; 
        
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"username=%@", u]; 
        
        NSError* err = nil; 
        NSArray* arr = [context executeFetchRequest:fetchRequest error:&err] ;
        if (! arr) 
        {
            self.userData = [self createYelpUserWithUsername:u]; 
        }else if (arr.count ==0)
            self.userData = [self createYelpUserWithUsername:u]; 
        else
            self.userData = [arr objectAtIndex:0]; 
        
        
        //create the request: only the body part of the request remains to be created on the fly at each call
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, SERVICE_CHECKIN]]; 
        _requestCheckin = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeoutInterval:60]; 
        
        //set parameters of the request except for the body: 
        [self.requestCheckin setHTTPMethod:@"GET"]; 
        [self loadCheckins]; 
    }
    
    return self;
}

-(void) loadCheckins
{
    [NSURLConnection sendAsynchronousRequest:self.requestCheckin queue:[NSOperationQueue mainQueue] completionHandler:
    ^(NSURLResponse* response, NSData* data, NSError* error)
     {
         if (response == nil)       //error happened
         {
             NSLog(@"Error downloading checkins from yelp: %@\n", [error description]); 
         } else         //success
         {
             
             //NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; 
             //NSLog(@"received %@\n", str);
             
             
             SBJsonParser* parser = [[SBJsonParser alloc] init]; 
             
             parser.maxDepth = 9; 
             
             
             NSDictionary* d1 = [parser objectWithData:data]; 
             
             if (d1 == nil) { NSLog(@"the data from webservice was not formatted correctly"); [parser release]; return;}
             
             
             //TODO: do what is necessary to get json data for each restaurant in checkin list
             NSArray* items = [d1 objectForKey:@"me"]; 

             
             for (id item in items) {
                 YelpRestaurant* yr = [self createYelpRestaurantWithJsonData:item]; 
                 [self.userData addCheckinsObject:yr]; 
             }
             
             NSError* err = nil; 
             [context save:&err];
             if (err)
                 NSLog(@"Error saving yelp data to sql: %@\n", err);
             
             //cleanup 
             [parser release];
             
         }// if 
         
     }]; 
     
}


-(YelpRestaurant*) createYelpRestaurantWithJsonData:(id)json
{
    YelpRestaurant* result = [NSEntityDescription insertNewObjectForEntityForName:@"YelpRestaurant" inManagedObjectContext:context]; 
    
    [result loadFromJSON:json]; 
    return result; 
}



-(YelpUser*) createYelpUserWithUsername:(NSString *)username
{
    YelpUser* result = [NSEntityDescription insertNewObjectForEntityForName:@"YelpUser" inManagedObjectContext:context]; 
    
    result.username = username; 
    
    return result; 
}


-(void) sendRestaurantsInRegion:(MKCoordinateRegion)region
{
    NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:self.userData.checkins.count]; 
    
    for (YelpRestaurant* r in self.userData.checkins) 
    {
        //TODO: check if r is in the region 
        [result addObject:r]; 
    }
    
    NSArray* result2 = [NSArray arrayWithArray:result]; 
    [result release]; 

    //this is because we respond in blocking fashion because we read from offline database 
    if (self.delegate) 
        [self.delegate restaudantDataDidBecomeAvailable:result2 forRegion:region fromProvider:self]; 
}





-(void) dealloc
{
    self.userData = nil; 
    [_requestCheckin release]; 
    
    [super dealloc]; 
}

@end


