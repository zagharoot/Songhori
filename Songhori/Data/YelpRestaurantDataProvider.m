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
        result = YES; 
        [self syncDataForced]; 
    }
    
    return result; 
}


-(void) syncDataForced
{
    [self incrementActivity]; 
    [self loadCheckins:1]; 
    
    
    //
    for (YelpRestaurant* r in self.userData.checkins) {
        if (! [ r isDetailDataAvailable] && ![r hasError])
        {
            [self incrementActivity]; 
            r.delegate = self; 
            [r loadDetailsFromWebsite]; 
        }
    }
    
    
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
        str = @"http://auto-api.yelp.com/check_ins?device_type=iPhone3%2C1%2F5.1.1&efs=mLHUVjDwk2Pm30ESRWYYR2Nqy38Y5Bkcht%2B5iB8oLjNUx4Mgy7ZopjxH%2FWSjWFdWXNK6gc%2FGiHTJ4W5pjrGHRwov3I8fVKA4%2FP1XL16qfIU6Jvc1gJC9R79%2FC61ClgCydnAa8pM8XWzHVzAaauDTTngocccngSBFtSTGba%2BpHSxvVrZmiLpSENv3eFOTon%2Fq&time=1342384683&ydid_time_created=1339876900&limit=20&locale=en_US&session_token=f5oziPczcO7E7rpB5P_Ui2NfgRh64J1g&ywsid=gpfz_nbS33avFWL0Ozgz3Q&summary=1&accuracy=0.003107&cc=US&offset=0&lang=en&signature=6aTsLZS5FVy35kavUHFm7g%3D%3D&app_version=5.9.1"; 
            break;
            
        case 2:
            str = @"http://auto-api.yelp.com/check_ins?device_type=iPhone3%2C1%2F5.1.1&efs=mLHUVjDwk2Pm30ESRWYYR2Nqy38Y5Bkcht%2B5iB8oLjNUx4Mgy7ZopjxH%2FWSjWFdWXNK6gc%2FGiHTJ4W5pjrGHR3%2BkTeF%2FGS%2BIumARg4n%2BZqbrnR76%2BSJio%2B1w0hjVGdmEDDsuIKTMulqYa3XbMtD%2ByoGScthq3js7MiUG%2FJJfd5GQF%2F2LkQWRz24dUE5gXTNc&ydid_time_created=1339876900&limit=20&time=1342385003&locale=en_US&session_token=f5oziPczcO7E7rpB5P_Ui2NfgRh64J1g&ywsid=gpfz_nbS33avFWL0Ozgz3Q&cc=US&accuracy=0.006214&offset=20&lang=en&signature=D9HEcKf2nGdsRIqGxP%2BSIw%3D%3D&app_version=5.9.1"; 
            break;
        case 3:
            str = @"http://auto-api.yelp.com/check_ins?device_type=iPhone3%2C1%2F5.1.1&efs=mLHUVjDwk2Pm30ESRWYYR2Nqy38Y5Bkcht%2B5iB8oLjNUx4Mgy7ZopjxH%2FWSjWFdWXNK6gc%2FGiHTJ4W5pjrGHR1zR4fpDZE1dIwZaj%2F7uHeV9Sr4gX%2F5o0SWSa4TcymGHM0yMD3Q%2BsuuqA2oTHldJYEYSYPz3Y%2FwIsxtFZQ6%2B0UP0iI33ysWBLTPayGoy2ibt&ydid_time_created=1339876900&limit=20&time=1342385108&locale=en_US&session_token=f5oziPczcO7E7rpB5P_Ui2NfgRh64J1g&ywsid=gpfz_nbS33avFWL0Ozgz3Q&cc=US&accuracy=0.003107&offset=40&lang=en&signature=4j5oQ1ld9C9m2XgpgR82Kg%3D%3D&app_version=5.9.1"; 
            break;
        case 4:
            str = @"http://auto-api.yelp.com/check_ins?device_type=iPhone3%2C1%2F5.1.1&efs=mLHUVjDwk2Pm30ESRWYYR2Nqy38Y5Bkcht%2B5iB8oLjNUx4Mgy7ZopjxH%2FWSjWFdWXNK6gc%2FGiHTJ4W5pjrGHRynHpaKqsWfH62g%2B51N1c3ugluXZqRDcjteLyzBF0%2BtlnvrDitogqzqEBJO3neQ6psJL635rxnppM1QkoTZb5mKLrWo3J3uc2G5zr2sgxb40&ydid_time_created=1339876900&limit=20&time=1342385164&locale=en_US&session_token=f5oziPczcO7E7rpB5P_Ui2NfgRh64J1g&ywsid=gpfz_nbS33avFWL0Ozgz3Q&cc=US&accuracy=0.003107&offset=60&lang=en&signature=JlrHi7IOo%2F%2BUo4mVtHuq8w%3D%3D&app_version=5.9.1"; 
            break;
        case 5:
            str = @"http://auto-api.yelp.com/check_ins?device_type=iPhone3%2C1%2F5.1.1&efs=mLHUVjDwk2Pm30ESRWYYR2Nqy38Y5Bkcht%2B5iB8oLjNUx4Mgy7ZopjxH%2FWSjWFdWXNK6gc%2FGiHTJ4W5pjrGHR3Mz5EgMoG0RvG3sWyy1hLSsn54SxpjFUnW8meDb7%2FBtxyFvwemXlXOcgqTjNJXMgGjJiz44s91E7A30Va8CuLy9VDX%2BV4SOTmILFXp7mH9H&ydid_time_created=1339876900&limit=20&time=1342385204&locale=en_US&session_token=f5oziPczcO7E7rpB5P_Ui2NfgRh64J1g&ywsid=gpfz_nbS33avFWL0Ozgz3Q&cc=US&accuracy=0.003107&offset=80&lang=en&signature=7x6QNwI6Pzk5Ng5V8sItZg%3D%3D&app_version=5.9.1"; 
            break;
        case 6:
            str = @"http://auto-api.yelp.com/check_ins?device_type=iPhone3%2C1%2F5.1.1&efs=mLHUVjDwk2Pm30ESRWYYR2Nqy38Y5Bkcht%2B5iB8oLjNUx4Mgy7ZopjxH%2FWSjWFdWXNK6gc%2FGiHTJ4W5pjrGHR%2BphyEOELj4zqszzbaLKG2A2sknDWFMMB7sX4osAncWyRWNGYHGNCNW9a7BR4jRDOMRhLvjMd66vtvrdo8Trt0eBVZtuLGw4OhpiIOnmOEjA&ydid_time_created=1339876900&limit=20&time=1342385240&locale=en_US&session_token=f5oziPczcO7E7rpB5P_Ui2NfgRh64J1g&ywsid=gpfz_nbS33avFWL0Ozgz3Q&cc=US&accuracy=0.006214&offset=100&lang=en&signature=y0eJ4BH7F1MdlDoc58M1yA%3D%3D&app_version=5.9.1"; 
            break;
        case 7:
            str = @"http://auto-api.yelp.com/check_ins?device_type=iPhone3%2C1%2F5.1.1&efs=mLHUVjDwk2Pm30ESRWYYR2Nqy38Y5Bkcht%2B5iB8oLjNUx4Mgy7ZopjxH%2FWSjWFdWXNK6gc%2FGiHTJ4W5pjrGHR5oVAtskF23aYM2oCyb5h9uWtD6D2NYbPrSxjPe5cMDtgDPJT7hUfzBelwT%2Bd0JlxFP%2FNKrK2OOal0fEyOfa1sDJCKz1meWQam%2BJKbefkAkN&ydid_time_created=1339876900&limit=20&time=1342385276&locale=en_US&session_token=f5oziPczcO7E7rpB5P_Ui2NfgRh64J1g&ywsid=gpfz_nbS33avFWL0Ozgz3Q&cc=US&accuracy=0.006214&offset=120&lang=en&signature=zVvWk67Dy1J5B4YYu5iGAA%3D%3D&app_version=5.9.1"; 
            break;
        case 8:
            str = @"http://auto-api.yelp.com/check_ins?device_type=iPhone3%2C1%2F5.1.1&efs=mLHUVjDwk2Pm30ESRWYYR2Nqy38Y5Bkcht%2B5iB8oLjNUx4Mgy7ZopjxH%2FWSjWFdWXNK6gc%2FGiHTJ4W5pjrGHR5oVAtskF23aYM2oCyb5h9uWtD6D2NYbPrSxjPe5cMDtgDPJT7hUfzBelwT%2Bd0JlxFP%2FNKrK2OOal0fEyOfa1sDJCKz1meWQam%2BJKbefkAkN&ydid_time_created=1339876900&limit=20&time=1342385335&locale=en_US&session_token=f5oziPczcO7E7rpB5P_Ui2NfgRh64J1g&ywsid=gpfz_nbS33avFWL0Ozgz3Q&cc=US&accuracy=0.006214&offset=140&lang=en&signature=mtQztKkzVhlZHSixCBuBPA%3D%3D&app_version=5.9.1"; 
            break;
        case 9:
            str = @"http://auto-api.yelp.com/check_ins?device_type=iPhone3%2C1%2F5.1.1&efs=mLHUVjDwk2Pm30ESRWYYR2Nqy38Y5Bkcht%2B5iB8oLjNUx4Mgy7ZopjxH%2FWSjWFdWXNK6gc%2FGiHTJ4W5pjrGHR3vkDX15jUuyniMit8krtR3F04pxDadh%2B9vKpZ%2BcJAbHH3mRxfYylkOOOjM21rBBhBkdJWljolGs2avnl6Ku6TISOD%2BtM2EuFDyXgn67VDQ%2F&ydid_time_created=1339876900&limit=20&time=1342385387&locale=en_US&session_token=f5oziPczcO7E7rpB5P_Ui2NfgRh64J1g&ywsid=gpfz_nbS33avFWL0Ozgz3Q&cc=US&accuracy=0.006214&offset=160&lang=en&signature=Si%2FFkuMXvABhFI1VuYc6Yg%3D%3D&app_version=5.9.1"; 
            break;
        case 10:
            str = @"http://auto-api.yelp.com/check_ins?device_type=iPhone3%2C1%2F5.1.1&efs=mLHUVjDwk2Pm30ESRWYYR2Nqy38Y5Bkcht%2B5iB8oLjNUx4Mgy7ZopjxH%2FWSjWFdWXNK6gc%2FGiHTJ4W5pjrGHR0qzdcoXLfZXR5gw88hxXUXBpW2QKr8O9MoQpPZScjZrOc4qMet8xa2ZFMmrB0Yosoybg4FNYl4LnakV66Yn2vIjXG44u32LfDL2LWRCgndP&ydid_time_created=1339876900&limit=20&time=1342385420&locale=en_US&session_token=f5oziPczcO7E7rpB5P_Ui2NfgRh64J1g&ywsid=gpfz_nbS33avFWL0Ozgz3Q&cc=US&accuracy=0.006214&offset=180&lang=en&signature=vVMzj08%2BDdL5%2B0MjHwYAXg%3D%3D&app_version=5.9.1"; 
            break;
        case 11:
            str = @"http://auto-api.yelp.com/check_ins?device_type=iPhone3%2C1%2F5.1.1&efs=mLHUVjDwk2Pm30ESRWYYR2Nqy38Y5Bkcht%2B5iB8oLjNUx4Mgy7ZopjxH%2FWSjWFdWXNK6gc%2FGiHTJ4W5pjrGHR0qzdcoXLfZXR5gw88hxXUXBpW2QKr8O9MoQpPZScjZrOc4qMet8xa2ZFMmrB0Yosoybg4FNYl4LnakV66Yn2vIjXG44u32LfDL2LWRCgndP&ydid_time_created=1339876900&limit=20&time=1342385452&locale=en_US&session_token=f5oziPczcO7E7rpB5P_Ui2NfgRh64J1g&ywsid=gpfz_nbS33avFWL0Ozgz3Q&cc=US&accuracy=0.006214&offset=200&lang=en&signature=tV5sKJ4owo37FvkfPDpDLg%3D%3D&app_version=5.9.1"; 
            break;
        case 12:
            str = @"http://auto-api.yelp.com/check_ins?device_type=iPhone3%2C1%2F5.1.1&efs=mLHUVjDwk2Pm30ESRWYYR2Nqy38Y5Bkcht%2B5iB8oLjNUx4Mgy7ZopjxH%2FWSjWFdWXNK6gc%2FGiHTJ4W5pjrGHR%2FSn4%2BkoRrYiw1cjX7NeZVDQiQ3zRAtKY7lhhNjttPiFOvMIdOsYuxFywyVFoXPoiYbeu4qaf4sGp2KdGVX3r79NIgS8S30sGVDvNdBRf%2FLq&ydid_time_created=1339876900&limit=20&time=1342385495&locale=en_US&session_token=f5oziPczcO7E7rpB5P_Ui2NfgRh64J1g&ywsid=gpfz_nbS33avFWL0Ozgz3Q&cc=US&accuracy=0.006214&offset=220&lang=en&signature=%2B%2FMocKWJvQlVjbp63umesQ%3D%3D&app_version=5.9.1"; 
            break;
        case 13:
            str = @"http://auto-api.yelp.com/check_ins?device_type=iPhone3%2C1%2F5.1.1&efs=mLHUVjDwk2Pm30ESRWYYR2Nqy38Y5Bkcht%2B5iB8oLjNUx4Mgy7ZopjxH%2FWSjWFdWXNK6gc%2FGiHTJ4W5pjrGHR2HXTEumVVGh9jki44JTOPHdWRDIM41sl%2F67VHJ8dvHup5TL%2BNvXWgGgmhyqiiZlLWLpn316jEmFIoLOIy1FW5eSBIDA52j6jfOYbnIBOBNq&ydid_time_created=1339876900&limit=20&time=1342385532&locale=en_US&session_token=f5oziPczcO7E7rpB5P_Ui2NfgRh64J1g&ywsid=gpfz_nbS33avFWL0Ozgz3Q&cc=US&accuracy=0.006214&offset=240&lang=en&signature=hOfi%2FNi94pf0gjokrLf2xg%3D%3D&app_version=5.9.1"; 
            break;
    }

    return [NSURL URLWithString:str]; 
}


-(void) loadCheckins:(int) pageNumber 
{
    if (pageNumber>13)
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
             
             if (items.count < 20 || pageNumber>=13)
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


