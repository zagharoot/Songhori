

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ClusterAnnotationView : MKAnnotationView <MKAnnotation> {
    UILabel *label;
}
- (void) setClusterText:(NSString *)text;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@end
