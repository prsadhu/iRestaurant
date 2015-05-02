//
//  LocationDetails.h
//  FindMeARestaurantN
//
//  Created by Praveen Sadhu on 12/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class Restaurant;

@interface LocationDetails : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate>{

	IBOutlet UIScrollView *scrollView;
	IBOutlet UILabel *lblTitle;
	IBOutlet UILabel *lblAddress;
	IBOutlet UILabel *lblPhone;
	IBOutlet UILabel *lblWebsite;
	IBOutlet UILabel *lblDistance;
	IBOutlet UILabel *lblRating;
	IBOutlet UILabel *lblTotalReviews;

	IBOutlet UIButton *btnDirections;
	IBOutlet UIButton *btnPhone;
	IBOutlet UIButton *btnBrowser;	
	IBOutlet UIButton *btnReadReview;
	IBOutlet UIButton *btnWriteReview;
	
	IBOutlet UITextView *txtReview;
	
	//Rating stars
	IBOutlet UIImageView *star1;
	IBOutlet UIImageView *star2;
	IBOutlet UIImageView *star3;
	IBOutlet UIImageView *star4;
	IBOutlet UIImageView *star5;
	
	Restaurant *details;
	CLLocation *currentLocation;
}

-(void) setDetails:(Restaurant *) restaurant location:(CLLocation *)cLocation;
-(void) showLocationDetails:(Restaurant *) restaurant;
-(void) clearFields;
-(void) showRating:(float) rating totalrating:(int)total_ratings;

-(void) launchBrowser;
-(void) launchDialPad;
-(void) launchDirections; 
-(IBAction) launchExtApp:(UIButton *)sender;
-(void) launchWriteReview;
-(void) launchReadReview;


@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UILabel *lblTitle;
@property (nonatomic, retain) UILabel *lblAddress;
@property (nonatomic, retain) UILabel *lblPhone;
@property (nonatomic, retain) UILabel *lblWebsite;
@property (nonatomic, retain) UILabel *lblDistance;
@property (nonatomic, retain) UILabel *lblRating;
@property (nonatomic, retain) UILabel *lblTotalReviews;
@property (nonatomic, retain) UITextView *txtReview;

@property (nonatomic, retain) UIButton *btnDirections;
@property (nonatomic, retain) UIButton *btnPhone;
@property (nonatomic, retain) UIButton *btnBrowser;
@property (nonatomic, retain) UIButton *btnReadReview;
@property (nonatomic, retain) UIButton *btnWriteReview;

@property (nonatomic, retain) UIImageView *star1;
@property (nonatomic, retain) UIImageView *star2;
@property (nonatomic, retain) UIImageView *star3;
@property (nonatomic, retain) UIImageView *star4;
@property (nonatomic, retain) UIImageView *star5;

@end
