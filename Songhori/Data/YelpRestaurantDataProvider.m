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
        outstandingRestaurantDownloads = -1;        //indicates inactivity
        
        
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
        {
            self.userData = [arr objectAtIndex:0]; 
        }
        
        
        //only resync if we haven't already today 
        NSTimeInterval diff = [NSDate timeIntervalSinceReferenceDate] - self.userData.lastSyncDate; 
        
        if (diff > 86400)       //it's been more than one day 
            [self loadCheckins:7]; 
    }
    
    return self;
}

-(void) detailDataDidDownloadForRestaurant:(YelpRestaurant *)restaurant
{
    outstandingRestaurantDownloads--; 
    
    if (outstandingRestaurantDownloads==0)
        [context save:nil]; 
    
}


-(NSURL*) urlForPage:(int)pageNumber
{
    NSString* str; 
    switch (pageNumber) {
        case 1:
        default:
        str = @"http://api.yelp.com/check_ins?device_type=iPhone%2F5.0.1&efs=68%2F4yS5IBAHy%2BlFRxl0AcB1rfFC7ul9hxM5jXmMca8H8Ne16Uo%2FV6FJPKx5rBesQlRPGoD5%2BIDy4xJWr4u1wUrjR2bsHTW0rOcZ%2FikNPaiO8wg1gQgitzZbNQda7Gg6E&limit=20&time=1323443984&locale=en_US&session_token=GwWiRQjvVQDt5Xjoa9kO0adRZLsySfKQ&ywsid=gpfz_nbS33avFWL0Ozgz3Q&cc=US&lang=en&offset=0&accuracy=0.006214&signature=iB5BHjs7n8dw6NpwdEtETg%3D%3D&app_version=5.4.4";
    break;
            
        case 2:
            str = @"http://api.yelp.com/check_ins?device_type=iPhone%2F5.0.1&efs=68%2F4yS5IBAHy%2BlFRxl0AcCVzCfEV2HSixTmktt%2FYVkrFi%2FmaFRYCn3MOgZrf5LsaFkFrdmCE2%2F3GyqGcYCKqA6pv1cAo0q9KBII5b%2F09ypJ47czyfSOzlhM3jklPx7%2B6&limit=20&time=1323444026&locale=en_US&session_token=GwWiRQjvVQDt5Xjoa9kO0adRZLsySfKQ&ywsid=gpfz_nbS33avFWL0Ozgz3Q&cc=US&lang=en&offset=20&accuracy=0.006214&signature=SBbhws9b4HwgDq0f2RfPbA%3D%3D&app_version=5.4.4";
            break;
        case 3:
            str = @"http://api.yelp.com/check_ins?device_type=iPhone%2F5.0.1&efs=68%2F4yS5IBAHy%2BlFRxl0AcCVzCfEV2HSixTmktt%2FYVkrFi%2FmaFRYCn3MOgZrf5LsaFkFrdmCE2%2F3GyqGcYCKqA6pv1cAo0q9KBII5b%2F09ypJ47czyfSOzlhM3jklPx7%2B6&limit=20&time=1323444066&locale=en_US&session_token=GwWiRQjvVQDt5Xjoa9kO0adRZLsySfKQ&ywsid=gpfz_nbS33avFWL0Ozgz3Q&cc=US&lang=en&offset=40&accuracy=0.003107&signature=GXEeSYBFq0BGRqj9V1SkTg%3D%3D&app_version=5.4.4";
            break;
        case 4:
            str = @"http://api.yelp.com/check_ins?device_type=iPhone%2F5.0.1&efs=68%2F4yS5IBAHy%2BlFRxl0AcAPTMlR7rQTcV4YPyrHjtJJV9qt791IQ1mPpsuOruIrCYmr74ASLzlEJJHrRJQY%2FYhZvszMY2qpXtydJBjc7mc3BFdSl8DjJu8mYjaetU5Xf&limit=20&time=1323450439&locale=en_US&session_token=GwWiRQjvVQDt5Xjoa9kO0adRZLsySfKQ&ywsid=gpfz_nbS33avFWL0Ozgz3Q&cc=US&lang=en&offset=60&accuracy=0.003107&signature=Otg2u%2FsgiF%2BHlXXSY2%2BLEA%3D%3D&app_version=5.4.4";
            break;
        case 5:
            str = @"http://api.yelp.com/check_ins?device_type=iPhone%2F5.0.1&efs=68%2F4yS5IBAHy%2BlFRxl0AcMqItUslgh%2FRy2paHkJVFboks59Al47BBVtgtc3Jn%2BG9p3NRPJBosNOyGh0Dwk49RmzfLKclkVoex1tvPmE6j1YYoYcxOlVtm4lnDhKcnVLm&limit=20&time=1323450483&locale=en_US&session_token=GwWiRQjvVQDt5Xjoa9kO0adRZLsySfKQ&ywsid=gpfz_nbS33avFWL0Ozgz3Q&cc=US&lang=en&offset=80&accuracy=0.006214&signature=UAxTM8ZftQLRmhsHsXzz%2BQ%3D%3D&app_version=5.4.4";
            break;
        case 6:
            str = @"http://api.yelp.com/check_ins?device_type=iPhone%2F5.0.1&efs=68%2F4yS5IBAHy%2BlFRxl0AcDH3QzrKTDp1TCh3ByObieOCA9adhAF96hm%2Bi6%2Flc%2F0E7FnvRXM3br7gdBF5tyvaH6ma%2Bk46ylze3ctOkETrUNSfiQj9HHIvOU8LKAZH0SAC&limit=20&time=1323450517&locale=en_US&session_token=GwWiRQjvVQDt5Xjoa9kO0adRZLsySfKQ&ywsid=gpfz_nbS33avFWL0Ozgz3Q&cc=US&lang=en&offset=100&accuracy=0.003107&signature=%2FsyzzN0VJj7%2B0nHCnHuayQ%3D%3D&app_version=5.4.4";
            break;
        case 7:
            str = @"http://api.yelp.com/check_ins?device_type=iPhone%2F5.0.1&efs=68%2F4yS5IBAHy%2BlFRxl0AcMn8Umtew4lTtK3H585yb6bWVSxK81HNYH01Pbrt1OtHmFxHbL90hShadR4X0A57paIuMVSz0O1UqW5dg5b57s3gPb%2F8wcSX3P%2Bgc1R6DAHR&limit=20&time=1323450548&locale=en_US&session_token=GwWiRQjvVQDt5Xjoa9kO0adRZLsySfKQ&ywsid=gpfz_nbS33avFWL0Ozgz3Q&cc=US&lang=en&offset=120&accuracy=0.003107&signature=zRRgiLtrMb%2BUADw8C%2FLSQw%3D%3D&app_version=5.4.4";
            break;
        case 8:
            str = @"http://api.yelp.com/check_ins?device_type=iPhone%2F5.0.1&efs=68%2F4yS5IBAHy%2BlFRxl0AcHOx1uxLBF0LGbeg%2BYEKjT9f%2BD3UM1HWuM6QHJfJJuGkrjv4XMkXWv7XIahbt4096LSXhbugXprSohksBucjF6eUKXs674WgLP2G4Ch%2Bkpkk&limit=20&time=1323450579&locale=en_US&session_token=GwWiRQjvVQDt5Xjoa9kO0adRZLsySfKQ&ywsid=gpfz_nbS33avFWL0Ozgz3Q&cc=US&lang=en&offset=140&accuracy=0.003107&signature=%2FkGjOvXFMG0vzPKVVfXkIA%3D%3D&app_version=5.4.4";
            break;
    }

    return [NSURL URLWithString:str]; 
}

