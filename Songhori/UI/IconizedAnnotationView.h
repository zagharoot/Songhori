//
//  IconizedAnnotationView.h
//  Songhori
//
//  Created by Ali Nouri on 3/9/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface IconizedAnnotationView : MKAnnotationView  <MKAnnotation> 
{
    
    
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end
