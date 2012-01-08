//
//  Account.m
//  rlimage
//
//  Created by Ali Nouri on 7/2/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "Account.h"

@implementation Account

@synthesize delegate=_delegate; 
@synthesize info=_info; 

-(void) setActive:(BOOL)active
{
    
}

-(BOOL) active
{
    return NO; 
}


-(void) restaudantDataDidBecomeAvailable:(NSArray *)restaurants forRegion:(MKCoordinateRegion)region fromProvider:(id)provider
{
    //each account should implement their own 
}

-(void) sendRestaurantsInRegion:(MKCoordinateRegion)region zoomLevel:(int)zoomLevel
{
    //each account should implement their own
}


-(void) save
{
    //each account should implement their own if they respond to this
}

-(BOOL) syncData
{
    return NO; 
}

-(UIImage*) logoImage
{
    if (_logoImage != nil)
        return _logoImage; 
        
    
    //first time use, create it: 
    NSString* path = [NSString stringWithFormat:@"%@TableCell", self.accountName ]; 
    _logoImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path ofType:@"png"]]; 
    
    return _logoImage; 
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


-(void) didReceiveMemoryWarning
{
    _logoImage = nil;       //we can lazily recreate this later! 
}


-(NSString*) accountName
{
    return @"No Account"; 
}


-(BOOL) isActive
{
    return NO; 
}

-(BOOL) isDeletable
{
    return NO; 
}

@end


@implementation DynamicAccount

-(BOOL) isDeletable
{
    return YES; 
}

-(void) deleteAccount
{
}


@end



