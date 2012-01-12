//
//  RLWebserviceClient.m
//  rlimage
//
//  Created by Ali Nouri on 7/30/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "YelpRestaurantDataProvider.h"
#import "YelpRestaurant.h"
#import "YelpCheckin.h"
#import "AccountManager.h"

@implementation YelpRestaurantDataProvider

@synthesize requestCheckin=_requestCheckin;
@synthesize delegate=_delegate; 
@synthesize userData=_userData; 
@synthesize outstandingDownloads=_outstandingRestaurantDownloads; 


- (id)initWithUserid:(NSString*) u
{
    self = [super init];
    if (self) {
        _outstandingRestaurantDownloads = 0;        //indicates inactivity
        
        
        model = [AccountManager standardAccountManager].coreModel; 
        context = [AccountManager standardAccountManager].coreContext; 
        
        
        NSFetchRequest* fetchRequest = [[[NSFetchRequest alloc] init] autorelease]; 
        NSEntityDescription* e = [[model entitiesByName] objectForKey:@"YelpUser"]; 
        fetchRequest.entity = e; 
        
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"username=%@", u]; 
        
        NSArray* arr = [context executeFetchRequest:fetchRequest error:nil];
        
        if (! arr) //error reading file
        {
            self.userData = [self createYelpUserWithUsername:u]; 
        }else if (arr.count ==0)    //no such user on database, create it
            self.userData = [self createYelpUserWithUsername:u]; 
        else        //successfully fetched 
            self.userData = [arr objectAtIndex:0]; 
    }
    
    return self;
}


-(BOOL) syncData
{
    BOOL result=NO; 
    //only resync if we haven't already today 
    NSTimeInterval diff = [NSDate timeIntervalSinceReferenceDate] - self.userData.lastSyncDate; 
    //TODO: remove the comment
    if (diff > 86400)       //it's been more than one day 
    {
        [self incrementActivity]; 
        [self loadCheckins:1]; 
        result = YES; 
    }
    
    //
    for (YelpRestaurant* r in self.userData.checkins) {
        if (! [ r isDetailDataAvailable] && ![r hasError])
        {
            result = YES; 
            [self incrementActivity]; 
            r.delegate = self; 
            [r loadDetailsFromWebsite]; 
        }
    }
    
    return result; 
}


-(void) save
{
    if ([context hasChanges])
        [context save:nil]; 
}


-(void) incrementActivity
{
    self.outstandingDownloads++; 
}

-(void) decrementActivity
{
    self.outstandingDownloads = MAX(0, self.outstandingDownloads  -1); 
    
    if (self.outstandingDownloads==0)
    {
        if ([context hasChanges])
            [context save:nil]; 
        
        
        if ([self.delegate respondsToSelector:@selector(syncFinished:)])
            [self.delegate syncFinished:self]; 
    }
    
}


