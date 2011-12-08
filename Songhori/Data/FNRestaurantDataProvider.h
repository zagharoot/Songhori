//
//  FNRestaurantDataProvider.h
//  Songhori
//
//  Created by Ali Nouri on 12/8/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h" 


@interface FNRestaurantDataProvider : NSObject
{
    id<RestaurantDataDelegate> _delegate; 
    MKCoordinateRegion selectedRegion; 
    
        NSMutableURLRequest* _request; 
        NSMutableData* _incomingData; 
        NSURLConnection* _urlConnection; 
    
    
}

-(void) sendRestaurantsInRegion:(MKCoordinateRegion) region zoomLevel:(int) zoomLevel; 
-(NSURL*) urlForRegion:(MKCoordinateRegion) region zoomLevel:(int) zoom; 


@property (nonatomic, assign) id<RestaurantDataDelegate> delegate; //we send array of FNRestaurant which is good for annotation  

@property (nonatomic, retain) NSURLConnection* urlConnection; 
@property (nonatomic, retain) NSMutableData* incomingData; 
@property (nonatomic, retain) NSMutableURLRequest* request; 

@end
