//
//  FNRestaurantDataProvider.m
//  Songhori
//
//  Created by Ali Nouri on 12/8/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "FNRestaurantDataProvider.h"
#import "JSON.h"


#define BASE_URL @"http://www.foodnetwork.com/local/search/cxfDispatcher/foodLocalMapSearch?"


@implementation FNRestaurantDataProvider
@synthesize  delegate=_delegate; 


@synthesize urlConnection=_urlConnection; 
@synthesize incomingData=_incomingData; 
@synthesize request=_request; 

-(id) init
{
    self = [super init]; 
    if (self) 
    {
        
        
    }
    
    
    return self; 
}


-(void) dealloc
{
    self.urlConnection = nil; 
    self.incomingData = nil; 
    self.request = nil; 
    
    [super dealloc]; 
}


-(NSURL*) urlForRegion:(MKCoordinateRegion)region zoomLevel:(int)zoom
{
        CLLocationDegrees uplat =  region.center.latitude + region.span.latitudeDelta/2.0; 
        CLLocationDegrees leftlon = region.center.longitude - region.span.longitudeDelta/2.0; 
        CLLocationDegrees downlat = region.center.latitude - region.span.latitudeDelta/2.0; 
        CLLocationDegrees rightlon = region.center.longitude + region.span.longitudeDelta/2.0; 
        
        
        NSString* str = [NSString stringWithFormat:@"%@uplat=%lf&leftlon=%lf&downlat=%lf&rightlon=%lf&level=%d&show=The+Best+Thing+I+Ever+Ate&_1316992333468=", BASE_URL, uplat, leftlon, downlat, rightlon, zoom]; 
        
        NSURL* result = [NSURL URLWithString:str]; 
        
        return result; 
        
}

-(void) sendRestaurantsInRegion:(MKCoordinateRegion)region zoomLevel:(int)zoomLevel
{
    self.incomingData = nil; 
        
    self.request = [[[NSMutableURLRequest alloc] initWithURL:[self urlForRegion:region zoomLevel:zoomLevel] cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeoutInterval:60] autorelease]; 
    
    //set parameters of the request except for the body: 
    [self.request setHTTPMethod:@"GET"]; 
    
    self.urlConnection = [NSURLConnection connectionWithRequest:self.request delegate:self]; 
    
    selectedRegion = region; 
    
}



#pragma mark - urlConnection delegate methods 

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.incomingData = [[[NSMutableData alloc] init] autorelease]; 
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.incomingData appendData:data]; 
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    //    
    //NSString* datastr = [[NSString alloc] initWithData:self.incomingData encoding:NSUTF8StringEncoding]; 
    //NSLog(@"received data as %@\n", datastr); 
    
    
    
    
    //use the data and extract the array of pictureID's
    
    SBJsonParser* parser = [[SBJsonParser alloc] init]; 
    
    parser.maxDepth = 4; 
    
    NSDictionary* d1 = [parser objectWithData:self.incomingData]; 
    
    if (d1 == nil) { NSLog(@"the data from webservice was not formatted correctly"); [parser release];  return; }
    
    
    NSArray* locations = [d1 objectForKey:@"locations"]; 
    NSArray* clusters= [d1 objectForKey:@"locationClusters"]; 
    

    NSMutableArray* result = [NSMutableArray arrayWithCapacity:100]; 
    
    if (clusters.count>0)       //we are showing clusters (do we also show individuals? because they are in the data)
    {
        for (NSArray* item in clusters) {
            RestaurantCluster* r = [[RestaurantCluster alloc] initWithJSONData:item]; 
            [result addObject:r]; 
            
            [r release]; 
        }
    }else           //only working with individual restaurants
    {
        for (NSArray* item in locations) {
            Restaurant* r = [[FNRestaurant alloc] initWithJSONData:item]; 
            [result addObject:r];             
            [r release]; 
        }
    }

    [parser release]; 
    [self.delegate restaudantDataDidBecomeAvailable:result forRegion:selectedRegion fromProvider:self]; 
    self.incomingData = nil; 
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.incomingData = nil; 
    //TODO: send the error up the ladder
    
}


@end
