//
//  ViewController.h
//  FoodNetworkLocal
//
//  Created by Ali Nouri on 9/25/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CalloutMapAnnotationView.h"
#import "AccountManager.h"
#import "Restaurant.h" 
#import "GCDiscreetNotificationView.h" 


@interface MapViewController : UIViewController <MKMapViewDelegate, RestaurantDataDelegate> 
{
    BOOL centerOnUserFlag;              //should we center the map at user location or not
    NSURL* _url; 
    
    NSMutableArray* restaurants;        //this is the array of annotation objects 
        
	CalloutMapAnnotation *_calloutAnnotation;
	MKAnnotationView *_selectedAnnotationView;
    
    AccountManager* accountManager; 
    
        
    GCDiscreetNotificationView* _notificationView; 
}

-(void) setup; 
- (IBAction)reloadData:(id)sender;
- (IBAction)locateMe:(id)sender;
- (IBAction)openSettingPage:(id)sender;

@property (retain, nonatomic) IBOutlet UIButton *loadSettingsPage;

@property (retain, nonatomic) IBOutlet UIButton *locateMeBtn;

@property (retain, nonatomic) IBOutlet MKMapView *myMapView;
@property (retain, nonatomic) IBOutlet UIButton *redoSearchBtn;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *searchActivityIndicator;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *locateMeActivityIndicator;

@property (nonatomic, retain) MKAnnotationView *selectedAnnotationView;
@property (nonatomic, retain) CalloutMapAnnotation* calloutAnnotation; 
@property (nonatomic, retain) GCDiscreetNotificationView*  notificationView; 

@end
