//
//  YelpAccount.m
//  Songhori
//
//  Created by Ali Nouri on 12/3/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "YelpAccount.h"
#import "YelpRestaurant.h"


static NSString* st_YWSID;
static NSString* st_CONSUMER_KEY; 
static NSString* st_CONSUMER_SECRET; 
static NSString* st_TOKEN; 
static NSString* st_TOKEN_SECRET; 


@implementation YelpAccount
@synthesize dataProvider=_dataProvider; 
@synthesize active=_active; 

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
    
    
    st_YWSID = [yelp objectForKey:@"YWSID"]; 
    st_CONSUMER_KEY = [yelp objectForKey:@"CONSUMER_KEY"]; 
    st_CONSUMER_SECRET = [yelp objectForKey:@"CONSUMER_SECRET"]; 
    st_TOKEN = [yelp objectForKey:@"TOKEN"]; 
    st_TOKEN_SECRET = [yelp objectForKey:@"TOKEN_SECRET"]; 
    
    
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
            _active = YES; 
            self.dataProvider = [[[YelpRestaurantDataProvider alloc] initWithUserid:aa] autorelease];
            self.dataProvider.delegate = self; 
        }
        else
            _active = NO; 
    }
    
    return self;
}

-(BOOL) syncData
{
    return [self.dataProvider syncData]; 
}


-(void) syncFinished:(id) provider
{
    if ([self.delegate respondsToSelector:@selector(syncFinished:)])
        [self.delegate syncFinished:self]; 
}

-(void) save
{
    [self.dataProvider save]; 
}


-(NSString*) accountName
{
    return @"YelpAccount" ; 
}


-(BOOL) isActive
{
    return _active; 
}

-(void) deactivateAccount
{
    _active = NO; 
    
    //replace the value in the userdefaults
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; 
    
    [ud setValue:nil forKey:@"YelpAccountUsername"]; 
    
    [_dataProvider release]; 
}

-(void) activateAccount:(NSString *)username
{
    if ([self isActive])    //TODO: what about if we want to change the username? 
        return; 
    
    //replace the value in the userdefaults
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; 
    
    [ud setValue:username forKey:@"YelpAccountUsername"]; 

    self.dataProvider = [[[YelpRestaurantDataProvider alloc] initWithUserid:username] autorelease];
    self.dataProvider.delegate = self; 
    
    
    _active = YES;  
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


-(void) sendRestaurantsInRegion:(MKCoordinateRegion)region zoomLevel:(int)zoomLevel
{
    if (![self isActive])
        return; 
    
    if (! self.dataProvider)
        return; 
    
    [self.dataProvider sendRestaurantsInRegion:region];     
}


@end
