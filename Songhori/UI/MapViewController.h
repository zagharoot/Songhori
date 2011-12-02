//
//  ViewController.h
//  FoodNetworkLocal
//
//  Created by Ali Nouri on 9/25/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface MapViewController : UIViewController <MKMapViewDelegate>
{
    BOOL centerOnUserFlag;              //should we center the map at user location or not
    NSURL* _url; 
    
    NSMutableArray* restaurants; 
    
    //ivars necessary for retrieving and managing the detail data 
    NSMutableURLRequest* request; 
    NSMutableData* _incomingData; 
    NSURLConnection* _urlConnection; 
    
}

-(void) setup; 
-(BOOL) interpretIncomingData:(NSData*) data; 
- (IBAction)reloadData:(id)sender;
- (IBAction)locateMe:(id)sender;

@property (retain, nonatomic) IBOutlet UIButton *locateMeBtn;

@property (retain, nonatomic) IBOutlet MKMapView *myMapView;
@property (retain, nonatomic) IBOutlet UIButton *redoSearchBtn;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *searchActivityIndicator;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *locateMeActivityIndicator;

@property (retain, nonatomic, readonly) NSURL* url; 
@property (nonatomic, retain) NSURLConnection* urlConnection; 
@property (nonatomic, retain) NSMutableData* incomingData; 

@end
