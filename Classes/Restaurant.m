//
//  Restaurants.m
//  FindMeARestaurantN
//
//  Created by Praveen Sadhu on 12/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Restaurant.h"


@implementation Restaurant

@synthesize title;
@synthesize subtitle;
@synthesize address;
@synthesize phone;
@synthesize businessUrl;
@synthesize review;
@synthesize resultId;
@synthesize url;
@synthesize lastReviewDate;

@synthesize longitude;
@synthesize latitude;
@synthesize rating;
@synthesize distance;
@synthesize coordinate;
@synthesize isValidRestaurant;
@synthesize total_ratings;
@synthesize total_reviews;

-(void) printDetails{

	NSLog(@"Title=%@,\n Address=%@,\n phone=%@,\n long=%f,\n lat=%f,\n rating=%f,\n dist=%f", title, address, phone, longitude, latitude, rating, distance);

}

//Perform post population processing
-(void) donePopulating{
	
	coordinate.latitude = self.latitude;
	coordinate.longitude = self.longitude;
	subtitle = [[NSString alloc] initWithFormat:@"(%0.1f mi) - %@", distance, address];
}


-(void) dealloc {

	[title release];
	[subtitle release];
	[address release];
	[phone release];
	[businessUrl release];
	[review release];
	[resultId release];
	[lastReviewDate release];

	[super dealloc];
}

@end
