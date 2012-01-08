//
//  Restaurant.h
//  FoodNetworkLocal
//
//  Created by Ali Nouri on 9/25/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

//Any object that needs to be notified for a search result should use this. 
//various classes in the hierarchy use this approach. therefore, the result array might have different 
//types of objects in them according to what class is sending the message to us. 
@protocol RestaurantDataDelegate <NSObject>
-(void) restaudantDataDidBecomeAvailable:(NSArray*) restaurants forRegion:(MKCoordinateRegion) region fromProvider:(id) provider; 

@optional
-(void) allDataForRequestSent;      //this is called when all the data for a particular request has been sent (useful when the source is collecting data from multiple places) 
-(void) syncFinished:(id) provider;               //this is called when all the sync activity is finished. 
@end



@interface Restaurant : NSObject <MKAnnotation>
{
@protected
    NSString* _name; 
    NSString* _detail; 
    NSString* _url;                         //this url will open more info about the restaurant
    UIColor* _pinColor;     

    CLLocationCoordinate2D __coordinate; 
    
}

-(UIImage*) logo; 

@property (nonatomic, copy) NSString* name; 
@property (nonatomic, copy) NSString* detail; 
@property (nonatomic, copy) NSString* url; 
@property (nonatomic ,retain) UIColor* pinColor; 
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

-(id) initWithJSONData:(id) json; 

-(void) loadSpecialty;

@property (nonatomic, copy) NSString* specialty; 

@property (nonatomic, retain) NSURLConnection* urlConnection; 
@property (nonatomic, retain) NSMutableData* incomingData; 


@end


/*
@interface YelpRestaurant : Restaurant {
@private

}

@end

*/



@interface RestaurantCluster : Restaurant
{    
    int _count; 
}

-(id) initWithJSONData:(id) json; 

@property  int count; 

@end

