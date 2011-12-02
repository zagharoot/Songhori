//
//  Restaurant.h
//  FoodNetworkLocal
//
//  Created by Ali Nouri on 9/25/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Restaurant : NSObject <MKAnnotation>
{
@protected
    NSString* _title; 
    NSString* _subtitle; 
    
    CLLocationCoordinate2D __coordinate; 
    
}

-(id) initWithJSONData:(id) json; 

@end


@interface FNRestaurant : Restaurant {
@private
    NSString* _specialtyURL; 
    NSString* _specialty; 
    
    
    //ivars necessary for retrieving and managing the detail data 
    NSMutableURLRequest* request; 
    NSMutableData* _incomingData; 
    NSURLConnection* _urlConnection; 
    
    
}


-(void) loadSpecialty;

@property (nonatomic, copy) NSString* specialty; 

@property (nonatomic, retain) NSURLConnection* urlConnection; 
@property (nonatomic, retain) NSMutableData* incomingData; 


@end



@interface YelpRestaurant : Restaurant {
@private

}

@end





@interface RestaurantCluster : Restaurant
{    
    int _count; 
}


@property (readonly) int count; 

@end

