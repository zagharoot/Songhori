//
//  IconizedAnnotationView.m
//  Songhori
//
//  Created by Ali Nouri on 3/9/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import "IconizedAnnotationView.h"

@implementation IconizedAnnotationView

@synthesize coordinate;

- (id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if ( self )
    {
    
    }
    return self;
}

- (void) setClusterText:(NSString *)text
{
}

- (void) dealloc
{
    [super dealloc];
}

@end
