#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Restaurant.h" 


// This class is pretty much useless. It is used only as a trick to show the callout for other annotations.
// only one exist at a time. 
@interface CalloutMapAnnotation : NSObject <MKAnnotation> {
	CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
    
}

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;
@end


//-----------------------------------------------------
// This is the view we use as the callout for restaurants 

@interface CalloutMapAnnotationView : MKAnnotationView {
	MKAnnotationView *_parentAnnotationView;
	MKMapView *_mapView;
	CGRect _endFrame;
	UIView *_contentView;
	CGFloat _yShadowOffset;
	CGPoint _offsetFromParent;
	CGFloat _contentHeight;
    
    UINavigationController* _navigationController; 
    
}

@property (nonatomic, assign) MKAnnotationView *parentAnnotationView;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic) CGPoint offsetFromParent;
@property (nonatomic) CGFloat contentHeight;
@property (nonatomic, assign) UINavigationController* navigationController; 

- (id) initWithAnnotation:(id <MKAnnotation>)annotation andParentAnnotationView:(MKAnnotationView*) p reuseIdentifier:(NSString *)reuseIdentifier; 

- (void)animateIn;
- (void)animateInStepTwo;
- (void)animateInStepThree;
@end


//-------------------------------------------------------
// This is the view we use inside the callout to show content
@interface CalloutContentView : UIView {
    Restaurant* _restaurant; 
    UILabel* _nameLabel; 
    UILabel* _detailLabel; 
    UIButton* _logoBtn; 
    UIButton* _restaurantDetailBtn; 
    
    CalloutMapAnnotationView* _parent; 
}

-(id) initWithRestaurant:(Restaurant*) r andParent:(CalloutMapAnnotationView*) p;

-(void) openRestaurantURL:(id) sender; 
-(void) openRestaurantDetailPage:(id) sender; 

@property (nonatomic, assign) Restaurant* restaurant; 
@property (nonatomic, retain) UIButton* logoBtn; 
@property (nonatomic, retain) UIButton* restaurantDetailBtn; 

@property (nonatomic, assign) CalloutMapAnnotationView* parent; 
@end





