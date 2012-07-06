//
//  RestaurantReviewProvider.m
//  Songhori
//
//  Created by Ali Nouri on 7/3/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import "RestaurantReviewProvider.h"
#import "JSON.h"
#import "YelpRestaurant.h" 


@implementation OAuthRestaurantReviewProvider

@synthesize apiContext=_apiContext; 
@synthesize apiRequest=_apiRequest; 

@synthesize accessToken=_accessToken; 
@synthesize accessSecret=_accessSecret; 

-(NSString*) apiKey
{
    return @""; //should be filled by each provider 
}

-(NSString*) apiSecret
{
    return @""; 
}

-(void) fetchReviewsForRestaurant:(Restaurant *)restaurant observer:(id<RestaurantReviewDelegate>)observer
{
    self.delegate = observer; 
    self.restaurant = restaurant; 
    
    NSString* url = [self urlForRestaurant:restaurant]; 
    NSDictionary* args = [self argsForRestaurant:restaurant]; 
    
    self.apiRequest = [[[OAuthProviderRequest alloc] initWithAPIContext:self.apiContext] autorelease];  
    self.apiRequest.delegate = self; 
    
    
    [self.apiRequest callAPIMethodWithGET:url arguments:args]; 
    
}

-(id) init
{
    self = [super init]; 
    if (self)
    {
        _apiContext = [[OAuthProviderContext alloc] init]; 
        
        self.apiContext.key = self.apiKey; 
        self.apiContext.sharedSecret = self.apiSecret; 
    }
    
    return self; 
}

-(void) dealloc
{
    self.apiContext = nil; 
    self.apiRequest = nil; 
    

    [super dealloc]; 
}

#pragma mark- objective flickr delegate 

-(void) OAuthRequest:(OAuthProviderRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    //  NSLog(@"Got response %@\n", inResponseDictionary); 
    
    RestaurantReview* review = [self processResult:inResponseDictionary]; 
    
    if ([self.delegate respondsToSelector:@selector(reviewer:forRestaurant:reviewDidFinish:)])
        [self.delegate reviewer:self forRestaurant:self.restaurant reviewDidFinish:review]; 
}



-(void) OAuthRequest:(OAuthProviderRequest *)inRequest didFailWithError:(NSError *)inError
{
    if ([self.delegate respondsToSelector:@selector(reviewer:forRestaurant:reviewDidFailWithError:)])
        [self.delegate reviewer:self forRestaurant:self.restaurant reviewDidFailWithError:inError]; 
}



@end


@implementation RestaurantReviewProvider
@synthesize  delegate=_delegate; 


@synthesize restaurant=_restaurant; 


-(void) fetchReviewsForRestaurant:(Restaurant *)restaurant observer:(id<RestaurantReviewDelegate>)observer
{
}

-(NSString*) urlForRestaurant:(Restaurant *)restaurant
{
    return nil; //should be implemented by each provider 
}

-(NSDictionary*) argsForRestaurant:(Restaurant *)restaurant
{
    return nil; 
}

-(RestaurantReview*) processResult:(NSDictionary *)response
{
    return nil; 
}


-(void) dealloc
{

    self.delegate = nil; 
    self.restaurant = nil; 

    [super dealloc]; 
}



@end


@implementation SimpleRestaurantReviewProvider
@synthesize urlRequest=_urlRequest; 
@synthesize urlConnection =_urlConnection; 
@synthesize incomingData=_incomingData; 

-(void) fetchReviewsForRestaurant:(Restaurant *)restaurant observer:(id<RestaurantReviewDelegate>)observer
{
    self.delegate = observer; 
    self.restaurant = restaurant; 
    
    NSString* url = [self urlForRestaurant:restaurant]; 
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]; 

    self.urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]]; 
    
    self.urlConnection = [NSURLConnection connectionWithRequest:self.urlRequest delegate:self]; 
}



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
//    NSString* datastr = [[[NSString alloc] initWithData:self.incomingData encoding:NSUTF8StringEncoding] autorelease]; 
//    NSLog(@"received data as %@\n", datastr); 

    
    
    SBJsonParser* parser = [[SBJsonParser alloc] init]; 
    
    parser.maxDepth = 7; 
    
    NSDictionary* inResponseDictionary = [parser objectWithData:self.incomingData]; 
    
    
    RestaurantReview* review = [self processResult:inResponseDictionary]; 
    
    if ([self.delegate respondsToSelector:@selector(reviewer:forRestaurant:reviewDidFinish:)])
        [self.delegate reviewer:self forRestaurant:self.restaurant reviewDidFinish:review]; 
    
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(reviewer:forRestaurant:reviewDidFailWithError:)])
        [self.delegate reviewer:self forRestaurant:self.restaurant reviewDidFailWithError:error]; 
}


