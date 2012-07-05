//
//  RestaurantReviewProvider.m
//  Songhori
//
//  Created by Ali Nouri on 7/3/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import "RestaurantReviewProvider.h"

#import "YelpRestaurant.h" 



@implementation RestaurantReviewProvider
@synthesize  delegate=_delegate; 


@synthesize urlConnection=_urlConnection; 
@synthesize incomingData=_incomingData; 
@synthesize request=_request; 
@synthesize restaurant=_restaurant; 

//individual subclasses should implement this 
-(void) fetchReviewsForRestaurant:(Restaurant *)restaurant observer:(id<RestaurantReviewDelegate>)observer
{
    self.delegate = observer; 
    self.restaurant = restaurant; 
    
    NSString* url = [self urlForRestaurant:restaurant]; 
    
    
    self.incomingData = nil; 
    self.request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeoutInterval:60] autorelease]; 
    
    //set parameters of the request except for the body: 
    [self.request setHTTPMethod:@"GET"]; 
    
    self.urlConnection = [NSURLConnection connectionWithRequest:self.request delegate:self]; 
    
}

-(NSString*) urlForRestaurant:(Restaurant *)restaurant
{
    return nil; //should be implemented by each provider 
}

-(void) dealloc
{
    self.urlConnection = nil; 
    self.incomingData = nil; 
    self.request = nil; 

    self.delegate = nil; 
    self.restaurant = nil; 
    
    [super dealloc]; 
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
    NSString* datastr = [[[NSString alloc] initWithData:self.incomingData encoding:NSUTF8StringEncoding] autorelease]; 
    NSLog(@"received data as %@\n", datastr); 
    
    
    
/*    
    //use the data and extract the array of pictureID's
    
    SBJsonParser* parser = [[SBJsonParser alloc] init]; 
    
    parser.maxDepth = 4; 
    
    NSDictionary* d1 = [parser objectWithData:self.incomingData]; 
    
    if (d1 == nil) { NSLog(@"the data from webservice was not formatted correctly: %@\n", datastr); [parser release]; 
        [self.delegate allDataForRequestSent:self]; 
        return; }
    
    
    
    
    
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
        if (locations.count > 50) 
        {
            //create a cluster because too many points clutter the page 
            RestaurantCluster* r = [[RestaurantCluster alloc] init]; 
            [r setCoordinate:selectedRegion.center]; 
            r.name = @"Cluster"; 
            r.detail = @""; 
            r.count = locations.count; 
            
            [result addObject:r]; 
            [r release]; 
            
        }else{
            for (NSArray* item in locations) {
                Restaurant* r = [[FNRestaurant alloc] initWithJSONData:item]; 
                [result addObject:r];             
                [r release]; 
            }
        }
    }
    
    [parser release]; 
    [self.delegate restaudantDataDidBecomeAvailable:result forRegion:selectedRegion fromProvider:self]; 
    [self.delegate allDataForRequestSent:self]; 
    self.incomingData = nil; 
 
 */
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.incomingData = nil; 
    
    if ([self.delegate respondsToSelector:@selector(reviewer:forRestaurant:reviewDidFailWithError:)])
        [self.delegate reviewer:self forRestaurant:self.restaurant reviewDidFailWithError:error]; 
    
}


@end






//------------------------------------YELP provider 

@implementation YelpReviewProvider


-(NSString*) urlForRestaurant:(Restaurant *)restaurant
{
    NSString* bizEndPoint = @"http://api.yelp.com/v2/business/"; 
    NSString* searchEndPoint = @"http://api.yelp.com/v2/search?"; 
    

    NSString* result; 
    
    if ([restaurant isKindOfClass:[YelpRestaurantAnnotation class]])            //we already have the id of the restaurant, search using biz endPoint
    {
        result = [NSString stringWithFormat:@"%@term=%@&ll=%lf,%lf",searchEndPoint, restaurant.name, restaurant.coordinate.latitude, restaurant.coordinate.longitude]; 
        
    }else {                                                                     //we don't have the id, search using the search (restaurant name/location) 
        result = [NSString stringWithFormat:@"%@term=%@&ll=%lf,%lf",searchEndPoint, restaurant.name, restaurant.coordinate.latitude, restaurant.coordinate.longitude]; 
    }
    
    
    result = [result stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]; 
    
    
    return result; 
    
}


@end





//------------------------------------Google provider 

@implementation GoogleReviewProvider



@end