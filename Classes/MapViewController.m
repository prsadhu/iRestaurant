//
//  MapViewController.m
//  FindMeARestaurantN
//
//  Created by Praveen Sadhu on 12/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "Restaurant.h"
#import "LocationDetails.h"
#import "LocationListView.h"
#import "LocationDataList.h"

#define REQ_XML_TAG_NAMES @"Result" , @"Title" , nil

@implementation MapViewController

@synthesize statusLabel;
@synthesize map;
@synthesize queryStr;
@synthesize locMan;
@synthesize currentLocation;

@synthesize pins;
@synthesize activityView;
@synthesize searchTerm;
@synthesize working;
@synthesize working_view;
@synthesize curr_start;
@synthesize searchLoc;

//*****************************************************************
//
//BEGIN: HTTP connection methods
//
//*****************************************************************
-(void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response 
{
	[queryResponse setLength:0];
}


//Deletegate method for conection
-(void)connection:(NSURLConnection *)connection
				didReceiveData:(NSData *)data 
{
	if( data != nil )
		[queryResponse appendData:data];

	//[connection cancel];

}


//Failed with error
-(void)connection:(NSURLConnection *)connection
			didFailWithError:(NSError *)error
{
	
    // release the connection, and the data object
	start = curr_start;
    [connection release];
	connection = nil;
    // receivedData is declared as a method instance elsewhere
    [queryResponse release];

    // inform the user	
	[self showAlert:@"Connection failed!" :@"Error in fetching information."];
	[self stopWorking];
}


- (void) connectionDidFinishLoading: (NSURLConnection*) connection 
{
	[self startParsingResult];
	[connection release];
	connection = nil;
}

//*****************************************************************
//
//BEGIN: XML parsing methods
//
//*****************************************************************
- (void) startParsingResult {
	
	NSXMLParser *rParser = [[NSXMLParser alloc] initWithData:queryResponse] ;
	rParser.delegate = self;
	
	if( [rParser parse] ){
		//If no result data is found, show a dialog to inform user
		if( [pins_tmp count] == 0 )
		{
			[self showAlert:@"No Results Found"  :@"Oops! No results found." ];
		}
		else{
			[self addLocationsToMap:pins_tmp];
			[pins_tmp removeAllObjects];

		}	
	}
	else{
		[self showAlert:@"Parsing error" :@"Oops! Sorry, got error in parsing data."];
		start= curr_start;
	}
	 
	[rParser release];

    [queryResponse release];
	[self stopWorking];

}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
		//Start parsing doc	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
				namespaceURI:(NSString *)namespaceURI
				qualifiedName:(NSString *)qualifiedName
				attributes:(NSDictionary *)attributeDict {

	if ([elementName isEqualToString:@"Result" ]) {

		tmpRestaurant = [[Restaurant alloc] init];
		if( [attributeDict valueForKey:@"id"] != nil)
			tmpRestaurant.resultId = [attributeDict valueForKey:@"id"];
		
	}
	else if( [elementName isEqualToString:@"ResultSet" ]) {
		
		if( [attributeDict valueForKey:@"totalResultsAvailable"] != nil){
			locationList.totalResultsAvailable = [[attributeDict valueForKey:@"totalResultsAvailable"] intValue];
			
			//Limit to 250 (Yahoo result limitation
			locationList.totalResultsAvailable = 
						(locationList.totalResultsAvailable > 250) ? 250 : locationList.totalResultsAvailable;
				
		}
	}

	[curElement = [elementName copy] autorelease];
	 
}	

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
					namespaceURI:(NSString *)namespaceURI
					qualifiedName:(NSString *)qualifiedName{

	if ([elementName isEqualToString:@"Result" ]) {

		[tmpRestaurant donePopulating];
		//Add it to cache
		[locationList addLocation:tmpRestaurant];
		//[tmpRestaurant printDetails];
		[pins_tmp addObject:tmpRestaurant];
	}
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
		 
	if( [curElement isEqualToString:@"Title"] ){
		tmpRestaurant.title = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	}
	else if( [curElement isEqualToString:@"Address"] ){
		tmpRestaurant.address = string;
	}
	else if( [curElement isEqualToString:@"City"] ){
		tmpRestaurant.address = [tmpRestaurant.address stringByAppendingString:@", "];
		tmpRestaurant.address = [tmpRestaurant.address stringByAppendingString:string];
	}
	else if( [curElement isEqualToString:@"State"] ){
		tmpRestaurant.address = [tmpRestaurant.address stringByAppendingString:@", "];
		tmpRestaurant.address = [tmpRestaurant.address stringByAppendingString:string];
	}	
	else if( [curElement isEqualToString:@"Phone"] ){
		tmpRestaurant.phone = string;
	}	
	else if( [curElement isEqualToString:@"Latitude"] ){
		tmpRestaurant.latitude = [string floatValue];
	}
	else if( [curElement isEqualToString:@"Longitude"] ){
		tmpRestaurant.longitude = [string floatValue];
	}
	else if( [curElement isEqualToString:@"Distance"] ){
		//NSLog(@"distance = %@ %f %d", string, [string floatValue], (int)[string floatValue]);
		tmpRestaurant.distance = [string floatValue];
	}
	else if( [curElement isEqualToString:@"AverageRating"] ){
		tmpRestaurant.rating = [string floatValue];
	}
	else if( [curElement isEqualToString:@"BusinessUrl"] ){
		tmpRestaurant.businessUrl = string;
	}
	else if( [curElement isEqualToString:@"LastReviewIntro"] ){
		tmpRestaurant.review = string;
	}
	else if( [curElement isEqualToString:@"LastReviewDate"] ){
		tmpRestaurant.lastReviewDate = [NSDate dateWithTimeIntervalSince1970:[string longLongValue]] ;
	}
	else if( [curElement isEqualToString:@"Category"] ){		
		
		//Yahoo returns bogus results, so we need this
		if( !tmpRestaurant.isValidRestaurant )
			tmpRestaurant.isValidRestaurant = [self isValidRestaurant:string];
	}
	else if( [curElement isEqualToString:@"TotalRatings"] ){
		tmpRestaurant.total_ratings = [string intValue];
	}
	else if( [curElement isEqualToString:@"TotalReviews"] ){
		tmpRestaurant.total_reviews = [string intValue];
	}
	else if( [curElement isEqualToString:@"Url"] ){
		tmpRestaurant.url = string;
	}
	
	
}

//*****************************************************************
// END: XML parsing methods
//*****************************************************************

-(void) clearAnnotations{
	if( pins )
	{
		[self.map removeAnnotations:pins];		
		[pins removeAllObjects];
	}
	statusLabel.text = @"";
}

//*******************************************
//Location Manager updates
//*******************************************
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {

	if( oldLocation == nil && newLocation != nil ){
		[self fetchRestaurants:newLocation];
	}
	else if( (oldLocation != nil ) && 
			(newLocation != nil) && 
			[newLocation getDistanceFrom:oldLocation] > 3218 ){ //2 miles
		[self fetchRestaurants:newLocation];		
	}
	else
		return;
}	

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
	
    if (error.code == kCLErrorDenied) {
        // Turn of the location manager updates
        [manager stopUpdatingLocation];
        [locMan release];
        locMan = nil;
		[self stopWorking];
		[self showAlert:@"Location error"  :@"There was an error in getting your position. Try re-launching the app and allow it to use location service." ];
    }
}

