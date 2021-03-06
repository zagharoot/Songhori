#import "CalloutMapAnnotationView.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "RestaurantDetailViewController.h"

#define CalloutMapAnnotationViewBottomShadowBufferSize 6.0f
#define CalloutMapAnnotationViewContentHeightBuffer 8.0f
#define CalloutMapAnnotationViewHeightAboveParent 2.0f

@interface CalloutMapAnnotationView()

@property (nonatomic, readonly) CGFloat yShadowOffset;
@property (nonatomic) BOOL animateOnNextDrawRect;
@property (nonatomic) CGRect endFrame;

- (void)prepareContentFrame;
- (void)prepareFrameSize;
- (void)prepareOffset;
- (CGFloat)relativeParentXPosition;
- (void)adjustMapRegionIfNeeded;

@end



@implementation CalloutMapAnnotation

@synthesize latitude = _latitude;
@synthesize longitude = _longitude;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude {
	if (self = [super init]) {
		self.latitude = latitude;
		self.longitude = longitude;
	}
	return self; 
    
}

- (CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = self.latitude;
	coordinate.longitude = self.longitude;
	return coordinate;
}

@end


//--------------------------------------------------------------------------------------

@implementation CalloutContentView
@synthesize restaurant=_restaurant; 
@synthesize logoBtn=_logoBtn; 
@synthesize restaurantDetailBtn=_restaurantDetailBtn; 
@synthesize parent=_parent; 
@synthesize secondaryLogoImageView=_secondaryLogoImageView; 

-(id) initWithRestaurant:(Restaurant *)r andParent:(CalloutMapAnnotationView*) p
{
    self = [super initWithFrame:CGRectZero]; 
    if (self)
    {
        self.parent = p; 
        self.restaurant = r; 
        _nameLabel = [[UILabel alloc] init]; 
        _detailLabel = [[UILabel alloc] init]; 
        self.logoBtn = [UIButton buttonWithType:UIButtonTypeCustom]; 
        self.restaurantDetailBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure]; 
                
        [self addSubview:_nameLabel]; 
        [self addSubview:_detailLabel]; 
        [self addSubview:self.logoBtn];
        [self addSubview:self.restaurantDetailBtn]; 
        
        
        if (r.secondaryLogo != nil) 
        {
            self.secondaryLogoImageView = [[[UIImageView alloc] initWithImage:r.secondaryLogo] autorelease]; 
            [self addSubview:self.secondaryLogoImageView]; 
        }
        
        
        
        _nameLabel.text = r.name; 
        _detailLabel.text = r.detail; 

    
        _nameLabel.backgroundColor = [UIColor clearColor]; 
        _nameLabel.textAlignment = UITextAlignmentLeft;
        _nameLabel.textColor = [UIColor whiteColor]; 
        _nameLabel.font = [UIFont boldSystemFontOfSize:16]; 
        _nameLabel.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin); 
        
        _detailLabel.lineBreakMode = UILineBreakModeWordWrap; 
        _detailLabel.numberOfLines = 0; 
        _detailLabel.backgroundColor = [UIColor clearColor]; 
        _detailLabel.textAlignment = UITextAlignmentLeft; 
        _detailLabel.textColor = [UIColor whiteColor]; 
        _detailLabel.font = [UIFont systemFontOfSize:12]; 
        _detailLabel.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin); 
    }
    return self; 
}

-(void) setRestaurant:(Restaurant *)restaurant
{
    _restaurant = restaurant; 
    _nameLabel.text = restaurant.name; 
    _detailLabel.text = restaurant.detail; 
    
    [self.logoBtn setImage:restaurant.logo forState:UIControlStateNormal]; 
    
    
    if (restaurant.url) 
        [self.logoBtn addTarget:self action:@selector(openRestaurantURL:) forControlEvents:UIControlEventTouchDown]; 

    [self.restaurantDetailBtn addTarget:self action:@selector(openRestaurantDetailPage:) forControlEvents:UIControlEventTouchDown]; 

    
    [self.secondaryLogoImageView removeFromSuperview]; 
    self.secondaryLogoImageView = nil; 
    if (restaurant.secondaryLogo)
    {
        self.secondaryLogoImageView = [[[UIImageView alloc] initWithImage:restaurant.secondaryLogo] autorelease]; 
        [self addSubview:self.secondaryLogoImageView]; 
    }
    
    
    [self setNeedsDisplay]; 
}

