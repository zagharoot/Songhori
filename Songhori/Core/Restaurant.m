//
//  Restaurant.m
//  FoodNetworkLocal
//
//  Created by Ali Nouri on 9/25/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "Restaurant.h"
#import "TFHpple.h"

static UIImage* FNLogo; 


@implementation Restaurant 
@synthesize coordinate=__coordinate; 
@synthesize name=_name; 
@synthesize detail=_detail; 

-(UIImage*) logo
{
    return nil; //each account should implement their own 
}

@end



@implementation FNRestaurant

@synthesize urlConnection=_urlConnection; 
@synthesize incomingData=_incomingData; 
@synthesize specialty=_specialty; 


-(UIImage*) logo
{
    if (!FNLogo)
    {
        FNLogo = [[UIImage imageNamed:@"FNLogo.png"] retain]; 
    }
    
    return FNLogo; 
}

-(id) initWithJSONData:(id) json
{
    self = [super init]; 
    if (self) 
    {
        NSArray* data = (NSArray*) json; 
        __coordinate.latitude = [[data objectAtIndex:1] doubleValue];
        __coordinate.longitude = [[data objectAtIndex:2] doubleValue]; 
        _name = @""; 
        _detail =  @""; 

        @try {
            
            id t = [data objectAtIndex:3]; 
            if ([t respondsToSelector:@selector(length)])
            {
                _name = [[data objectAtIndex:3] copy]; 
                _detail = [[data objectAtIndex:4] copy]; 
                _specialtyURL = [NSString stringWithFormat:@"http://foodnetwork.com%@", [data objectAtIndex:13]]; 
                [self loadSpecialty]; 
            }

        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }

    
    return self; 
}


-(void) loadSpecialty
{
    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_specialtyURL] cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeoutInterval:60]; 
    
    //set parameters of the request except for the body: 
    [request setHTTPMethod:@"GET"]; 
    
    self.urlConnection = [NSURLConnection connectionWithRequest:request delegate:self]; 
}




-(void) dealloc
{
    [_name release]; 
    [_detail release]; 
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
    //incomingData has the html file. Let's parse it and extract the relevant data 
    
    // Create parser
    TFHpple* xpathParser = [[TFHpple alloc] initWithHTMLData:self.incomingData];
    
    //Get all the cells of the 2nd row of the 3rd table 
    NSArray* elements = [xpathParser searchWithXPathQuery:@"//div[@id='fn-w']/div[3]/p[1]"]; 

    if (elements.count>0)
    {
        // Access the first cell
        TFHppleElement *element = [elements objectAtIndex:0];
    
        // Get the text within the cell tag
        self.detail = [element content];
    }
    
    [xpathParser release];    
    
}




-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.incomingData = nil;     
}




@end
