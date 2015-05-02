//
//  FlipsideViewController.m
//  fliptest
//
//  Created by Praveen Sadhu on 1/23/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "FlipsideViewController.h"
#import "FlipsideView.h"
#import "FindMeARestaurantNViewController.h";

@implementation FlipsideViewController

@synthesize delegate;


-(IBAction) hideKeyboard{
	FlipsideView *fview = (FlipsideView *)self.view;
	[fview.txtLocationBox resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];      
}


- (IBAction)done {
	
	FlipsideView *fview = (FlipsideView *)self.view;
	FindMeARestaurantNViewController *mainView = (FindMeARestaurantNViewController *)self.delegate;
	
	[mainView setSearchLocation:fview.txtLocationBox.text];
	[self.delegate flipsideViewControllerDidFinish:self];	
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

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
    [super dealloc];
}


@end