-(void) openRestaurantDetailPage:(id) sender 
{
    if (!self.parent)
        return; 
    
    
    RestaurantDetailViewController* rdc = [[RestaurantDetailViewController alloc] initWithRestaurant:self.restaurant]; 
    
    [self.parent.navigationController pushViewController:rdc animated:YES]; 

    [rdc release]; 
}



-(void) openRestaurantURL:(id) sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.restaurant.url]]; 
}


-(void) layoutSubviews
{
    CGRect rect = self.bounds; 
    
    CGRect nameRect = CGRectMake(rect.origin.x+10, rect.origin.y, rect.size.width-20, 25); 
    CGRect detailRect = CGRectMake(rect.origin.x+10, rect.origin.y+17, rect.size.width-50, rect.size.height-30); 
    CGRect logoRect = CGRectMake(rect.origin.x+rect.size.width-30, rect.origin.y, 23, 23); 
    CGRect secondaryLogoRect = CGRectMake(rect.origin.x+rect.size.width-60, rect.origin.y, 23, 23); 
    CGRect detailBtnRect = CGRectMake(rect.origin.x+rect.size.width-35, rect.origin.y + 23+  (rect.size.height -23)/2-15  , 30, 30 ) ; 
    
    
    _nameLabel.frame = nameRect; 
    _detailLabel.frame = detailRect; 
    self.logoBtn.frame = logoRect; 
    
    if (self.secondaryLogoImageView)
        self.secondaryLogoImageView.frame = secondaryLogoRect; 
    
    self.restaurantDetailBtn.frame = detailBtnRect; 
}


-(void) dealloc
{
    [_nameLabel release]; 
    [_detailLabel release]; 
    self.logoBtn = nil;
    self.secondaryLogoImageView = nil; 
    self.restaurantDetailBtn = nil; 
    [super dealloc]; 
}

@end



@implementation CalloutMapAnnotationView

@synthesize parentAnnotationView = _parentAnnotationView;
@synthesize mapView = _mapView;
@synthesize contentView = _contentView;
@synthesize animateOnNextDrawRect = _animateOnNextDrawRect;
@synthesize endFrame = _endFrame;
@synthesize yShadowOffset = _yShadowOffset;
@synthesize offsetFromParent = _offsetFromParent;
@synthesize contentHeight = _contentHeight;
@synthesize navigationController=_navigationController; 

- (id) initWithAnnotation:(id <MKAnnotation>)annotation andParentAnnotationView:(MKAnnotationView *)p reuseIdentifier:(NSString *)reuseIdentifier{
	if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        self.parentAnnotationView = p; 
		self.contentHeight = 80.0;
		self.offsetFromParent = CGPointMake(8, -14); //this works for MKPinAnnotationView
		self.enabled = NO;
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}


-(void) setParentAnnotationView:(MKAnnotationView *)parentAnnotationView
{
//    [_parentAnnotationView release]; 
    _parentAnnotationView = parentAnnotationView; 
    
    ((CalloutContentView*) _contentView).restaurant = parentAnnotationView.annotation; 
    
}


- (void)setAnnotation:(id <MKAnnotation>)annotation {
	[super setAnnotation:annotation];
	[self prepareFrameSize];
	[self prepareOffset];
	[self prepareContentFrame];
	[self setNeedsDisplay];
}

- (void)prepareFrameSize {
	CGRect frame = self.frame;
	CGFloat height =	self.contentHeight +
	CalloutMapAnnotationViewContentHeightBuffer +
	CalloutMapAnnotationViewBottomShadowBufferSize -
	self.offsetFromParent.y;
	
	frame.size = CGSizeMake(self.mapView.frame.size.width, height);
	self.frame = frame;
}

- (void)prepareContentFrame {
	CGRect contentFrame = CGRectMake(self.bounds.origin.x + 10, 
									 self.bounds.origin.y + 3, 
									 self.bounds.size.width - 20, 
									 self.contentHeight-6);

	self.contentView.frame = contentFrame;
}