-(void) dealloc
{
    self.urlRequest = nil; 
    self.urlConnection = nil; 
    self.incomingData = nil; 
    
    [super dealloc]; 
}


@end



//------------------------------------YELP provider 

@implementation YelpReviewProvider


-(NSString*) apiKey
{
    return @"oGh6qFD1JCawaSJcTMYM_w"; 
}

-(NSString*) apiSecret
{
    return @"KU5IJYgdIIKlXW6kWko2xfxUSDw"; 
    
}

-(NSString*) accessToken
{
    return @"eBcbXmC6BlHAH23VOb2UsPGSpH7_VuNh"; 
    
}

-(NSString*) accessSecret
{
    return @"qnTr-pols2Odq4j99qBaXPhnou4"; 
    
}


-(id) init
{
    self = [super init]; 
    if (self)
    {
        
        self.apiContext.OAuthToken = self.accessToken; 
        self.apiContext.OAuthTokenSecret = self.accessSecret;
        
        self.apiContext.messageType = @"JSON"; 
    }
    
    return self; 
}


-(void) dealloc
{
    [_apiContext release]; 
    
    [super dealloc]; 
}

-(NSDictionary*) argsForRestaurant:(Restaurant *)restaurant
{
    NSDictionary* result; 
    if ([restaurant isKindOfClass:[YelpRestaurantAnnotation class]])
    {
        result = [NSDictionary dictionary]; 
    }else {
        NSString* coord = [NSString stringWithFormat:@"%lf,%lf", restaurant.coordinate.latitude, restaurant.coordinate.longitude]; 
        
        result = [NSDictionary dictionaryWithObjectsAndKeys:restaurant.name, @"term", coord, @"ll", nil];
    }
         
    return result; 
}

-(NSString*) urlForRestaurant:(Restaurant *)restaurant
{
    NSString* bizEndPoint = @"http://api.yelp.com/v2/business/"; 
    NSString* searchEndPoint = @"http://api.yelp.com/v2/search"; 
    
    if ([restaurant isKindOfClass:[YelpRestaurantAnnotation class]])            //we already have the id of the restaurant, search using biz endPoint
    {
        
        YelpRestaurantAnnotation* yr = (YelpRestaurantAnnotation*) restaurant; 
        
        
        return [NSString stringWithFormat:@"%@%@", bizEndPoint, yr.restaurant.y_id]; 
    }else {                                                                     //we don't have the id, search using the search (restaurant name/location) 
        return searchEndPoint; 

    }
}


-(RestaurantReview*) processResult:(NSDictionary *)response
{
    RestaurantReview* result = [[RestaurantReview alloc] initWithRestaurant:self.restaurant]; 
    result.providerClass = [YelpReviewProvider class]; 

    NSDictionary* b;        //this is for the business obj
    
    NSArray* businesses = [response objectForKey:@"businesses"]; 
    
    if(businesses != nil) 
        b = [businesses objectAtIndex:0]; 
    else
        b = response; 
    
    if (b == nil) 
        return nil; 
    
    //TODO: make sure the business is the same as we looked for 
    
    result.rating = [[b objectForKey:@"rating"] doubleValue]; 
    result.numberOfReviews = [[b objectForKey:@"review_count"] intValue]; 
        
    result.ratingImageURL = [b objectForKey:@"rating_img_url_large"]; 
    
    return [result autorelease]; 
}


@end





//------------------------------------Google provider 

@implementation GoogleReviewProvider

-(NSString*) urlForRestaurant:(Restaurant *)restaurant
{
    NSString* key = @"AIzaSyDNnpWBiLtqnMo5BDSmvQQwCgTVJune1Ik"; 
    NSString* location = [NSString stringWithFormat:@"%lf,%lf", restaurant.coordinate.latitude, restaurant.coordinate.longitude]; 
    NSString* keyword = restaurant.name; 
    int distance = 1000; 
    NSString* result = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?key=%@&location=%@&radius=%d&sensor=false&keyword=%@", key, location, distance, keyword]; 
    
    
    return result; 
}


-(RestaurantReview*) processResult:(NSDictionary *)response
{
    RestaurantReview* review = [[[RestaurantReview alloc] initWithRestaurant:self.restaurant] autorelease]; 
    review.providerClass = [GoogleReviewProvider class]; 

    NSArray* businesses = [response objectForKey:@"results"]; 
    
    NSDictionary* b; 
    
    if (businesses.count > 0)
        b = [businesses objectAtIndex:0]; 
    
    
    if (b == nil) 
        return review;
    
    //TODO: make sure this business is the same as we looked for

    review.rating = [[b objectForKey:@"rating"] doubleValue]; 
    
    return review; 
}



@end