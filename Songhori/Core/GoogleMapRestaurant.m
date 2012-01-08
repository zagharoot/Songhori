//
//  GoogleMapRestaurant.m
//  Songhori
//
//  Created by Ali Nouri on 1/2/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import "GoogleMapRestaurant.h"
#import "GoogleMapList.h"


@implementation GoogleMapRestaurant
@synthesize annotation=_annotation; 


@dynamic name;
@dynamic longitude;
@dynamic latitude;
@dynamic desc;
@dynamic account;


-(GoogleMapRestaurantAnnotation*) annotation
{
    if (!_annotation)
    {
        _annotation = [[GoogleMapRestaurantAnnotation alloc] initWithGoogleMapRestaurant:self]; 
    }
    
    return _annotation; 
}

@end


static UIImage* GoogleLogo; 

@implementation GoogleMapRestaurantAnnotation
@synthesize restaurant=_restaurant; 


-(UIColor*) pinColor
{
    return [UIColor greenColor]; 
}


-(id) initWithGoogleMapRestaurant:(GoogleMapRestaurant *)r
{
self = [super init]; 
if (self) 
{
    _restaurant = r;    //this is an assign, so never release
    
    __coordinate.latitude = r.latitude; 
    __coordinate.longitude = r.longitude; 
}
    return self; 
}



-(NSString*) name
{
    return self.restaurant.name; 
}


-(UIImage*) logo
{
    if (!GoogleLogo)
{
    GoogleLogo = [[UIImage imageNamed:@"GoogleLogo.png"] retain]; 
}

return GoogleLogo; 
}




-(NSString*) detail
{
    return self.restaurant.desc; 
}


-(void) dealloc
{

    [super dealloc]; 
}



@end