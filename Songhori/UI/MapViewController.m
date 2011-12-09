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



@implementation MapViewController
@synthesize loadSettingsPage;
@synthesize locateMeBtn;
@synthesize myMapView;
@synthesize redoSearchBtn;
@synthesize searchActivityIndicator;
@synthesize locateMeActivityIndicator;

@synthesize calloutAnnotation=_calloutAnnotation; 
@synthesize selectedAnnotationView=_selectedAnnotationView; 

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
    accountManager.fnAccount.active = YES; 
    [accountManager.yelpAccount activateAccount:@"alidoon"]; 
    
    
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
    
    if (! self.myMapView.showsUserLocation || ! self.myMapView.userLocation)
    {
        [locateMeActivityIndicator startAnimating]; 
    }
    
    
    [self.myMapView setShowsUserLocation:YES]; 
    if (!self.myMapView.userLocationVisible && self.myMapView.userLocation)
    {
        [self.myMapView setCenterCoordinate:self.myMapView.userLocation.coordinate zoomLevel:15 animated:YES];         
    }
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup]; 
    [self.myMapView setShowsUserLocation:YES]; 
//    [self.myMapView setCenterCoordinate:self.myMapView.centerCoordinate zoomLevel:10 animated:YES]; 

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setMyMapView:nil];
    [self setRedoSearchBtn:nil];
    [self setSearchActivityIndicator:nil];
    [self setLocateMeBtn:nil];
    [self setLocateMeActivityIndicator:nil];
    [self setLoadSettingsPage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


//load the data for the current view 
-(void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
//    MKCoordinateRegion r =  mapView.region; 
    self.redoSearchBtn.hidden = NO; 
    
    
}


-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [locateMeActivityIndicator stopAnimating]; 
    
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
        annView.canShowCallout = YES;
        
        return annView; 
    } else if ([annotation isKindOfClass:[CalloutMapAnnotation class]])
    {
            CalloutMapAnnotationView *calloutMapAnnotationView = (CalloutMapAnnotationView *)[self.myMapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutAnnotation"];
            if (!calloutMapAnnotationView) 
            {
                calloutMapAnnotationView = [[[CalloutMapAnnotationView alloc] initWithAnnotation:annotation andParentAnnotationView:self.selectedAnnotationView  
                                                                                 reuseIdentifier:@"CalloutAnnotation"] autorelease];
                calloutMapAnnotationView.contentHeight = 120.0f;
            }
            calloutMapAnnotationView.parentAnnotationView = self.selectedAnnotationView;
            calloutMapAnnotationView.mapView = self.myMapView;
            return calloutMapAnnotationView;
    }else if ([annotation isKindOfClass:[FNRestaurant class]])
    {
		MKPinAnnotationView *annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation 
																			   reuseIdentifier:@"FNRestaurant"] autorelease];
		annotationView.canShowCallout = NO;
		annotationView.pinColor = MKPinAnnotationColorPurple; 
		return annotationView;
    }else if ([annotation isKindOfClass:[YelpRestaurant class]])
    {
		MKPinAnnotationView *annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation 
																			   reuseIdentifier:@"YelpRestaurant"] autorelease];
		annotationView.canShowCallout = NO;
		annotationView.pinColor = MKPinAnnotationColorGreen;
		return annotationView;
    }
    
    return nil; 
}


- (void)dealloc {
    [myMapView release];
    [_url release]; 
    [restaurants release]; 
    [redoSearchBtn release];
    [searchActivityIndicator release];
    [locateMeBtn release];
    [locateMeActivityIndicator release];
    
    self.calloutAnnotation = nil; 
    [loadSettingsPage release];
    [super dealloc];
}



-(void) restaudantDataDidBecomeAvailable:(NSArray *)items forRegion:(MKCoordinateRegion)region fromProvider:(id)provider
{
    for (Restaurant* r in items) {
        [restaurants addObject:r]; 
        [myMapView addAnnotation:r]; 
    }    
}


-(void) allDataForRequestSent
{
    self.redoSearchBtn.hidden = YES; 
    [self.searchActivityIndicator stopAnimating]; 
}




- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
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


@end
