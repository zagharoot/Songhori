//
//  ZSPinAnnotation.m
//  ZSPinAnnotation
//
//  Created by Nicholas Hubbard on 12/6/11.
//  Copyright (c) 2011 Zed Said Studio. All rights reserved.
//

#import "IconizedAnnotationView.h"


@implementation IconizedAnnotationView

/**
 * Draw the pin
 *
 * @version $Revision: 0.1
 */
+ (UIImage *)pinAnnotationWithIcon:(UIImage *)img {
	
	
	// Annotation Pin
	UIImage *stick = [UIImage imageNamed:@"stick.png"];
	
	// Start new graphcs context
	UIGraphicsBeginImageContextWithOptions(stick.size, NO, [UIScreen mainScreen].scale ); 
	
	CGRect rectFull = CGRectMake(0, 0, stick.size.width, stick.size.height);
	
    CGRect rectTop = CGRectMake(0, 0, img.size.width, img.size.height); 
    
	// Draw icon
	[img drawInRect:rectTop];
	
	// Draw Stick
	[stick drawInRect:rectFull];
	
	UIImage *pinImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// End
    UIGraphicsEndImageContext();
    
    //return the image
    return pinImage;
	
}//end


@end
