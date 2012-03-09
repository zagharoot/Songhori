//
//  ViewController.m
//  FoodNetworkLocal
//
//  Created by Ali Nouri on 9/25/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "MapViewController.h"
#import "JSON.h"
#import "Restaurant.h" 
#import "MKMapView+ZoomLevel.h"
#import "CalloutMapAnnotationView.h"
#import "YelpRestaurant.h" 
#import "ClusterAnnotationView.h"
#import <MapKit/MapKit.h>
#import "AccountsUIViewController.h" 
#import "GoogleMapRestaurant.h"
#import "ZSPinAnnotation.h"

#import "RestaurantDetailViewController.h"      //TODO: remove this 

@implementation MapViewController
@synthesize loadSettingsPage;
@synthesize locateMeBtn;
@synthesize myMapView;
@synthesize redoSearchBtn;
@synthesize searchActivityIndicator;
@synthesize locateMeActivityIndicator;

@synthesize calloutAnnotation=_calloutAnnotation; 
@synthesize selectedAnnotationView=_selectedAnnotationView; 
@synthesize notificationView=_notificationView; 



-(GCDiscreetNotificationView*) notificationView
{
    if (!_notificationView)
        _notificationView = [[GCDiscreetNotificationView alloc] initWithText:@"" 
                                                           showActivity:YES
                                                     inPresentationMode:GCDiscreetNotificationViewPresentationModeTop 
                                                                 inView:self.view];
     
    return _notificationView; 
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}




-(void) setup
{
//    self.url = [NSURL URLWithString:@"http://www.foodnetwork.com/local/search/cxfDispatcher/foodLocalMapSearch?uplat=44.901874642580324&leftlon=-95.33265788750003&downlat=35.137067071169525&rightlon=-53.057267262500034&level=5&show=The+Best+Thing+I+Ever+Ate&_1316992333468="]; 

    
    accountManager = [AccountManager standardAccountManager]; 
    accountManager.delegate = self; 
    
    
    //default to zoom on USA 
    MKCoordinateRegion r; 
    r.center.latitude = 39.909736234535558; 
    r.center.longitude= -100.283203125; 
    r.span.latitudeDelta = 30.888717143368858; 
    r.span.longitudeDelta = 28.125; 
    
    myMapView.region = r; 
    
    
    restaurants = [[NSMutableArray alloc] initWithCapacity:100]; 
    centerOnUserFlag = YES; 
    self.searchActivityIndicator.hidesWhenStopped = YES; 
    
}


- (IBAction)reloadData:(id)sender {    
    [self.myMapView removeAnnotations:restaurants]; 
    [self.searchActivityIndicator startAnimating]; 
    
    [restaurants removeAllObjects]; 
    [accountManager sendRestaurantsInRegion:self.myMapView.region zoomLevel:[self.myMapView zoomLevel]]; 
    
}

- (IBAction)locateMe:(id)sender {
    centerOnUserFlag = YES;   
    
    if (! self.myMapView.userLocation)
    {
        [locateMeActivityIndicator startAnimating]; 
        [self.locateMeBtn setImage:[UIImage imageNamed:@"locateMeButtonBusy.png"] forState:UIControlStateNormal]; 
    }else {
        [self.locateMeBtn setImage:[UIImage imageNamed:@"locateMeButton.png"] forState:UIControlStateNormal]; 
        [self.locateMeBtn setNeedsDisplay]; 
    }
    
    
//    if (!self.myMapView.userLocationVisible && self.myMapView.userLocation)
    if (self.myMapView.userLocation) 
    {
        [self.myMapView setCenterCoordinate:self.myMapView.userLocation.coordinate zoomLevel:15 animated:YES];         
    }
}

- (IBAction)openSettingPage:(id)sender 
{
    AccountsUIViewController* ac = [[AccountsUIViewController alloc] initWithNibName:@"AccountsUIViewController" bundle:[NSBundle mainBundle]]; 

    [self.navigationController pushViewController:ac animated:YES]; 

    [ac release]; 
    
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup]; 
    [self.myMapView setShowsUserLocation:YES]; 
