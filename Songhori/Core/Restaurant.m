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
@synthesize url=_url; 
@synthesize iconImage=_iconImage; 


-(UIImage*) logo
{
    return nil; //each account should implement their own 
}

-(UIImage*) secondaryLogo
{
    return nil; 
}

-(void) setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    __coordinate.latitude = newCoordinate.latitude; 
    __coordinate.longitude = newCoordinate.longitude; 
}

@end



@implementation FNRestaurant

@synthesize urlConnection=_urlConnection; 
@synthesize incomingData=_incomingData; 
@synthesize specialty=_specialty; 


-(UIColor*) pinColor
{
    return [UIColor redColor]; 
}

-(UIImage*) logo
{
    if (!FNLogo)
    {
        FNLogo = [[UIImage imageNamed:@"FNLogo.png"] retain]; 
    }
    
    return FNLogo; 
}


-(UIImage*) secondaryLogo
{
    return [self logo]; //TODO: should return the secondary for each show 
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
                self.url = _specialtyURL; 
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
    
    self.detail = @"Loading..."; 
    self.specialty = @"Loading..."; 
}




-(void) dealloc
{
    self.urlConnection = nil; 
    self.incomingData = nil; 
    [request release]; 
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

    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //incomingData has the html file. Let's parse it and extract the relevant data 
        
        // Create parser
        TFHpple* xpathParser = [[TFHpple alloc] initWithHTMLData:self.incomingData];
        
//        NSString* newStr = [[[NSString alloc] initWithData:self.incomingData                                                  encoding:NSUTF8StringEncoding] autorelease];    
        

        //this gets the specialty element: 
        NSArray* selem = [xpathParser searchWithXPathQuery:@"//div[@id='fn-w']/div[2]/div[2]/p[2]/span[1]"]; 

        if (selem.count>0)
        {
            // Access the first cell
            TFHppleElement *element = [selem objectAtIndex:0];
            
            // Get the text within the cell tag
            self.specialty = [element content];
        }else
            self.specialty = @"N/A"; 
        
        
        
        
        //this gets description of the restaurant
        NSArray* delem = [xpathParser searchWithXPathQuery:@"//div[@id='fn-w']/div[2]/div[2]/p[1]"]; 
        
        if (delem.count>0)
        {
            // Access the first cell
            TFHppleElement *element = [delem objectAtIndex:0];
            
            // Get the text within the cell tag
            self.detail = [element content];
        }else
            self.detail = @"N/A"; 
        

        
        
        
        [xpathParser release];    

        dispatch_async( dispatch_get_main_queue(), ^{
            // Add code here to update the UI/send notifications based on the
            // results of the background processing
        });
    });
}




-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.incomingData = nil;     
    
    self.detail = @"N/A"; 
    self.specialty = @"N/A"; 
}




@end