//*******************************************
//END Location Manager updates
//*******************************************

-(void) fetchRestaurants:(CLLocation *)newLocation{
	
	NSLog( @"queryStr=%@", queryStr );

	if( newLocation == nil )
		return;
	
	[self startWorking];
	//Check if data exists in cache
	[locationList getLocations:pins_tmp startIndex:start windowsize:RESULT_SIZE];
	
	if( [pins_tmp count] > 0 )
	{
		//NSLog(@"Got data from cache" );
		[self addLocationsToMap:pins_tmp];
		[pins_tmp removeAllObjects];
		[self stopWorking];
		
	}
	else
	{
	
	curElement = [[NSString alloc] initWithString:@""];

	
	NSMutableString *urlstr = [[[NSMutableString alloc] initWithString:@"http://local.yahooapis.com/LocalSearchService/V3/localSearch?appid="] autorelease];
    //PUT YAHOO API KEY HERE
	[urlstr appendString:@"<YAHOO API KEY>"];
	
	NSString *latStr = [[NSString alloc] initWithFormat:@"%.3f", newLocation.coordinate.latitude];
	[latStr	stringByReplacingOccurrencesOfString:@"." withString:@"%2e"];
	
	NSString *longStr = [[NSString alloc] initWithFormat:@"%.3f", newLocation.coordinate.longitude];
	[longStr stringByReplacingOccurrencesOfString:@"." withString:@"%2e"];	
	
	if( localSearch )
		[urlstr appendFormat:@"&latitude=%@&longitude=%@",latStr,  longStr];	
	else
		[urlstr appendFormat:@"&location=%@",searchLoc];	
	
	[urlstr appendFormat:@"&start=%d",start];	
	[urlstr appendFormat:@"&results=%d", RESULT_SIZE];	
	
	[urlstr appendFormat:@"&sort=distance&query=restaurant%@",queryStr];
	
	[latStr release];
	[longStr release];
	
	NSLog( urlstr );
	NSURL *url = [NSURL URLWithString:
				  urlstr ];
	
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url
												cachePolicy:NSURLRequestUseProtocolCachePolicy
												timeoutInterval:30.0];

	if( m_connection )
		[m_connection release];
		
	m_connection = [[[NSURLConnection alloc]	initWithRequest:request
											delegate:self] retain];
	if( m_connection )
	{
		queryResponse = [[NSMutableData data] retain] ;
		//Set current query string to new query
		[self performSelector:@selector(checkResultUpdate:) withObject:@"check" afterDelay:1.0f];
	}
	else {
		[self showAlert:@"Connection error" :@"Error in connecting to server"];
		[queryResponse release];
		[m_connection release];
		m_connection = nil;
	}

	[request release];	
	}
	
}

