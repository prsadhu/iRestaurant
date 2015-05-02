//
//  Restaurants.h
//  FindMeARestaurantN
//
//  Created by Praveen Sadhu on 12/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface Restaurant : NSObject <MKAnnotation> {

	NSString *title;
	NSString *subtitle;
	NSString *address;
	NSString *phone;
	NSString *businessUrl;
	NSString *review;
	NSString *resultId;
	NSString *url;
	
	NSDate *lastReviewDate;
	
	float longitude;
	float latitude;
	float distance;
	float rating;
	
	int total_ratings;
	int total_reviews;
	BOOL isValidRestaurant;
	
	CLLocationCoordinate2D coordinate;
}

-(void) printDetails;
-(void) donePopulating;

@property (nonatomic, copy ) NSString *title;
@property (nonatomic, copy ) NSString *subtitle;
@property (nonatomic, copy ) NSString *address;
@property (nonatomic, copy ) NSString *phone;
@property (nonatomic, copy ) NSString *businessUrl;
@property (nonatomic, copy ) NSString *review;
@property (nonatomic, copy ) NSString *resultId;
@property (nonatomic, copy ) NSString *url;
@property (nonatomic, copy ) NSDate *lastReviewDate;

@property (nonatomic) float longitude;
@property (nonatomic) float latitude;
@property (nonatomic) float rating;
@property (nonatomic) float distance;
@property (nonatomic) BOOL isValidRestaurant;
@property (nonatomic) int total_ratings;
@property (nonatomic) int total_reviews;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end