//this should be rewritten in future if yelp api allows it. 
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
    
   
    NSLog(@"Loading yelp checkin page %d\n", pageNumber); 
    
    
    self.requestCheckin = [[[NSMutableURLRequest alloc] initWithURL:[self urlForPage:pageNumber] cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeoutInterval:60] autorelease]; 
    
    //set parameters of the request except for the body: 
    [self.requestCheckin setHTTPMethod:@"GET"]; 
    

    [NSURLConnection sendAsynchronousRequest:self.requestCheckin queue:[NSOperationQueue mainQueue] completionHandler:
    ^(NSURLResponse* response, NSData* data, NSError* error)
     {
         if (response == nil)       //error happened
         {
             [self decrementActivity]; 
             NSLog(@"Error downloading checkins from yelp: %@\n", [error description]); 
         } else         //success
         {
             
             //NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; 
             //NSLog(@"received %@\n", str);
             
             
             SBJsonParser* parser = [[SBJsonParser alloc] init]; 
             parser.maxDepth = 9; 
             
             
             NSDictionary* d1 = [parser objectWithData:data]; 
             if (d1 == nil) { NSLog(@"the data from webservice was not formatted correctly"); [parser release]; [self decrementActivity]; return;}
             
             
             NSArray* items = [d1 objectForKey:@"check_ins"]; 

             BOOL nextPageFlag= YES;        //should we automatically load the next page as well? 
             
             if (items.count < 20 || pageNumber>=8)
                 nextPageFlag = NO; 
             
             for (id item in items) 
             {
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
                 [self createCheckinWithJsonData:item]; 
             }
             
             if (nextPageFlag)
                 [self loadCheckins:pageNumber+1]; 
             else
             {
                 //this was the last page to load. let's recalculate the lastcheckin date variable 
                 [self.userData recalculateLastCheckin]; 
                 
                 self.userData.lastSyncDate = [[NSDate date] timeIntervalSinceReferenceDate];  
                 
                 [self decrementActivity]; 
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


-(YelpRestaurant*) createYelpRestaurantWithID:(NSString*) y_id
{
    YelpRestaurant* result = [NSEntityDescription insertNewObjectForEntityForName:@"YelpRestaurant" inManagedObjectContext:context]; 
    
    result.y_id = y_id; 
    result.delegate = self; 
    
    return result; 
}



-(YelpUser*) createYelpUserWithUsername:(NSString *)username
{
    YelpUser* result = [NSEntityDescription insertNewObjectForEntityForName:@"YelpUser" inManagedObjectContext:context]; 
    
    result.username = username; 
    result.lastCheckinDate = 0; 
    result.lastSyncDate = 0;            //never synced 
    result.active = YES; 
    
    return result; 
}


-(YelpCheckin*) createCheckinWithJsonData:(id)json
{
    YelpCheckin* checkin = [NSEntityDescription insertNewObjectForEntityForName:@"YelpCheckin" inManagedObjectContext:context]; 
    
    
    checkin.visitDate = [[json objectForKey:@"time_created"] doubleValue]-NSTimeIntervalSince1970; 
    checkin.y_id      = [json objectForKey:@"business_id"]; 
    checkin.jsonData  = [json description]; 
    
    
    //look for corresponding restaurant: 
    NSString * cond = [NSString stringWithFormat:@"y_id='%@'", checkin.y_id]; 
    NSPredicate* predicate = [NSPredicate predicateWithFormat:cond]; 
    NSSet* filtered = [self.userData.checkins filteredSetUsingPredicate:predicate]; 
    
    YelpRestaurant* result=nil; 
    if (filtered.count > 0) //already exist
    {
        result = [filtered anyObject];
    }else 
    {
        //create restaurant object 
        result = [self createYelpRestaurantWithID:checkin.y_id]; 
        [self.userData addCheckinsObject:result]; 
        //TODO: download other stuff 
        
        [self incrementActivity]; 
        result.delegate = self; 
        [result loadDetailsFromWebsite]; 
    }
    
    [result addCheckin:checkin]; 
    result.checkinCount++; 

    return checkin; 
}



-(void) sendRestaurantsInRegion:(MKCoordinateRegion)region
{
    NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:self.userData.checkins.count]; 
    
    //only retrieve the ones that fall in the region
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"latitude>%lf AND latitude<%lf AND longitude>%lf AND longitude < %lf", region.center.latitude-region.span.latitudeDelta/2.0, region.center.latitude+region.span.latitudeDelta/2.0, region.center.longitude-region.span.longitudeDelta/2.0, region.center.longitude+region.span.longitudeDelta/2.0]; 
    NSSet* filtered = [self.userData.checkins filteredSetUsingPredicate:predicate]; 
    
    for (YelpRestaurant* r in filtered) 
    {
        if ([r isDetailDataAvailable])
            [result addObject:r]; 
    }
    
    NSArray* result2 = [NSArray arrayWithArray:result]; 
    [result release]; 

    //this is because we respond in blocking fashion because we read from offline database 
    if (self.delegate) 
    {
        [self.delegate restaudantDataDidBecomeAvailable:result2 forRegion:region fromProvider:self]; 
        [self.delegate allDataForRequestSent:self]; 
    }
        
}


-(void) dealloc
{
    [context save:nil]; 
    
    
    self.userData = nil; 
    self.requestCheckin = nil; 
    
    [super dealloc]; 
}


#pragma mark - delegate methods 

//each time we ask a yelp restaurant to load the details of its data form yelp, we increase the counter. 
//here we decrement it because the data is successfully loaded (used to save to db) 
-(void) detailDataDidDownloadForRestaurant:(YelpRestaurant *)restaurant
{
    [self decrementActivity];     
}

@end


