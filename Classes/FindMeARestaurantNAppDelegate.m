//
//  FindMeARestaurantNAppDelegate.m
//  FindMeARestaurantN
//
//  Created by Praveen Sadhu on 12/20/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "FindMeARestaurantNAppDelegate.h"
#import "FindMeARestaurantNViewController.h"

@implementation FindMeARestaurantNAppDelegate

@synthesize window;
//@synthesize viewController;
@synthesize navigationController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    

	[window addSubview:[navigationController view]];

    [window makeKeyAndVisible];
}


- (void)dealloc {

	[navigationController release];

    [window release];
    [super dealloc];
}


@end