- (void)addLocationsToMap:(NSArray *)locations {
	
	//If you get results, clear annotation, set the start result and add pins
	[self clearAnnotations];
	
	NSMutableArray *tmpLocations = [[NSMutableArray alloc] init];
	Restaurant *r;
	for( r in locations )
	{
		if( r.isValidRestaurant )
			[tmpLocations addObject:r];
		else{
			NSLog(@"INVALID %@", r.title);
		}
	}
	
	curr_start = start;
	if( [searchTerm isEqual:@""]){
		[pins addObjectsFromArray:tmpLocations];
	}
	else{
	
		//Sort and add by title match
		NSString *urlmatch = [[NSString alloc] 
							  initWithString:[searchTerm 
											  stringByReplacingOccurrencesOfString:@" " 
											  withString:@""]];
		
		NSMutableArray *matchedArr = [[NSMutableArray alloc] init];
		NSMutableArray *unmatchedArr = [[NSMutableArray alloc] init];
		for( r in tmpLocations )
		{
			BOOL match = NO;
			if( [r.title  rangeOfString:searchTerm options:NSCaseInsensitiveSearch].length > 0 )
			{
				[matchedArr addObject:r];
				match = YES;
			}
			else if( r.businessUrl != nil )
			{
				NSRange rng1 = [r.businessUrl  rangeOfString:urlmatch options:NSCaseInsensitiveSearch];
				if( rng1.length > 0 )
				{
					[matchedArr addObject:r];
					match = YES;
				}
			}
			
			if( !match ){
				[unmatchedArr addObject:r];
			}
		}
		
		[pins addObjectsFromArray:matchedArr];
		[pins addObjectsFromArray:unmatchedArr];
		[urlmatch release];
		[matchedArr release];
		[unmatchedArr release];
	}

	[map addAnnotations:self.pins];	
	[self setCurrentLocation:locMan.location];	
	//Finally set the status message
	NSString *msg;
	if( [pins count] > 0 )
		msg = [[NSString alloc] initWithFormat:@"Showing results %d to %d from %d", 
					 start, start+[pins count]-1,
					 locationList.totalResultsAvailable]; 
	else
		msg = [[NSString alloc] initWithString:@"No results found"]; 
		
	statusLabel.text = msg;
	[msg release];
	[tmpLocations removeAllObjects];
	[tmpLocations release];	

	//show callout
	if( [pins count] > 0 )
		[map selectAnnotation:[pins objectAtIndex:0] animated:YES];
	newQuery = NO;

}

