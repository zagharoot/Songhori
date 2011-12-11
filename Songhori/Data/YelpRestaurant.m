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

@implementation YelpRestaurant
@synthesize annotation=_annotation; 
@synthesize delegate=_delegate; 

@dynamic latitude;
@dynamic longitude;
@dynamic y_id;
@dynamic name;
@dynamic jsonData; 
@dynamic checkinDate;
@dynamic checkinCount;
@dynamic user;


-(YelpRestaurantAnnotation*) annotation
{
    if (! _annotation)
        _annotation = [[YelpRestaurantAnnotation alloc] initWithYelpRestaurant:self]; 
    
    
    return _annotation; 
    
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


-(void) loadDetailsFromWebsite
{
    //get the other stuff from another api call:
    NSString* str = [NSString stringWithFormat:@"%@%@", BUSINESS_LOOKUP_API, self.y_id]; 
    NSURL *URL = [NSURL URLWithString:str];
    OAConsumer *consumer = [[[OAConsumer alloc] initWithKey:CONSUMER_KEY   secret:CONSUMER_SECRET] autorelease];
    OAToken *token = [[[OAToken alloc] initWithKey:TOKEN secret:TOKEN_SECRET] autorelease];  
    
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
             NSLog(@"Error downloading checkins from yelp: %@\n", [error description]); 
         } else         //success
         {
             NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; 
             // NSLog(@"received %@\n", str);
             
             
             SBJsonParser* parser = [[SBJsonParser alloc] init]; 
             
             parser.maxDepth = 9; 
             
             
             NSDictionary* d1 = [parser objectWithData:data]; 
             if (d1 == nil) { NSLog(@"the data from webservice was not formatted correctly"); [parser release]; return;}
             
             
             self.jsonData = str; 
             [str release]; 
             
             
             
             //loading the coordinates: 
             
             NSDictionary* locDic = [d1 objectForKey:@"location"]; 
             if (locDic == nil) { NSLog(@"the data from webservice was not formatted correctly"); [parser release]; return;}
             
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
             
             //inform the delegate
             if(self.delegate)
                 if ([self.delegate respondsToSelector:@selector(detailDataDidDownloadForRestaurant:)])
                     [self.delegate detailDataDidDownloadForRestaurant:self]; 
             
         }// if 
         
     }]; 
}


-(void) awakeFromFetch
{
    [super awakeFromFetch]; 

    if (!self.isDetailDataAvailable)
        [self loadDetailsFromWebsite]; 
    
}



-(void) loadFromJSON:(id)json
{
    NSDictionary* business = json; // [((NSDictionary*) json) objectForKey:@"business"]; 
    
    self.y_id = [business objectForKey:@"business_id"]; 
    id t =  [business objectForKey:@"time_created"];
    self.checkinDate = [t doubleValue]-NSTimeIntervalSince1970; 
    self.checkinCount = [[business objectForKey:@"check_in_count"] intValue]; 

    self.longitude = 0; 
    self.latitude = 0; 
    self.name = nil; 
    
}


-(void) dealloc
{
    [_annotation release]; 
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



-(id) initWithYelpRestaurant:(YelpRestaurant *)r
{
    self = [super init]; 
    if (self) 
    {
        _restaurant = r;    //this is an assign, so never release
        
        __coordinate.latitude = r.latitude; 
        __coordinate.longitude = r.longitude; 
        
        
//        CLLocationCoordinate2D loc; 
//        loc.latitude = r.latitude; 
//        loc.longitude = r.longitude; 
//        [self setCoordinate:loc]; 
    }
    return self; 
}


-(UIImage*) logo
{
    if (!YelpLogo)
    {
        YelpLogo = [[UIImage imageNamed:@"YelpLogo.png"] retain]; 
    }
    
    return YelpLogo; 
}




-(NSString*) detail
{
    int cnt = self.restaurant.checkinCount; 
    NSTimeInterval t = self.restaurant.checkinDate; 
    NSDate* d = [NSDate dateWithTimeIntervalSince1970:t+NSTimeIntervalSince1970];  
    
    
    NSString* result = [NSString stringWithFormat:@"number of checkins: %d\nlast on: %@", cnt, d]; 
    
    return result; 
}




@end


