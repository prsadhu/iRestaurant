//
//  LocationListView.m
//  FindMeARestaurantN
//
//  Created by Praveen Sadhu on 12/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LocationListView.h"
#import "LocationListCell.h"
#import "LocationDetails.h"
#import "MapViewController.h"

@implementation LocationListView

@synthesize statusLabel;

//Action fot segment control 
-(IBAction) segmentAction:(id)sender {
	
	if( mapview == nil )
	{
		return;	
	}
	//No refresh table

    //Ignore any actions if still working
	if( [mapview isWorking] )
		return;
	
	UISegmentedControl* segCtl = sender ;
	
	if( [segCtl selectedSegmentIndex] == 0 ){
		if( mapview.curr_start <= 1 )
			return;
		[self startWaiting];
		[mapview getPrevResultSet];
	}
	else if( [segCtl selectedSegmentIndex] == 1 ){
		[self startWaiting];
		[mapview getNextResultSet];
	}
	else
		return;
	[self performSelector:@selector(checkResultUpdate:) withObject:@"check" afterDelay:0.3f];
	
	
}

-(IBAction) checkResultUpdate:(id)sender {

	if( [mapview.activityView isAnimating] ){
		[self performSelector:@selector(checkResultUpdate:) withObject:@"check" afterDelay:0.3f];
		return;
	}
	[self.tableView reloadData];
	[self stopWaiting];
	statusLabel.text = mapview.statusLabel.text;

}

- (void)viewDidLoad {
    [super viewDidLoad];
	//  Custom right bar button with a view
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:
											[NSArray arrayWithObjects:
											 [UIImage imageNamed:ICON_PREV_RESULT], 											 
											 [UIImage imageNamed:ICON_NEXT_RESULT],																				 
											 
											 nil]];
	
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.frame = CGRectMake(0, 0, 120, 42);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	
	segmentedControl.momentary = YES;
	
	UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
	[segmentedControl release];
	
	
	self.navigationItem.rightBarButtonItem = segmentBarItem;
	[segmentBarItem release];
	
	wait_view = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,1250)];
	[wait_view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6] ];
	[self.tableView addSubview:wait_view];
	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	spinner.center = self.tableView.center;
	spinner.hidden = NO;
	wait_view.hidden = YES;
	[wait_view addSubview:spinner];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)startWaiting{
	[spinner startAnimating];
	wait_view.hidden = NO;
	statusLabel.text = @"Fetching data...";	
}

- (void)stopWaiting{
	[spinner stopAnimating];
	wait_view.hidden = YES;
	statusLabel.text = @"";	
}




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	statusLabel.text = mapview.statusLabel.text;
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

-(void) setData:(NSMutableArray *)location_array Currentlocation:(CLLocation *)cLocation MapView:(MapViewController *)mapView
{
	
	locations = location_array;
	//locationDetailView = detailView;	

	if( currentLocation != nil ){
		[currentLocation release];
		currentLocation = nil;
	}
	currentLocation = [cLocation copy];
	mapview = mapView;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if( locations != nil ){
		return [locations count];
	}
	else	
		return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"LocationCustomCellIdentifier";
    
    LocationListCell *cell = (LocationListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LocationListCell" owner:nil options:nil];
		
		for(id currentObject in topLevelObjects)
		{
			if([currentObject isKindOfClass:[LocationListCell class]])
			{
				cell = (LocationListCell *)currentObject;
				break;
			}
		}
    }
    
    // Set up the cell...
	if( locations != nil )
	{
		if( [locations count] > [indexPath row] ){
			[cell setData:(Restaurant *) [locations objectAtIndex:[indexPath row]]];	
			UIButton *btnLeft = cell.leftButton;
			[btnLeft addTarget:self action:@selector(showOnMap:) forControlEvents:UIControlEventTouchUpInside];
			btnLeft.tag = [indexPath row];
		}
		else
			NSLog(@"ERROR: indexPath row is out of bounds");
	}
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // Navigation logic may go here. Create and push another view controller.
	Restaurant *r = nil;
	
	if( locations != nil )
	{
		if( [locations count] > [indexPath row] )
			r = (Restaurant *) [locations objectAtIndex:[indexPath row]];		
		else
			NSLog(@"ERROR: indexPath row is out of bounds");
	}
	if( r != nil && currentLocation != nil)
	{
		LocationDetails	*locationDetailView = [[LocationDetails alloc] initWithNibName:
						@"LocationDetails" bundle:nil];

		[locationDetailView setDetails:r location:currentLocation];
		[self.navigationController pushViewController:
			locationDetailView animated:YES];

		[locationDetailView release];
	}

	
}


-(IBAction) showOnMap:(UIButton *)sender {
	[mapview showCallout:sender.tag];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
	
	[currentLocation release];
	[spinner release];
	[wait_view release];
    [super dealloc];

}


@end