-(IBAction) checkResultUpdate:(id)sender {

	if( working ){
		[self performSelector:@selector(checkResultUpdate:) withObject:@"check" afterDelay:1.0f];
		check_counter++;
		
		if( check_counter > 32 )
		{
			//reset start
			if( curr_start == 1 )
				curr_start -= RESULT_SIZE;
			start = curr_start;
			[self stopWorking];
			[self showAlert:@"Network error" :@"Timeout occured in fetching results"];
				[m_connection release];
				m_connection = nil;
				[queryResponse release];
			check_counter = 0;
		}
	}
	else {
		check_counter = 0;
	}

}

//Action fot segment control 
-(IBAction) segmentAction:(id)sender {
	
	//Ignore any actions if still working
	if( working )
		return;
	
	UISegmentedControl* segCtl = sender ;

	if( [segCtl selectedSegmentIndex] == 2 ){
		[self getNextResultSet];
	}
	else if( [segCtl selectedSegmentIndex] == 1 ){
		[self getPrevResultSet];
	}
	else if( [segCtl selectedSegmentIndex] == 0 ){
		
		if( [pins count] > 0 )
		{
			//Check if details view is initialized
			LocationListView *lv = [[LocationListView alloc] initWithNibName:
								@"LocationListView" bundle:nil];


			[lv setData:pins Currentlocation:locMan.location MapView:self];

			[self.navigationController pushViewController:
					lv animated:YES];
			[lv release];
		}
	}
	
}

- (void) getNextResultSet
{
	int totalPages = (int)(locationList.totalResultsAvailable/RESULT_SIZE) + (locationList.totalResultsAvailable%RESULT_SIZE>0?1:0);
	int cPage = (int)(start/RESULT_SIZE)+1;

	if( cPage == totalPages ){
		[self showAlert:@"End of list" :@"No more results in this category"];
		return;
	}
		
	if( curr_start < 250 ){
		start= curr_start + RESULT_SIZE;
		[self fetchRestaurants:locMan.location];	
	}	
}

- (void) getPrevResultSet
{
	if( curr_start > 1 ){
		start = curr_start - RESULT_SIZE;
		[self fetchRestaurants:locMan.location];	
	}	
}

- (BOOL) isValidRestaurant:(NSString *) cat
{

	NSString *type;
	for (type in validation_categories){
		NSRange rng = [cat  rangeOfString:type options:NSCaseInsensitiveSearch];
		if( rng.length > 0 )
			return YES;
	}
	return NO;

}

//Show a callout
- (void) showCallout:(int)index
{
	NSLog(@"Clicked on %d", index);
	if( index < [pins count] ){
		Restaurant *r  = [pins objectAtIndex:index];
		CLLocationCoordinate2D loc;
		loc.latitude = r.latitude;
		loc.longitude = r.longitude;
		[map setCenterCoordinate:loc animated:NO];
		[map selectAnnotation:r animated:NO];
	}
}