- (void)prepareOffset {
	CGPoint parentOrigin = [self.mapView convertPoint:self.parentAnnotationView.frame.origin 
											 fromView:self.parentAnnotationView.superview];
	
	CGFloat xOffset =	(self.mapView.frame.size.width / 2) - 
						(parentOrigin.x + self.offsetFromParent.x);
	
	//Add half our height plus half of the height of the annotation we are tied to so that our bottom lines up to its top
	//Then take into account its offset and the extra space needed for our drop shadow
	CGFloat yOffset = -(self.frame.size.height / 2 + 
						self.parentAnnotationView.frame.size.height / 2) + 
						self.offsetFromParent.y + 
						CalloutMapAnnotationViewBottomShadowBufferSize;
	
//    yOffset += 15; //ALI: this is because we're using the customized pin and not the default pin that comes with google 
//    xOffset -= 7; 
	self.centerOffset = CGPointMake(xOffset, yOffset);
}

//if the pin is too close to the edge of the map view we need to shift the map view so the callout will fit.
- (void)adjustMapRegionIfNeeded {
	//Longitude
	CGFloat xPixelShift = 0;
	if ([self relativeParentXPosition] < 38) {
		xPixelShift = 38 - [self relativeParentXPosition];
	} else if ([self relativeParentXPosition] > self.frame.size.width - 38) {
		xPixelShift = (self.frame.size.width - 38) - [self relativeParentXPosition];
	}
	
	
	//Latitude
	CGPoint mapViewOriginRelativeToParent = [self.mapView convertPoint:self.mapView.frame.origin toView:self.parentAnnotationView];
	CGFloat yPixelShift = 0;
	CGFloat pixelsFromTopOfMapView = -(mapViewOriginRelativeToParent.y + self.frame.size.height - CalloutMapAnnotationViewBottomShadowBufferSize);
	CGFloat pixelsFromBottomOfMapView = self.mapView.frame.size.height + mapViewOriginRelativeToParent.y - self.parentAnnotationView.frame.size.height;
	if (pixelsFromTopOfMapView < 7) {
		yPixelShift = 7 - pixelsFromTopOfMapView;
	} else if (pixelsFromBottomOfMapView < 10) {
		yPixelShift = -(10 - pixelsFromBottomOfMapView);
	}
	
	//Calculate new center point, if needed
	if (xPixelShift || yPixelShift) {
		CGFloat pixelsPerDegreeLongitude = self.mapView.frame.size.width / self.mapView.region.span.longitudeDelta;
		CGFloat pixelsPerDegreeLatitude = self.mapView.frame.size.height / self.mapView.region.span.latitudeDelta;
		
		CLLocationDegrees longitudinalShift = -(xPixelShift / pixelsPerDegreeLongitude);
		CLLocationDegrees latitudinalShift = yPixelShift / pixelsPerDegreeLatitude;
		
		CLLocationCoordinate2D newCenterCoordinate = {self.mapView.region.center.latitude + latitudinalShift, 
			self.mapView.region.center.longitude + longitudinalShift};
		
		[self.mapView setCenterCoordinate:newCenterCoordinate animated:YES];
		
		//fix for now
		self.frame = CGRectMake(self.frame.origin.x - xPixelShift,
								self.frame.origin.y - yPixelShift,
								self.frame.size.width, 
								self.frame.size.height);
		//fix for later (after zoom or other action that resets the frame)
		self.centerOffset = CGPointMake(self.centerOffset.x - xPixelShift, self.centerOffset.y);
	}
}

- (CGFloat)xTransformForScale:(CGFloat)scale {
	CGFloat xDistanceFromCenterToParent = self.endFrame.size.width / 2 - [self relativeParentXPosition];
	return (xDistanceFromCenterToParent * scale) - xDistanceFromCenterToParent;
}

- (CGFloat)yTransformForScale:(CGFloat)scale {
	CGFloat yDistanceFromCenterToParent = (((self.endFrame.size.height) / 2) + self.offsetFromParent.y + CalloutMapAnnotationViewBottomShadowBufferSize + CalloutMapAnnotationViewHeightAboveParent);
	return yDistanceFromCenterToParent - yDistanceFromCenterToParent * scale;
}

