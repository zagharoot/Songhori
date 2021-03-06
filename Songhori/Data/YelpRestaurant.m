//
//  YelpRestaurant.m
//  Songhori
//
//  Created by Ali Nouri on 12/6/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "YelpRestaurant.h"
#import "YelpUser.h"
#import "OAuthConsumer.h"
#import "YelpAccount.h"

@implementation YelpRestaurant
@synthesize annotation=_annotation; 
@synthesize delegate=_delegate; 

@dynamic latitude;
@dynamic longitude;
@dynamic y_id;
@dynamic name;
@dynamic jsonData; 
@dynamic lastCheckinDate;
@dynamic checkinCount;
@dynamic user;
@dynamic checkins; 

-(YelpRestaurantAnnotation*) annotation
{
    if (! _annotation)
        _annotation = [[YelpRestaurantAnnotation alloc] initWithYelpRestaurant:self]; 
    
    return _annotation; 
}

-(void) addCheckin:(YelpCheckin *)checkin
{
    if (self.lastCheckinDate < checkin.visitDate) 
        self.lastCheckinDate = checkin.visitDate; 
    
    [self addCheckinsObject:checkin]; 
}


-(BOOL) isDetailDataAvailable
{
    if (!self.name)
        return NO; 
    
    if (self.name.length==0)
        return NO; 
    
    if (self.latitude ==0 && self.longitude ==0)
        return NO; 
    
    return YES; 
}

-(BOOL) hasError
{
    if ([self isDetailDataAvailable])
        return NO; 
    
    if (!self.jsonData) 
        return NO; 
    
    if (self.jsonData.length==0)
        return NO; 
    
    
    return YES;             //TODO: how about read the json to see what error is in there? 
}

-(void) loadDetailsFromWebsite
{
    
    //get the other stuff from another api call:
    NSString* str = [NSString stringWithFormat:@"%@%@", BUSINESS_LOOKUP_API, self.y_id]; 
    NSURL *URL = [NSURL URLWithString:str];
    OAConsumer *consumer = [[[OAConsumer alloc] initWithKey:[YelpAccount CONSUMER_KEY]   secret:[YelpAccount CONSUMER_SECRET]] autorelease];
    OAToken *token = [[[OAToken alloc] initWithKey:[YelpAccount TOKEN] secret:[YelpAccount TOKEN_SECRET]] autorelease];  
    
    id<OASignatureProviding, NSObject> provider = [[[OAHMAC_SHA1SignatureProvider alloc] init] autorelease];
    NSString *realm = nil;  
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:URL
                                                                   consumer:consumer
                                                                      token:token
                                                                      realm:realm
                                                          signatureProvider:provider];
    [request prepare];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* error)
     {
         if (response == nil)       //error happened
         {
             [self notifyDelegateOfDetailDownloadFinish:NO];
             NSLog(@"Error downloading checkins from yelp: %@\n", [error description]); 
         } else         //success
         {
             NSString* str = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]; 
             // NSLog(@"received %@\n", str);
             
             SBJsonParser* parser = [[SBJsonParser alloc] init]; 
             parser.maxDepth = 5; 
             
             NSDictionary* d1 = [parser objectWithData:data]; 
             if (d1 == nil) { NSLog(@"the data from webservice was not formatted correctly: %@\n", str); [parser release]; [self notifyDelegateOfDetailDownloadFinish:NO]; return;}
             
             
             self.jsonData = str; 
             
             
             //loading the coordinates: 
             NSDictionary* locDic = [d1 objectForKey:@"location"]; 
             if (locDic == nil) { NSLog(@"the data from webservice was not formatted correctly: %@\n", str); [parser release]; [self notifyDelegateOfDetailDownloadFinish:NO]; 
return;}

            
             
             NSDictionary* coordinateDic = [locDic objectForKey:@"coordinate"]; 
             if (coordinateDic) 
             {
                 self.longitude = [[coordinateDic objectForKey:@"longitude"] doubleValue]; 
                 self.latitude = [[coordinateDic objectForKey:@"latitude"] doubleValue]; 
             }
             
             
             //loading the name: 
             self.name = [d1 objectForKey:@"name"]; 
             
             //cleanup 
             [parser release];
             

             [self notifyDelegateOfDetailDownloadFinish:YES]; 
         }// if 
         
     }]; 
    
    
    [request release]; 
}



-(void) notifyDelegateOfDetailDownloadFinish:(BOOL)success
{
    //TODO: we don't care about success for now 
    
    //inform the delegate
    if(self.delegate)
        if ([self.delegate respondsToSelector:@selector(detailDataDidDownloadForRestaurant:)])
            [self.delegate detailDataDidDownloadForRestaurant:self]; 
}

-(void) awakeFromFetch
{
    [super awakeFromFetch]; 

    if (!self.isDetailDataAvailable)
    {
        NSLog(@"data not available on db, reloading from yelp\n"); 
        [self loadDetailsFromWebsite]; 
        
    }
}


-(void) dealloc
{
    [_annotation release]; 
    [super dealloc]; 
}


@end


static UIImage* YelpLogo; 



//-----------------------------------------------------------
@implementation YelpRestaurantAnnotation
@synthesize restaurant=_restaurant; 


-(NSString*) name
{
    return self.restaurant.name; 
}


-(UIColor*) pinColor
{
    return [UIColor orangeColor]; 
}


-(id) initWithYelpRestaurant:(YelpRestaurant *)r
{
    self = [super init]; 
    if (self) 
    {
        _restaurant = r;    //this is an assign, so never release
        
        __coordinate.latitude = r.latitude; 
        __coordinate.longitude = r.longitude; 
        
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"yelp:"]])
            self.url = [NSString stringWithFormat:@"yelp:///biz/%@", r.y_id]; 
        
    }
    return self; 
}


-(UIImage*) logo
{
    if (!YelpLogo)
    {
        YelpLogo = [[UIImage imageNamed:@"yelpLogo.png"] retain]; 
    }
    
    return YelpLogo; 
}




-(NSString*) detail
{
    int cnt = self.restaurant.checkinCount; 
    NSTimeInterval t = self.restaurant.lastCheckinDate; 
    NSDate* d = [NSDate dateWithTimeIntervalSince1970:t+NSTimeIntervalSince1970];  
    
    
    NSString* result = [NSString stringWithFormat:@"number of checkins: %d\nlast on: %@", cnt, d]; 
    
    return result; 
}


-(void) dealloc
{
    self.url = nil; 
    
    [super dealloc]; 
}


@end