- (void) setQueryString:(NSString *)query searchFor:(NSString *)searchKey atlocation:(NSString *)queryLoc
{
	newQuery = YES;
	if( queryStr == nil || searchLoc == nil )
		newQuery = YES;
	else if( [query isEqual:queryStr] && [queryLoc isEqual:searchLoc] )
		newQuery = NO;
	
	[queryStr release];
	queryStr = [[NSString alloc] initWithString:query];
	
	[searchTerm release];
	searchTerm = [[NSString alloc] initWithString:searchKey];
	if( [searchTerm isEqual:@"" ])
		RESULT_SIZE = 10;
	else
		RESULT_SIZE = 15;

	//Set query location
	
	if( searchLoc == nil )
	{
		searchLoc = [[NSString alloc] initWithString:@""];
	}		
	if( queryLoc != nil )
	{

		if( ![queryLoc isEqual:searchLoc] )
		{

			if( searchLoc ){
				[searchLoc release];
				searchLoc = nil;
			}
			
			searchLoc = [[NSString alloc] initWithString:queryLoc];

		}
		if( [searchLoc isEqual:@""] )
			localSearch = YES;
		else
			localSearch = NO;
	}
	
	
}
//***************************************************************************************************


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

    [super viewDidLoad];
	
	[self startWorking];
	
	//  Custom right bar button with a view
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:
											[NSArray arrayWithObjects:
											 //[UIImage imageNamed:ICON_SMALL_CIRCLE], 											 
											 //[UIImage imageNamed:ICON_BIG_CIRCLE],																				 
											 
											 [UIImage imageNamed:ICON_LIST],
											 [UIImage imageNamed:ICON_PREV_RESULT], 											 
											 [UIImage imageNamed:ICON_NEXT_RESULT],																				 
											 
											 nil]];
	
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.frame = CGRectMake(0, 0, 180, 42);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;

	segmentedControl.momentary = YES;

	UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
	[segmentedControl release];

	self.navigationItem.rightBarButtonItem = segmentBarItem;
	[segmentBarItem release];
	
	///----------------------------------
	pins = [[NSMutableArray alloc] init];
	pins_tmp = [[NSMutableArray alloc] init];
	
	validation_categories = [[NSArray alloc] initWithObjects:
						@"restaurant", @"cafe", @"Bakeries", 
						@"dessert", @"coffee", @"donut", 
						@"bagel", @"ice cream", @"smoothie", 
						@"bar", nil]; 
	
	locationList = [[LocationDataList alloc] init]; 

	newQuery = YES;
	//result cursor
	start = 1;
	curr_start = 1 ;
	if( locMan == nil ){
		//Initialize location manager
		locMan = [[CLLocationManager alloc] init];
		locMan.delegate = self;
		locMan.desiredAccuracy = kCLLocationAccuracyBest;
		locMan.distanceFilter = 3218; //2 miles

		[locMan startUpdatingLocation];	
	}

}

