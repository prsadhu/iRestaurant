//
//  LocationDetails.m
//  FindMeARestaurantN
//
//  Created by Praveen Sadhu on 12/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LocationDetails.h"
#import "Restaurant.h"

@implementation LocationDetails

@synthesize scrollView;
@synthesize lblTitle, lblAddress, lblPhone, lblWebsite, lblDistance, txtReview, lblRating, lblTotalReviews;
@synthesize star1, star2, star3, star4, star5;
@synthesize btnDirections, btnPhone, btnBrowser, btnReadReview, btnWriteReview;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	//Set button IDs
	btnDirections.tag = 1;
	btnPhone.tag = 2;
	btnBrowser.tag = 3;	
	btnReadReview.tag = 5;
	btnWriteReview.tag = 4;
	
	scrollView.contentSize = CGSizeMake(320, 760);
	[scrollView flashScrollIndicators];	
	[self showLocationDetails:details];
	[lblAddress resignFirstResponder];
	[lblPhone resignFirstResponder];
	[lblWebsite resignFirstResponder];
	
}

- (void) viewDidAppear:(BOOL)animated{

	[self.scrollView flashScrollIndicators];	
}

-(void) setDetails:(Restaurant *) restaurant location:(CLLocation *) cLocation {

	details = restaurant; 
	if( currentLocation != nil ){
		[currentLocation release];
		currentLocation = nil;
	}
	currentLocation = [cLocation copy];
}

