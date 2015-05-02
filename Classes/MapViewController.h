//
//  MapViewController.h
//  FindMeARestaurantN
//
//  Created by Praveen Sadhu on 12/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


#define ICON_BIG_CIRCLE @"big-circle.png"
#define ICON_SMALL_CIRCLE @"small-circle.png"
//#define ICON_LIST @"list.png"
//#define ICON_PREV_RESULT @"prev_arrow.png"
//#define ICON_NEXT_RESULT @"next_arrow.png"
#define ICON_LIST @"list_50x50.png"
#define ICON_PREV_RESULT @"back_arrow.png"
#define ICON_NEXT_RESULT @"more_arrow.png"


@class Restaurant;
@class LocationDetails;
@class LocationDataList;

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {

	IBOutlet UILabel *statusLabel;
	IBOutlet MKMapView *map;
	IBOutlet UIActivityIndicatorView *activityView;
	IBOutlet UIView *working_view;
	
	CLLocationManager *locMan;
	CLLocation *currentLocation;
	NSString *queryStr;
	NSString *searchTerm; //Exact search term used by the user

	//Current query
	//NSString *cqueryStr;
	NSMutableData *queryResponse;
	//NSSet *reqTags;
	NSString *curElement;
	
	NSMutableArray *pins;
	NSMutableArray *pins_tmp;
	Restaurant *tmpRestaurant;
	NSArray *validation_categories;
	
	//cursor for results
	int start;
	int curr_start;
	int RESULT_SIZE;
	BOOL working;
	BOOL newQuery;
	
	NSString *searchLoc;
	BOOL localSearch;
	
	LocationDataList *locationList;
	NSURLConnection *m_connection;
	
	
	//COunter for timeout check
	int check_counter;
}

//-(IBAction) nextResults:(id)sender;
//-(IBAction) prevResults:(id)sender;
-(IBAction) segmentAction:(id)sender;
-(IBAction) checkResultUpdate:(id)sender;

- (void) setQueryString:(NSString *)query searchFor:(NSString *)searchKey  atlocation:(NSString *)queryLoc;
- (void) setCurrentLocation:(CLLocation *)location;
- (void) fetchRestaurants:(CLLocation *)newLocation;
- (void) startParsingResult;
- (void) clearAnnotations;
- (void) showAlert:(NSString *)title :(NSString *) message;
- (void) showCallout:(int)index;
- (BOOL) isValidRestaurant:(NSString *) cat;
- (void) getNextResultSet;
- (void) getPrevResultSet;
- (BOOL) isWorking;
- (void) startWorking;
- (void) stopWorking;
- (void) addLocationsToMap:(NSArray *)locations; 


@property (retain, nonatomic) UILabel *statusLabel;
@property (retain, nonatomic) UIView *working_view;
@property (retain, nonatomic) UIActivityIndicatorView *activityView;
@property (retain, nonatomic) MKMapView *map;
@property (retain, nonatomic) NSString *queryStr;
@property (retain, nonatomic) NSString *searchTerm;
@property (retain, nonatomic) CLLocationManager *locMan;
@property (retain, nonatomic) CLLocation *currentLocation;
@property (retain, nonatomic) NSString *searchLoc;

@property (nonatomic, retain) NSMutableArray *pins;
@property (nonatomic) BOOL  working;
@property (nonatomic) int  curr_start;

@end