- (void)animateIn {
	self.endFrame = self.frame;
	CGFloat scale = 0.001f;
	self.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, [self xTransformForScale:scale], [self yTransformForScale:scale]);
	[UIView beginAnimations:@"animateIn" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.075];
	[UIView setAnimationDidStopSelector:@selector(animateInStepTwo)];
	[UIView setAnimationDelegate:self];
	scale = 1.1;
	self.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, [self xTransformForScale:scale], [self yTransformForScale:scale]);
	[UIView commitAnimations];
}

- (void)animateInStepTwo {
	[UIView beginAnimations:@"animateInStepTwo" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.1];
	[UIView setAnimationDidStopSelector:@selector(animateInStepThree)];
	[UIView setAnimationDelegate:self];
	
	CGFloat scale = 0.95;
	self.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, [self xTransformForScale:scale], [self yTransformForScale:scale]);
	
	[UIView commitAnimations];
}

- (void)animateInStepThree {
	[UIView beginAnimations:@"animateInStepThree" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.075];
	
	CGFloat scale = 1.0;
	self.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, [self xTransformForScale:scale], [self yTransformForScale:scale]);
	
	[UIView commitAnimations];
}

- (void)didMoveToSuperview {
	[self adjustMapRegionIfNeeded];
	[self animateIn];
}

