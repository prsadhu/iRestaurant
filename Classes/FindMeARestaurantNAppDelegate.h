//
//  FindMeARestaurantNAppDelegate.h
//  FindMeARestaurantN
//
//  Created by Praveen Sadhu on 12/20/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FindMeARestaurantNViewController;

@interface FindMeARestaurantNAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    //FindMeARestaurantNViewController *viewController;
	UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
//@property (nonatomic, retain) IBOutlet FindMeARestaurantNViewController *viewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;


@end