-(void) loadCheckins:(int) pageNumber 
{
    if (pageNumber>8)
        return; //TODO: 
    
    
    self.requestCheckin = [[[NSMutableURLRequest alloc] initWithURL:[self urlForPage:pageNumber] cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeoutInterval:60] autorelease]; 
    
    //set parameters of the request except for the body: 
    [self.requestCheckin setHTTPMethod:@"GET"]; 
    
    
    
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
             
             
             NSArray* items = [d1 objectForKey:@"check_ins"]; 

             BOOL nextPageFlag= YES;        //should we automatically load the next page as well? 
             
             if (items.count < 20)
                 nextPageFlag = NO; 
             
             for (id item in items) {
                 
                 //extract the date of this item
                 id t =  [item objectForKey:@"time_created"];
                 NSTimeInterval time = [t doubleValue]-NSTimeIntervalSince1970; 

                 
                 //check whether we already have this by using the date 
                 if (self.userData.lastCheckinDate >= time) 
                 {
                     nextPageFlag = NO; 
                     break; 
                 }
                 
                 //we don't have this item, lets create it and link the wires 
                 YelpRestaurant* yr = [self createYelpRestaurantWithJsonData:item]; 
                 [yr loadDetailsFromWebsite]; 
                 outstandingRestaurantDownloads = MAX(outstandingRestaurantDownloads+1, 1); 
                 [self.userData addCheckinsObject:yr];
             }
             
             if (nextPageFlag)
                 [self loadCheckins:pageNumber+1]; 
             else
             {
                 //this was the last page to load. let's recalculate the lastcheckin date variable 
                 [self.userData recalculateLastCheckin]; 
                 
                 self.userData.lastSyncDate = [[NSDate date] timeIntervalSinceReferenceDate];  
                 
                 NSError* err = nil; 
                 [context save:&err];
                 if (err)
                     NSLog(@"Error saving yelp data to sql: %@\n", err);
             }
            
              //cleanup 
             [parser release];
             
         }// if 
         
     }]; 
     
}


-(YelpRestaurant*) createYelpRestaurantWithJsonData:(id)json
{
    YelpRestaurant* result = [NSEntityDescription insertNewObjectForEntityForName:@"YelpRestaurant" inManagedObjectContext:context]; 
    
    [result loadFromJSON:json]; 
    result.delegate = self; 
    
    return result; 
}



-(YelpUser*) createYelpUserWithUsername:(NSString *)username
{
    YelpUser* result = [NSEntityDescription insertNewObjectForEntityForName:@"YelpUser" inManagedObjectContext:context]; 
    
    result.username = username; 
    result.lastCheckinDate = 0; 
    result.lastSyncDate = 0;            //never synced 
    
    return result; 
}


-(void) sendRestaurantsInRegion:(MKCoordinateRegion)region
{
    NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:self.userData.checkins.count]; 
    
    for (YelpRestaurant* r in self.userData.checkins) 
    {
        //TODO: check if r is in the region 
        if ([r isDetailDataAvailable])
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
    [context save:nil]; 
    
    
    self.userData = nil; 
    self.requestCheckin = nil; 
    
    [super dealloc]; 
}

@end