//    [self.myMapView setCenterCoordinate:self.myMapView.centerCoordinate zoomLevel:10 animated:YES]; 

	// Do any additional setup after loading the view, typically from a nib.
    
    if ([accountManager syncData]) 
    {
        self.notificationView.textLabel = @"Updating data..."; 
        [self.notificationView setShowActivity:YES animated:YES]; 
        [self.notificationView show:YES]; 
    }


}

- (void)viewDidUnload
{
    
    self.calloutAnnotation = nil; 
    [loadSettingsPage release];
    
    [self setMyMapView:nil];
    [self setRedoSearchBtn:nil];
    [self setSearchActivityIndicator:nil];
    [self setLocateMeBtn:nil];
    [self setLocateMeActivityIndicator:nil];
    [self setLoadSettingsPage:nil];
    [self setNotificationView:nil] ; 
    
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];         //we don't show the navigation in this view
    [super viewWillAppear:animated];
    
    //set the text of search button accordingly
    
    if ([accountManager hasAnyActiveAccount])
    {
        [self.redoSearchBtn setEnabled:YES]; 
        [self.redoSearchBtn setTitle:@"Redo the Search" forState:UIControlStateNormal];
        self.redoSearchBtn.alpha = 1.0; 
    }else {
        [self.redoSearchBtn setEnabled:NO]; 
        [self.redoSearchBtn setTitle:@"No Restaurant Source" forState:UIControlStateNormal]; 
        self.redoSearchBtn.alpha = 0.6; 
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[AccountManager standardAccountManager] save]; 
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark- mapview delegate methods 

-(void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    MKCoordinateRegion r =  mapView.region; 
    NSLog(@"new region %f,%f,%f,%f\n", r.center.latitude, r.center.longitude, r.span.latitudeDelta, r.span.longitudeDelta ); 
    self.redoSearchBtn.hidden = NO; 
    [self.redoSearchBtn setNeedsDisplay]; 
    
}


-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{    
    [self.locateMeActivityIndicator stopAnimating]; 
    [self.locateMeBtn setImage:[UIImage imageNamed:@"locateMeButton.png"] forState:UIControlStateNormal]; 
    
    if (centerOnUserFlag) 
    {
        [self.myMapView setCenterCoordinate:self.myMapView.userLocation.location.coordinate zoomLevel:15 animated:YES];  
        centerOnUserFlag = NO; 
    }
}


