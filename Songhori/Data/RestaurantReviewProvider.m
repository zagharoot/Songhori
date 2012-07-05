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


@synthesize restaurant=_restaurant; 

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

//individual subclasses should implement this 
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

    self.delegate = nil; 
    self.restaurant = nil; 

    self.apiContext = nil; 
    self.apiRequest = nil; 
    
    [super dealloc]; 
}


#pragma mark- objective flickr delegate 

-(void) OAuthRequest:(OAuthProviderRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    NSLog(@"Got response %@\n", inResponseDictionary); 
    
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
        //TODO: fill this 
        
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
        return bizEndPoint; 
    }else {                                                                     //we don't have the id, search using the search (restaurant name/location) 
        return searchEndPoint; 

    }
}


-(RestaurantReview*) processResult:(NSDictionary *)response
{
    RestaurantReview* result = [[RestaurantReview alloc] initWithRestaurant:self.restaurant]; 
        

    NSArray* businesses = [response objectForKey:@"businesses"]; 
    
    for (NSDictionary* b in businesses) 
    {
        result.rating = [[b objectForKey:@"rating"] doubleValue]; 
        result.numberOfReviews = [[b objectForKey:@"review_count"] intValue]; 
        
        result.ratingImageURL = [b objectForKey:@"rating_img_url"]; 
    }
    
    
    return [result autorelease]; 
}


@end





//------------------------------------Google provider 

@implementation GoogleReviewProvider



@end