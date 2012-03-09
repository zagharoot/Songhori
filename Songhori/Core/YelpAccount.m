//
//  YelpAccount.m
//  Songhori
//
//  Created by Ali Nouri on 12/3/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "YelpAccount.h"
#import "YelpRestaurant.h"
#import "AccountManager.h"

static NSString* st_YWSID;
static NSString* st_CONSUMER_KEY; 
static NSString* st_CONSUMER_SECRET; 
static NSString* st_TOKEN; 
static NSString* st_TOKEN_SECRET; 


@implementation YelpAccount
@synthesize dataProvider=_dataProvider; 


-(NSString*) info
{
    return [NSString stringWithFormat:@"%d Checkins", [self totalNumberOfCheckins]]; 
}


#pragma mark - read settings from plist file 
+(void) loadSettings
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"AccountSettings" ofType:@"plist"]; 
    NSData* data = [NSData dataWithContentsOfFile:path]; 
    
    NSString* error; 
    NSPropertyListFormat format; 
    NSDictionary* plist; 
    
    plist = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error]; 
    
    if (!plist) 
    {
        NSLog(@"%@", error); 
        [error release]; 
        return; 
    }
    
    NSDictionary* yelp = [plist objectForKey:@"Yelp"]; 
    
    
    st_YWSID = [[yelp objectForKey:@"YWSID"] retain]; 
    st_CONSUMER_KEY = [[yelp objectForKey:@"CONSUMER_KEY"] retain]; 
    st_CONSUMER_SECRET = [[yelp objectForKey:@"CONSUMER_SECRET"] retain]; 
    st_TOKEN = [[yelp objectForKey:@"TOKEN"] retain]; 
    st_TOKEN_SECRET = [[yelp objectForKey:@"TOKEN_SECRET"] retain]; 
    
    
}

+(NSString*) YWSID
{
    if (!st_YWSID)
    {
        [YelpAccount loadSettings]; 
    }
    
    return st_YWSID; 
}

+(NSString*) CONSUMER_KEY
{
    if (!st_CONSUMER_KEY)
        [YelpAccount loadSettings]; 
    
    return st_CONSUMER_KEY; 
}

+(NSString*) CONSUMER_SECRET
{
    if (!st_CONSUMER_SECRET)
        [YelpAccount loadSettings]; 

    return st_CONSUMER_SECRET;
}

+(NSString*) TOKEN
{
    if (!st_TOKEN)
        [YelpAccount loadSettings]; 

    return st_TOKEN; 
}

+(NSString*) TOKEN_SECRET
{
    if (!st_TOKEN_SECRET)
        [YelpAccount loadSettings]; 

    return st_TOKEN_SECRET;
}


#pragma mark - general methods 


- (id)init
{
    self = [super init];
    if (self) 
    {
        //read user defaults for the frobKey
        NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; 
        id aa = [ud valueForKey:@"YelpAccountUsername"]; 
        if (aa)
        {
            self.dataProvider = [[[YelpRestaurantDataProvider alloc] initWithUserid:aa] autorelease];
            self.dataProvider.delegate = self; 
        }
    }
    return self;
}

-(BOOL) syncData
{
    return [self.dataProvider syncData]; 
}


-(void) syncDataForced
{
    [self.dataProvider syncDataForced]; 
}

-(BOOL) isSyncable
{
    return YES; 
}

-(int) totalNumberOfCheckins
{
    if (!self.active)
        return 0; 
    
    YelpUser* user = self.dataProvider.userData; 
    int result =0; 
    for (YelpRestaurant* restaurant in user.checkins) {
        result += restaurant.checkinCount; 
    }
    
    
    
    return result; 
}

-(void) save
{
    [self.dataProvider save]; 
}


-(NSString*) accountName
{
    return @"YelpAccount" ; 
}


-(BOOL) active
{
    return self.dataProvider.userData.active;     
}

-(void) setActive:(BOOL) active
{
    if (active)
    {
        //replace the value in the userdefaults
        NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; 
        
        [ud setValue:@"alidoon" forKey:@"YelpAccountUsername"]; 
        
        self.dataProvider = [[[YelpRestaurantDataProvider alloc] initWithUserid:@"alidoon"] autorelease];
        self.dataProvider.delegate = self; 
        
        self.dataProvider.userData.active = YES; 
            
        [self.dataProvider save]; 
    }else 
    {
        self.dataProvider.userData.active = NO; 
        
        //replace the value in the userdefaults
        NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; 
        
        [ud setValue:nil forKey:@"YelpAccountUsername"]; 
        
        [self.dataProvider save]; 
        self.dataProvider = nil; 
    }
}


-(void) sendRestaurantsInRegion:(MKCoordinateRegion)region zoomLevel:(int)zoomLevel
{
    if (!self.active)
        return; 
    
    if (! self.dataProvider)
        return; 
    
    [self.dataProvider sendRestaurantsInRegion:region];     
}


#pragma mark - delegate methods 

-(void) allDataForRequestSent:(id)provider
{
    [self.delegate allDataForRequestSent:self];     //because we only have one provider 
}

-(void) restaudantDataDidBecomeAvailable:(NSArray *)restaurants forRegion:(MKCoordinateRegion)region fromProvider:(id)provider
{
    //the array we get is of YelpRestaurant, but we need to change it to YelpRestaurantAnnotation
    
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:100]; 
    for (YelpRestaurant* r in restaurants) {
        [result addObject: r.annotation]; 
    }

    [self.delegate restaudantDataDidBecomeAvailable:result forRegion:region fromProvider:self]; 
}

-(void) syncFinished:(id) provider
{
    if ([self.delegate respondsToSelector:@selector(syncFinished:)])
        [self.delegate syncFinished:self]; 
}



@end
