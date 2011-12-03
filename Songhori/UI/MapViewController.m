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

#import "ClusterAnnotationView.h"


#define BASE_URL @"http://www.foodnetwork.com/local/search/cxfDispatcher/foodLocalMapSearch?"

@implementation MapViewController
@synthesize locateMeBtn;
@synthesize myMapView;
@synthesize redoSearchBtn;
@synthesize searchActivityIndicator;
@synthesize locateMeActivityIndicator;

@synthesize urlConnection=_urlConnection; 
@synthesize incomingData=_incomingData; 
@synthesize calloutAnnotation=_calloutAnnotation; 
@synthesize selectedAnnotationView=_selectedAnnotationView; 

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


-(NSURL*) url
{
    MKCoordinateRegion region = self.myMapView.region; 

    CLLocationDegrees uplat =  region.center.latitude + region.span.latitudeDelta/2.0; 
    CLLocationDegrees leftlon = region.center.longitude - region.span.longitudeDelta/2.0; 
    CLLocationDegrees downlat = region.center.latitude - region.span.latitudeDelta/2.0; 
    CLLocationDegrees rightlon = region.center.longitude + region.span.longitudeDelta/2.0; 
    
    int zoomLevel = [self.myMapView zoomLevel]; 
    
    NSString* str = [NSString stringWithFormat:@"%@uplat=%lf&leftlon=%lf&downlat=%lf&rightlon=%lf&level=%d&show=The+Best+Thing+I+Ever+Ate&_1316992333468=", BASE_URL, uplat, leftlon, downlat, rightlon, zoomLevel]; 
    
    NSURL* result = [NSURL URLWithString:str]; 
    
    return result; 
    
}


-(void) setup
{
//    self.url = [NSURL URLWithString:@"http://www.foodnetwork.com/local/search/cxfDispatcher/foodLocalMapSearch?uplat=44.901874642580324&leftlon=-95.33265788750003&downlat=35.137067071169525&rightlon=-53.057267262500034&level=5&show=The+Best+Thing+I+Ever+Ate&_1316992333468="]; 
    
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
    self.incomingData = nil; 
    
    [self.myMapView removeAnnotations:restaurants]; 
    [self.searchActivityIndicator startAnimating]; 
    
    
    request = [[NSMutableURLRequest alloc] initWithURL:self.url cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeoutInterval:60]; 
    
    //set parameters of the request except for the body: 
    [request setHTTPMethod:@"GET"]; 
    
    self.urlConnection = [NSURLConnection connectionWithRequest:request delegate:self]; 
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
                UIImage *asynchronyLogo = [UIImage imageNamed:@"asynchrony-logo-small.png"];
                UIImageView *asynchronyLogoView = [[[UIImageView alloc] initWithImage:asynchronyLogo] autorelease];
                asynchronyLogoView.frame = CGRectMake(5, 2, asynchronyLogoView.frame.size.width, asynchronyLogoView.frame.size.height);
//                [calloutMapAnnotationView.contentView addSubview:asynchronyLogoView];
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
    if ([self interpretIncomingData:self.incomingData])
    {                
//        [self.delegate detailDataBecameAvailable]; 
        //TODO: update the map 
        
    }else
    {
        //this is the error case 
    }
}




-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.incomingData = nil; 
    [self.searchActivityIndicator stopAnimating]; 
    
}

-(BOOL) interpretIncomingData:(NSData *)data
{
    //return NO; 
    
    //    
        NSString* datastr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; 
        NSLog(@"received data as %@\n", datastr); 
        
      
    
    
       //use the data and extract the array of pictureID's
        
        SBJsonParser* parser = [[SBJsonParser alloc] init]; 
        
        parser.maxDepth = 4; 
        
        NSDictionary* d1 = [parser objectWithData:data]; 
        
        if (d1 == nil) { NSLog(@"the data from webservice was not formatted correctly"); return NO;}
    
    
    NSArray* locations = [d1 objectForKey:@"locations"]; 
    NSArray* clusters= [d1 objectForKey:@"locationClusters"]; 

    
    [restaurants removeAllObjects]; 

    if (clusters.count>0)       //we are showing clusters (do we also show individuals? because they are in the data)
    {
        for (NSArray* item in clusters) {
            RestaurantCluster* r = [[RestaurantCluster alloc] initWithJSONData:item]; 
            [restaurants addObject:r]; 
            
            [myMapView addAnnotation:r]; 
            
            [r release]; 
        }
    }else           //only working with individual restaurants
    {
        for (NSArray* item in locations) {
            Restaurant* r = [[FNRestaurant alloc] initWithJSONData:item]; 
            [restaurants addObject:r]; 
            
            [myMapView addAnnotation:r]; 
            
            [r release]; 
        }
    }

    //adjust other stuff 
    self.redoSearchBtn.hidden = YES; 
    [self.searchActivityIndicator stopAnimating]; 
    return YES; 
}




- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if (self.calloutAnnotation == nil) 
			self.calloutAnnotation = [[CalloutMapAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude
																	   andLongitude:view.annotation.coordinate.longitude];
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