- (void)drawRect:(CGRect)rect {
	CGFloat stroke = 1.0;
	CGFloat radius = 7.0;
	CGMutablePathRef path = CGPathCreateMutable();
	UIColor *color;
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGFloat parentX = [self relativeParentXPosition];
	
	//Determine Size
	rect = self.bounds;
	rect.size.width -= stroke + 14;
	rect.size.height -= stroke + CalloutMapAnnotationViewHeightAboveParent - self.offsetFromParent.y + CalloutMapAnnotationViewBottomShadowBufferSize;
	rect.origin.x += stroke / 2.0 + 7;
	rect.origin.y += stroke / 2.0;
	
	//Create Path For Callout Bubble
	CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + radius);
	CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - radius);
	CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, 
				 radius, M_PI, M_PI / 2, 1);
	CGPathAddLineToPoint(path, NULL, parentX - 15, 
						 rect.origin.y + rect.size.height);
	CGPathAddLineToPoint(path, NULL, parentX, 
						 rect.origin.y + rect.size.height + 15);
	CGPathAddLineToPoint(path, NULL, parentX + 15, 
						 rect.origin.y + rect.size.height);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - radius, 
						 rect.origin.y + rect.size.height);
	CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, 
				 rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + radius);
	CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, 
				 radius, 0.0f, -M_PI / 2, 1);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + radius, rect.origin.y);
	CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + radius, radius, 
				 -M_PI / 2, M_PI, 1);
	CGPathCloseSubpath(path);
	
	//Fill Callout Bubble & Add Shadow
	color = [[UIColor blackColor] colorWithAlphaComponent:.6];
	[color setFill];
	CGContextAddPath(context, path);
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, CGSizeMake (0, self.yShadowOffset), 6, [UIColor colorWithWhite:0 alpha:.5].CGColor);
	CGContextFillPath(context);
	CGContextRestoreGState(context);
	
	//Stroke Callout Bubble
	color = [[UIColor darkGrayColor] colorWithAlphaComponent:.9];
	[color setStroke];
	CGContextSetLineWidth(context, stroke);
	CGContextSetLineCap(context, kCGLineCapSquare);
	CGContextAddPath(context, path);
	CGContextStrokePath(context);
	
	//Determine Size for Gloss
	CGRect glossRect = self.bounds;
	glossRect.size.width = rect.size.width - stroke;
	glossRect.size.height = 28; // (rect.size.height - stroke) / 2;
	glossRect.origin.x = rect.origin.x + stroke / 2;
	glossRect.origin.y += rect.origin.y + stroke / 2;
	
	CGFloat glossTopRadius = radius - stroke / 2;
	CGFloat glossBottomRadius = radius / 1.5;
	
	//Create Path For Gloss
	CGMutablePathRef glossPath = CGPathCreateMutable();
	CGPathMoveToPoint(glossPath, NULL, glossRect.origin.x, glossRect.origin.y + glossTopRadius);
	CGPathAddLineToPoint(glossPath, NULL, glossRect.origin.x, glossRect.origin.y + glossRect.size.height - glossBottomRadius);
	CGPathAddArc(glossPath, NULL, glossRect.origin.x + glossBottomRadius, glossRect.origin.y + glossRect.size.height - glossBottomRadius, 
				 glossBottomRadius, M_PI, M_PI / 2, 1);
	CGPathAddLineToPoint(glossPath, NULL, glossRect.origin.x + glossRect.size.width - glossBottomRadius, 
						 glossRect.origin.y + glossRect.size.height);
	CGPathAddArc(glossPath, NULL, glossRect.origin.x + glossRect.size.width - glossBottomRadius, 
				 glossRect.origin.y + glossRect.size.height - glossBottomRadius, glossBottomRadius, M_PI / 2, 0.0f, 1);
	CGPathAddLineToPoint(glossPath, NULL, glossRect.origin.x + glossRect.size.width, glossRect.origin.y + glossTopRadius);
	CGPathAddArc(glossPath, NULL, glossRect.origin.x + glossRect.size.width - glossTopRadius, glossRect.origin.y + glossTopRadius, 
				 glossTopRadius, 0.0f, -M_PI / 2, 1);
	CGPathAddLineToPoint(glossPath, NULL, glossRect.origin.x + glossTopRadius, glossRect.origin.y);
	CGPathAddArc(glossPath, NULL, glossRect.origin.x + glossTopRadius, glossRect.origin.y + glossTopRadius, glossTopRadius, 
				 -M_PI / 2, M_PI, 1);
	CGPathCloseSubpath(glossPath);
	
	//Fill Gloss Path	
	CGContextAddPath(context, glossPath);
	CGContextClip(context);
	CGFloat colors[] =
	{
		1, 1, 1, .3,
		1, 1, 1, .1,
	};
	CGFloat locations[] = { 0, 1.0 };
	CGGradientRef gradient = CGGradientCreateWithColorComponents(space, colors, locations, 2);
	CGPoint startPoint = glossRect.origin;
	CGPoint endPoint = CGPointMake(glossRect.origin.x, glossRect.origin.y + glossRect.size.height);
	CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
	
	//Gradient Stroke Gloss Path	
	CGContextAddPath(context, glossPath);
	CGContextSetLineWidth(context, 2);
	CGContextReplacePathWithStrokedPath(context);
	CGContextClip(context);
	CGFloat colors2[] =
	{
		1, 1, 1, .3,
		1, 1, 1, .1,
		1, 1, 1, .0,
	};
	CGFloat locations2[] = { 0, .1, 1.0 };
	CGGradientRef gradient2 = CGGradientCreateWithColorComponents(space, colors2, locations2, 3);
	CGPoint startPoint2 = glossRect.origin;
	CGPoint endPoint2 = CGPointMake(glossRect.origin.x, glossRect.origin.y + glossRect.size.height);
	CGContextDrawLinearGradient(context, gradient2, startPoint2, endPoint2, 0);
	    
    
	//Cleanup
	CGPathRelease(path);
	CGPathRelease(glossPath);
	CGColorSpaceRelease(space);
	CGGradientRelease(gradient);
	CGGradientRelease(gradient2);
}

- (CGFloat)yShadowOffset {
	if (!_yShadowOffset) {
		float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
		if (osVersion >= 3.2) {
			_yShadowOffset = 6;
		} else {
			_yShadowOffset = -6;
		}
		
	}
	return _yShadowOffset;
}

- (CGFloat)relativeParentXPosition {
	CGPoint parentOrigin = [self.mapView convertPoint:self.parentAnnotationView.frame.origin 
											 fromView:self.parentAnnotationView.superview];
	return parentOrigin.x + self.offsetFromParent.x;
}

- (UIView *)contentView {
	if (!_contentView) {
		_contentView = [[CalloutContentView alloc] initWithRestaurant:self.parentAnnotationView.annotation andParent:self]; 
		self.contentView.backgroundColor = [UIColor clearColor];
		self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		[self addSubview:self.contentView];
	}
	return _contentView;
}

- (void)dealloc {
	self.parentAnnotationView = nil;
	self.mapView = nil;
	[_contentView release];
    [super dealloc];
}

@end