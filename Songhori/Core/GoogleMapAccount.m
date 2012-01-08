//
//  GoogleMapAccount.m
//  Songhori
//
//  Created by Ali Nouri on 1/2/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import "GoogleMapAccount.h"
#import "AccountManager.h"
#import "TFHpple.h" 

@implementation GoogleMapAccount
@synthesize active=_active; 
@synthesize list=_list; 
@synthesize urlConnection=_urlConnection;
@synthesize request=_request; 
@synthesize incomingData=_incomingData; 


-(id) init
{
    self = [super init]; 
    if (self) 
    {
        model = [AccountManager standardAccountManager].coreModel; 
        context = [AccountManager standardAccountManager].coreContext; 
    }
    return self; 
}

-(NSString*) info
{
    return self.list.name; 
}


-(id) initWithURL:(NSString *)url
{
    self = [self init]; 
    if (self)
    {
        //TODO: fill here 
        self.list = [NSEntityDescription insertNewObjectForEntityForName:@"GoogleMapList" inManagedObjectContext:context]; 
        self.list.url = url;
        self.list.lastSyncDate = 0; 
        self.list.active = YES; 
        
        [self syncData]; 
    }
    return self; 
}

-(id) initWithGoogleMapList:(GoogleMapList *)l
{
    self = [self init]; 
    if(self)
    {
        self.list = l; 
        l.account = self; 
    }
    
    return self; 
}


-(BOOL) active
{
    return self.list.active; 
}


-(void) setActive:(BOOL)active
{
    self.list.active = active; 
}



-(void) save
{
    if ([context hasChanges])
        [context save:nil]; 
}


-(BOOL) syncData
{
    BOOL result=NO; 
    //only resync if we haven't already today 

        NSTimeInterval diff = [NSDate timeIntervalSinceReferenceDate] - self.list.lastSyncDate; 
        if (diff > 86400)       //it's been more than one day 
        {
            result = YES; 

            self.request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.list.url] cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeoutInterval:60] autorelease]; 
            
            //set parameters of the request except for the body: 
            [self.request setHTTPMethod:@"GET"]; 
            
            self.urlConnection = [NSURLConnection connectionWithRequest:self.request delegate:self]; 
        }
    return result; 
}

-(void) deleteAccount
{
    if (! self.list)
        return; 
    
    [context deleteObject:self.list]; 
    self.list = nil; 
}


-(NSString*) accountName
{
    return @"GoogleMapList"; 
}

-(void) didReceiveMemoryWarning
{
    
}

-(void) sendRestaurantsInRegion:(MKCoordinateRegion) region zoomLevel:(int) zoomLevel
{
    if (!self.active)
        return; 

    NSMutableArray* result = [NSMutableArray arrayWithCapacity:100]; 
    
    
        NSArray* res = [self.list restaurantsInRegion:region zoomLevel:zoomLevel]; 
        
        for (GoogleMapRestaurant* a in res) {
            [result addObject:a.annotation]; 
        }
    [self.delegate restaudantDataDidBecomeAvailable: result forRegion:region fromProvider:self];     
}



-(void) dealloc
{
    self.list = nil; 

    self.urlConnection = nil; 
    self.incomingData = nil; 
    self.request = nil; 

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
   // NSLog(@"received data as %@\n", datastr); 
    
    //TODO: make this process more efficient/stable?
    datastr =  [datastr stringByReplacingOccurrencesOfString:@"<kml xmlns=\"http://earth.google.com/kml/2.2\">" withString:@""]; 
    datastr = [datastr stringByReplacingOccurrencesOfString:@"</kml>" withString:@""]; 
    

    NSData* newData = [datastr dataUsingEncoding:NSUTF8StringEncoding]; 
    
    TFHpple* parser = [[TFHpple alloc] initWithXMLData:newData]; 
    
    NSArray* narray = [parser searchWithXPathQuery:@"/Document/name"]; 
    
    if (narray.count>0)
    {
        TFHppleElement* nameElem = [narray objectAtIndex:0]; 
        self.list.name = nameElem.content; 
    }
    
    NSArray* restaurants = [parser searchWithXPathQuery:@"/Document/Placemark"]; 

    
    
    for (TFHppleElement* r in restaurants) 
    {
        NSString* name = nil; 
        double latitude = 1000; 
        double longitude = 1000; 
        
        for (TFHppleElement* rchild in r.children) 
        {
            if ([rchild.tagName compare: @"name"]== NSOrderedSame)
            {
                name = rchild.content; 
            }else if ([rchild.tagName compare: @"Point"] == NSOrderedSame)
            {
                TFHppleElement* coordinate = rchild.firstChild; 
                NSString* coordStr = coordinate.content; 
                if (!coordStr)
                    continue; 
                
                NSArray* numbers = [coordStr componentsSeparatedByString:@","]; 
                if (numbers.count <2)
                    continue; 
                
                [[NSScanner scannerWithString:[numbers objectAtIndex:1]] scanDouble:&latitude]; 
                [[NSScanner scannerWithString:[numbers objectAtIndex:0]] scanDouble:&longitude]; 
                
            }
        }

        if (!name || latitude==1000 || longitude==1000)
            continue; 
        
        
        GoogleMapRestaurant* gr =  [NSEntityDescription insertNewObjectForEntityForName:@"GoogleMapRestaurant" inManagedObjectContext:context]; 
        
        gr.name = name; 
        gr.latitude = latitude; 
        gr.longitude = longitude; 
        
        [self.list addRestaurantsObject:gr]; 
    }
    
    
    self.list.lastSyncDate = [NSDate timeIntervalSinceReferenceDate]; 
    
    
    [self save]; 
    
    [parser release]; 
    
    self.incomingData = nil; 

    if ([self.delegate respondsToSelector:@selector(syncFinished:)])
        [self.delegate performSelector:@selector(syncFinished:) withObject:self]; 

}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.incomingData = nil; 

    
    if ([self.delegate respondsToSelector:@selector(syncFinished:)])
        [self.delegate performSelector:@selector(syncFinished:) withObject:self]; 
}







@end
