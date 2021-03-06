//
//  AppDelegate.m
//  Songhori
//
//  Created by Ali Nouri on 12/2/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "AppDelegate.h"
#import "MapViewController.h"
#import "AccountManager.h"
#import "NewAccountViewControllerViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

-(BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NewAccountViewControllerViewController* ncv = [[NewAccountViewControllerViewController alloc] initWithSourceURL:url.absoluteString]; 
    
    if (!ncv)
        return NO; 
    
    [[self.window rootViewController] presentModalViewController:ncv animated:NO]; 
    [ncv release]; 
    
    return YES; 
}


-(BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self application:application handleOpenURL:url]; 
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil] autorelease];

    
    
    UINavigationController* unc = [[UINavigationController alloc] initWithRootViewController:self.viewController]; 
    
    
    
    self.window.rootViewController = unc;
    [self.window makeKeyAndVisible];
    [unc release]; 
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
    [[AccountManager standardAccountManager] save]; 
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
