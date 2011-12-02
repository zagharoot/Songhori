//
//  AppDelegate.h
//  Songhori
//
//  Created by Ali Nouri on 12/2/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapViewController; 

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MapViewController* viewController;

@end