-(void) viewWillAppear: (BOOL)animated {
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	
	// make sure to call the same method on the super class!!!
	[super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated{

	if( working )
		return;

		if( locMan.location != nil &&  newQuery ){
			//New query
			start = 1;
			curr_start = 1;
			[self clearAnnotations];
			[locationList clear];
			[self fetchRestaurants:locMan.location];	
			
		}
}

//*******************************************
//MKMapView delegate methods
//*******************************************

- (MKAnnotationView *)mapView:(MKMapView *)mapView
			viewForAnnotation:(id <MKAnnotation>)annotation {
	
	MKPinAnnotationView *view = nil;
	
	if(annotation != mapView.userLocation) {

		Restaurant *r = annotation;

		view = (MKPinAnnotationView *)
			[mapView dequeueReusableAnnotationViewWithIdentifier:@"identifier" ];
		if(nil == view) {
			view = [[[MKPinAnnotationView alloc]
					 initWithAnnotation:annotation reuseIdentifier:@"identifier" ]
					autorelease];
		}
		if( r.rating > 3.5 )
			[view setPinColor:MKPinAnnotationColorGreen];
		else if( r.rating > 1.5 )
			[view setPinColor:MKPinAnnotationColorPurple];
		else
			[view setPinColor:MKPinAnnotationColorRed];
		
		[view setCanShowCallout:YES];
		view.rightCalloutAccessoryView =
			[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		
		[view setAnimatesDrop:YES];
	} 
	return view;
}

//Code for the map pin callout
- (void)mapView:(MKMapView *)mapView 
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control {
	Restaurant *r = (Restaurant *)view.annotation;

	[r printDetails];
	LocationDetails	*locD = [[LocationDetails alloc] initWithNibName:
							 @"LocationDetails" bundle:nil];
	[locD setDetails:r location:locMan.location];
	
	[self.navigationController pushViewController:locD 
						animated:YES];
	[locD release];
		
}

//*******************************************
//END MapView delegate methods
//*******************************************

- (void) setCurrentLocation: (CLLocation *)location {
	
	//Find max range
	Restaurant *annotation;
	float maxLat;
	float maxLong;
	float minLat, minLong;
	if( localSearch  )
	{
		maxLat = location.coordinate.latitude;
		maxLong = location.coordinate.longitude;
		minLat = maxLat;
		minLong = maxLong;
	}
	else
	{
		if( [pins count] !=0 )
		{
			annotation = [pins objectAtIndex:0];
			maxLat = annotation.latitude;
			maxLong = annotation.longitude;			
			minLat = maxLat;
			minLong = maxLong;		
		}
		else
		{
			maxLat = 71.6f;
			maxLong = -40.0f;			
			minLat = 30.0f;
			minLong = -160.0f;					
		}
	}
	
	for (annotation in pins){
		if( maxLat < annotation.latitude )
			maxLat = annotation.latitude;
		if( minLat > annotation.latitude )
			minLat = annotation.latitude;

		if( maxLong < annotation.longitude )
			maxLong = annotation.longitude;
		if( minLong > annotation.longitude )
			minLong = annotation.longitude;
		//NSLog(@"maxlat = %f, minLat = %f, maxLong = %f, minLOng = %f, aLat=%f, along=%f", maxLat, minLat, maxLong, minLong, annotation.latitude, annotation.longitude);
	}
	//NSLog(@"maxlat = %f, minLat = %f, maxLong = %f, minLOng = %f", maxLat, minLat, maxLong, minLong);
	MKCoordinateRegion region;
	float latDelta = (maxLat - minLat)<0?-1*(maxLat - minLat):(maxLat - minLat);
	latDelta = 1.12*latDelta;
	region.span.latitudeDelta = latDelta;
	region.span.longitudeDelta = (maxLong - minLong)<0?-1*(maxLong - minLong):(maxLong - minLong);
	region.center.latitude = (minLat+maxLat)/2.0;
	region.center.latitude += (0.04 * latDelta);
	region.center.longitude = (minLong + maxLong)/2.0;
	
	[self.map setRegion:region animated:YES];

}

- (void) showAlert:(NSString *)title :(NSString *) message
{
	UIAlertView *alert = 
	[[[UIAlertView alloc] initWithTitle:title 
								message:message
							   delegate:self 
					  cancelButtonTitle:@"OK" 
					  otherButtonTitles:nil] autorelease];
	[alert show];	
}

//***************************************************************************************************
// Methods for showing/hinding working popup
//***************************************************************************************************
- (BOOL) isWorking {
	return working;
}

- (void) startWorking {
	working = YES;
	working_view.hidden = !working;
	[activityView startAnimating];
}


- (void) stopWorking {
	working = NO;
	working_view.hidden = !working;
	[activityView stopAnimating];
}
//***************************************************************************************************
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
	[pins release];
	[pins_tmp release];
	//[curElement release];
	[locMan stopUpdatingLocation];
	[locMan release];
	locMan = nil;
	//[cqueryStr release];
	[queryStr release];
	[searchTerm release];
	[validation_categories release];
	[locationList release];
	[statusLabel release];
	[working_view release];
	[searchLoc release];
    [super dealloc];
}


@end
