//
//  LocationListView.h
//  FindMeARestaurantN
//
//  Created by Praveen Sadhu on 12/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class LocationDetails;
@class MapViewController;

@interface LocationListView : UITableViewController <UITableViewDataSource>{

	//LocationDetails *locationDetailView;
	NSMutableArray *locations;
	CLLocation *currentLocation;
	MapViewController *mapview;
	IBOutlet UILabel *statusLabel;
	UIView *wait_view;
	UIActivityIndicatorView *spinner;
	
} 

@property (retain, nonatomic) UILabel *statusLabel;

-(IBAction) showOnMap:(id)sender;
-(IBAction) segmentAction:(id)sender;
-(IBAction) checkResultUpdate:(id)sender;

-(void) setData:(NSMutableArray *)location_array Currentlocation:(CLLocation *)cLocation MapView:(MapViewController *)mapView;
-(void) startWaiting;
-(void) stopWaiting;
@end