-(MKAnnotationView*) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{

/*    if([annotation class] == MKUserLocation.class) {
		//userLocation = annotation;
		return nil;
	}
*/    
    
    if( [annotation isKindOfClass:[RestaurantCluster class]])
    {
        MKAnnotationView *annView;
        RestaurantCluster* cluster = (RestaurantCluster*) annotation; 
        
        
        annView = (ClusterAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"cluster"];
        
        if( !annView )
            annView = (ClusterAnnotationView*)[[[ClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"cluster"] autorelease];
        
        annView.image = [UIImage imageNamed:@"cluster.png"];
        [(ClusterAnnotationView*)annView setClusterText:[NSString stringWithFormat:@"%i",cluster.count]];
        annView.canShowCallout = NO;
        
        
        return annView; 
    } else if ([annotation isKindOfClass:[CalloutMapAnnotation class]])
    {        
            //if the selected item is not restaurant, just return 
            if (![self.selectedAnnotationView isKindOfClass:[MKAnnotationView class]])
                return nil;  
            CalloutMapAnnotationView *calloutMapAnnotationView = (CalloutMapAnnotationView *)[self.myMapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutAnnotation"];
            if (!calloutMapAnnotationView) 
            {
                calloutMapAnnotationView = [[[CalloutMapAnnotationView alloc] initWithAnnotation:annotation andParentAnnotationView:self.selectedAnnotationView  
                                                                                 reuseIdentifier:@"CalloutAnnotation"] autorelease];
                calloutMapAnnotationView.contentHeight = 120.0f;
                calloutMapAnnotationView.navigationController = self.navigationController; 
            }
            calloutMapAnnotationView.parentAnnotationView = self.selectedAnnotationView;
            calloutMapAnnotationView.mapView = self.myMapView;
            return calloutMapAnnotationView;
    }
//    else if ([annotation isKindOfClass:[Restaurant class]])
//    {
//        static NSString *defaultPinID = @"StandardIdentifier";
//        MKAnnotationView *pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
//        if (pinView == nil){
//            pinView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
//            //pinView.animatesDrop = YES;
//        }
//
//		Restaurant *a = (Restaurant *)annotation;
//		pinView.image = [ZSPinAnnotation pinAnnotationWithColor:a.pinColor];// ZSPinAnnotation Being Used
//		pinView.annotation = a;
//		pinView.enabled = YES;
//		pinView.calloutOffset = CGPointMake(-11,0);
//        pinView.canShowCallout = NO; 
//        
//        return pinView; 
//    }
    
    
    else if ([annotation isKindOfClass:[FNRestaurant class]])
    {
		MKPinAnnotationView *annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation 
																			   reuseIdentifier:@"FNRestaurant"] autorelease];
		annotationView.canShowCallout = NO;
		annotationView.pinColor = MKPinAnnotationColorPurple; 
		return annotationView;
    }else if ([annotation isKindOfClass:[YelpRestaurantAnnotation class]])
    {
		MKPinAnnotationView *annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation 
																			   reuseIdentifier:@"YelpRestaurant"] autorelease];
		annotationView.canShowCallout = NO;
		annotationView.pinColor = MKPinAnnotationColorRed;
		return annotationView;
    }else if ([annotation isKindOfClass:[GoogleMapRestaurantAnnotation class]])
    {
		MKPinAnnotationView *annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation 
																			   reuseIdentifier:@"GoogleMapRestaurant"] autorelease];
		annotationView.canShowCallout = NO;
		annotationView.pinColor = MKPinAnnotationColorGreen; 
		return annotationView;
    }

    
    return nil; 
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
NSLog(@" selected frame (%f,%f,%f,%f)\n", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height); 

    
    if (self.calloutAnnotation == nil) 
        self.calloutAnnotation = [[[CalloutMapAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude
                                                                    andLongitude:view.annotation.coordinate.longitude] autorelease];
    else
    {
        self.calloutAnnotation.latitude = view.annotation.coordinate.latitude; 
        self.calloutAnnotation.longitude = view.annotation.coordinate.longitude; 
    }
    
    [self.myMapView addAnnotation:self.calloutAnnotation];
    self.selectedAnnotationView = view;
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    [self.myMapView removeAnnotation: self.calloutAnnotation];
}

#pragma mark- restaurandt delegate methods 

-(void) restaudantDataDidBecomeAvailable:(NSArray *)items forRegion:(MKCoordinateRegion)region fromProvider:(id)provider
{
    for (Restaurant* r in items) {
        [restaurants addObject:r]; 
        [myMapView addAnnotation:r]; 
    }    
}

//at this point, the provider is always the account manager
-(void) allDataForRequestSent:(id) provider 
{
    self.redoSearchBtn.hidden = YES; 
    [self.searchActivityIndicator stopAnimating]; 
    
    //no results found
    if (restaurants.count==0)
    {
        self.notificationView.textLabel = @"No results found!"; 
        self.notificationView.showActivity = NO; 
        [self.notificationView showAndDismissAfter:3]; 
    }
}


-(void) syncFinished:(id)provider
{
    [self.notificationView setTextLabel:@"Completed!" andSetShowActivity:NO animated:NO]; 
    [self.notificationView hideAnimatedAfter:1]; 
}




@end