-(void) showLocationDetails:(Restaurant *) restaurant {

	[self clearFields];
	
	NSString *tmpText = nil;
	
	if( restaurant != nil ){
		if( restaurant.title != nil ){
			tmpText  = [[NSString alloc] initWithString:restaurant.title];
			lblTitle.text = tmpText;
			[tmpText release];
		}
		
		if( restaurant.address != nil ){
			NSRange idx = [restaurant.address rangeOfString:@"," options:NSBackwardsSearch ];
			idx = [restaurant.address rangeOfString:@"," options:NSBackwardsSearch 
						   range:NSMakeRange(0, idx.location) ];
			idx.length++;
			tmpText = [[NSString alloc] initWithString:[restaurant.address 
														stringByReplacingOccurrencesOfString:@", " 
														withString:@",\n" 
														options:NSBackwardsSearch
														range:idx]];
			lblAddress.text = tmpText;
			[tmpText release];
		}
		
		if( restaurant.phone != nil ){
			tmpText = [[NSString alloc] initWithString:restaurant.phone];
			lblPhone.text = tmpText;
			[tmpText release];
		}
		
		tmpText = [[NSString alloc] initWithFormat:@"%0.2f miles", restaurant.distance]; 
		lblDistance.text = tmpText;
		[tmpText release];
		
		if( restaurant.businessUrl != nil ){
			tmpText = [[NSString alloc] initWithString:restaurant.businessUrl];
			lblWebsite.text = tmpText;
			[tmpText release];
		}
		
		NSString *tmp;
		if( restaurant.total_reviews == 0 )
		{
			tmp = @"No reviews found";
		}
		else {
			tmp = [[NSString alloc] initWithFormat:@"Latest review from %d total review(s):", 
									restaurant.total_reviews];
		}
		lblTotalReviews.text = tmp;
		[tmp release];
		
		if( restaurant.review != nil ){
			NSString *formattedDateString = @"";
			
			if( restaurant.lastReviewDate != nil ){
				NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
				[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
				[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
				formattedDateString = [dateFormatter stringFromDate:restaurant.lastReviewDate];
			}
			tmpText = [[NSString alloc] initWithFormat:@"(%@) %@", formattedDateString, restaurant.review];
			txtReview.text = tmpText;
			[tmpText release];

		}
		
		//Set the rating
		[self showRating:restaurant.rating totalrating:restaurant.total_ratings];
	}
 
}

-(void) clearFields{
	
	lblTitle.text = @"";
	lblAddress.text = @"";
	lblPhone.text = @"";
	lblWebsite.text = @""; 
	lblDistance.text = @"";
	lblRating.text = @"";
	txtReview.text = @"";
	
	[star1 setImage:[UIImage imageNamed:@"star-gold24-bw.png"]];
	[star2 setImage:[UIImage imageNamed:@"star-gold24-bw.png"]];
	[star3 setImage:[UIImage imageNamed:@"star-gold24-bw.png"]];
	[star4 setImage:[UIImage imageNamed:@"star-gold24-bw.png"]];
	[star5 setImage:[UIImage imageNamed:@"star-gold24-bw.png"]];
	 
}

-(void) showRating:(float) rating totalrating:(int)total_ratings{

	NSString *tmp;
	if( total_ratings == 0 )
	{
			tmp = [[NSString alloc] initWithString:@"No ratings found"];
	}
	else {
		tmp = [[NSString alloc] initWithFormat:@"%0.1f from %d ratings", rating, total_ratings];
	}
	lblRating.text = tmp;
	[tmp release];

	
	if( rating <= 0 )
		return;
	
	if( rating >= 1 ){
		[star1 setImage:[UIImage imageNamed:@"star-gold24.png"]];
		if( rating == 1 ) return;
	}
	else{
		[star1 setImage:[UIImage imageNamed:@"half-star-gold24.png"]];
		return;
	}
	
	if( rating >= 2 ){
		[star2 setImage:[UIImage imageNamed:@"star-gold24.png"]];
		if( rating == 2 ) return;
	}
	else{
		[star2 setImage:[UIImage imageNamed:@"half-star-gold24.png"]];
		return;
	}

	if( rating >= 3 ){
		[star3 setImage:[UIImage imageNamed:@"star-gold24.png"]];
		if( rating == 3 )	return;
	}
	else{
		[star3 setImage:[UIImage imageNamed:@"half-star-gold24.png"]];
		return;
	}
	
	if( rating >= 4 ){
		[star4 setImage:[UIImage imageNamed:@"star-gold24.png"]];
		if( rating == 4 ) return;
	}
	else{
		[star4 setImage:[UIImage imageNamed:@"half-star-gold24.png"]];
		return;
	}
	
	if( rating >= 5 )
		[star5 setImage:[UIImage imageNamed:@"star-gold24.png"]];
	else{
		[star5 setImage:[UIImage imageNamed:@"half-star-gold24.png"]];
		return;
	}
	
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	NSLog([actionSheet title]);

	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 1)
	{
		if( [[actionSheet title] isEqualToString:@"Directions"] )
			[self launchDirections];
		else if( [[actionSheet title] isEqualToString:@"Phone"] )
			[self launchDialPad];
		else if( [[actionSheet title] isEqualToString:@"Browse"] )
			[self launchBrowser];
		else if( [[actionSheet title] isEqualToString:@"Review"] )
			[self launchWriteReview];
		else if( [[actionSheet title] isEqualToString:@"Read More Reviews"] )
			[self launchReadReview];
	
	}
}

-(IBAction) launchExtApp:(UIButton *)sender {
	
	NSString *msg = nil;
	NSString *title = nil;
	if( sender.tag == btnDirections.tag )
	{
		if( details.address != nil ){
			title = [NSString stringWithString:@"Directions"]; 
			msg = [NSString stringWithString:@"Get directions to this place?"];
		}
	}
	else if(sender.tag == btnPhone.tag )
	{
		if( details.phone != nil ){
			title = [NSString stringWithString:@"Phone"]; 
			msg = [NSString stringWithString:@"Call this place?"];		
		}
	}
	else if(sender.tag == btnBrowser.tag )
	{
		if( details.businessUrl != nil ){
			title = [NSString stringWithString:@"Browse"]; 
			msg = [NSString stringWithString:@"Browse the website?"];				
		}
	} 
	else if(sender.tag == btnWriteReview.tag )
	{
		title = [NSString stringWithString:@"Review"]; 
		msg = [NSString stringWithString:@"Do you want to write a review on Yahoo! (closes this app)?"];				
	} 
	else if(sender.tag == btnReadReview.tag )
	{
		if( details.url != nil && details.total_reviews != 0 )
		{
			title = [NSString stringWithString:@"Read More Reviews"]; 
			msg = [NSString stringWithString:@"Do you want to read more reviews on Yahoo! (closes this app)?"];				
		}
		else
		{
			UIAlertView *alert = 
			[[[UIAlertView alloc] initWithTitle:@"No reviews found" 
										message:@"Unable to find more reviews"
									   delegate:self 
							  cancelButtonTitle:nil 
							  otherButtonTitles:@"OK", nil] autorelease];
			[alert show];
			return;	
		}
			
	} 
	
	if( msg != nil ){
	
		NSLog( msg );
		UIAlertView *alert = 
		[[[UIAlertView alloc] initWithTitle:title 
								message:msg
							   delegate:self 
					  cancelButtonTitle:@"Cancel" 
					  otherButtonTitles:@"OK", nil] autorelease];
		[alert show];
	}
	
}
	
-(void) launchBrowser {

	if( details.businessUrl == nil )
		return;
	
	NSString *urlString = details.businessUrl;
	if( ![urlString isEqual:@""] ){
		NSURL *url = [NSURL URLWithString:urlString];
		if( [[UIApplication sharedApplication] canOpenURL:url] == YES)
			[[UIApplication sharedApplication] openURL:url];
		else{
			UIAlertView *alert = 
			[[[UIAlertView alloc] initWithTitle:@"Cannot open" 
										message:@"Oops! Unable to open maps for directions." 
									   delegate:self 
							  cancelButtonTitle:@"OK" 
							  otherButtonTitles:nil] autorelease];
			[alert show];
		}
	}
}

-(void) launchDirections {
	
	if( details.address == nil || currentLocation == nil)
		return;
	NSLog( details.address);	
	NSMutableString *urlString = [[[NSMutableString alloc] initWithString:@"http://maps.google.com/maps?daddr="] autorelease];
	
	//Encode Address
	[urlString appendString:[details.address stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
	[urlString appendFormat:@"&saddr=%.3f,%.3f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude];
	[urlString appendFormat:@"&ll=%.3f,%.3f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude];	
	if( ![urlString isEqual:@""] ){
		NSURL *url = [NSURL URLWithString:urlString];
		if( [[UIApplication sharedApplication] canOpenURL:url] == YES)
			[[UIApplication sharedApplication] openURL:url];
		else{
			UIAlertView *alert = 
			[[[UIAlertView alloc] initWithTitle:@"Cannot open" 
										message:@"Oops! Unable to open maps for directions." 
									   delegate:self 
							  cancelButtonTitle:@"OK" 
							  otherButtonTitles:nil] autorelease];
			[alert show];
		}
	}
}

-(void) launchDialPad {

	NSString *urlString = [[[NSString alloc] initWithFormat:@"tel:%@", details.phone] autorelease];
	
	urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
	urlString = [urlString stringByReplacingOccurrencesOfString:@"(" withString:@""];
	urlString = [urlString stringByReplacingOccurrencesOfString:@")" withString:@""];
	urlString = [urlString stringByReplacingOccurrencesOfString:@"-" withString:@""];

	NSLog( urlString );
	NSURL *url = [NSURL URLWithString:urlString] ;
	if( [[UIApplication sharedApplication] canOpenURL:url] == YES)
		[[UIApplication sharedApplication] openURL:url];
	else{
		UIAlertView *alert = 
		[[[UIAlertView alloc] initWithTitle:@"Cannot open" 
									message:@"Oops! Unable to open phone pad." 
								   delegate:self 
						  cancelButtonTitle:@"OK" 
						  otherButtonTitles:nil] autorelease];
		[alert show];
	}

}

-(void) launchWriteReview {
	
	if( details.resultId == nil )
		return;
	
	NSString *urlString = [[NSString alloc] initWithFormat:@"http://local.yahoo.com/reviews?id=%@", details.resultId];
	if( ![urlString isEqual:@""] ){
		NSURL *url = [NSURL URLWithString:urlString];
		if( [[UIApplication sharedApplication] canOpenURL:url] == YES)
			[[UIApplication sharedApplication] openURL:url];
		else{
			UIAlertView *alert = 
			[[[UIAlertView alloc] initWithTitle:@"Cannot open" 
										message:@"Oops! Unable to open browser." 
									   delegate:self 
							  cancelButtonTitle:@"OK" 
							  otherButtonTitles:nil] autorelease];
			[alert show];
		}
	}
}

-(void) launchReadReview {
	
	if( details.resultId == nil )
		return;
	
	NSString *urlString = [[NSString alloc] initWithFormat:details.url];
	if( ![urlString isEqual:@""] ){
		NSURL *url = [NSURL URLWithString:urlString];
		if( [[UIApplication sharedApplication] canOpenURL:url] == YES)
			[[UIApplication sharedApplication] openURL:url];
		else{
			UIAlertView *alert = 
			[[[UIAlertView alloc] initWithTitle:@"Cannot open" 
										message:@"Oops! Unable to open browser." 
									   delegate:self 
							  cancelButtonTitle:@"OK" 
							  otherButtonTitles:nil] autorelease];
			[alert show];
		}
	}
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {

	[lblTitle release];
	[lblAddress release];
	[lblPhone release];
	[lblWebsite release];
	[lblDistance release];
	[lblRating release];
	[lblTotalReviews release];
	
	[btnDirections release];
	[btnPhone release];
	[btnBrowser release];
	
	
	[txtReview release];
	[scrollView release];
	[star1 release];
	[star2 release];
	[star3 release];	
	[star4 release];
	[star5 release];	
	
	[currentLocation release];
	
    [super dealloc];
	
}


@end
