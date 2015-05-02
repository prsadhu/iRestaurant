//
//  FindMeARestaurantNViewController.m
//  FindMeARestaurantN
//
//  Created by Praveen Sadhu on 12/20/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "FindMeARestaurantNViewController.h"
#import "MapViewController.h"
#import "LocationDetails.h"
#import "LocationListView.h"
#import "FlipsideView.h"

@implementation FindMeARestaurantNViewController


@synthesize rtypePicker;
@synthesize searchBox;
@synthesize searchLoc;
@synthesize btnSearch;


-(IBAction) hideKeyboard{
	[searchBox resignFirstResponder];
	NSString *pname;
	NSArray *slist = [[restaurantKV allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	int i = 0;
	for( pname in slist )
	{
		NSRange rng = [pname  rangeOfString:searchBox.text options:NSCaseInsensitiveSearch];
		if( rng.length > 0 && rng.location == 0 ){
			searchBox.text = pname;
			[rtypePicker selectRow:i inComponent:1 animated:NO];
			[self syncAlphabets:pname];
			selection = i;
			break;
		}
		i++;
	}
	
}


-(IBAction) buttonOnClick:(id)sender{
	[self showTheMap];
}

-(IBAction) txtBoxOnGo:(id)sender{
	if( ![searchBox.text isEqualToString:@""] ){
		[searchBox resignFirstResponder];
		[self showTheMap];
	}
}


-(void) showTheMap {
	
	NSString *selectedType;
	BOOL textsearch = YES;
	NSArray *sortedArray =  [[restaurantKV allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	if( [searchBox.text isEqualToString:@"" ] || searchBox.text == nil )
		textsearch = NO;
	else
	{
		//Check if the text search exists in the picker				
		if([[sortedArray objectAtIndex:selection] caseInsensitiveCompare:searchBox.text] == 0 )
			textsearch = NO;
	}
	
	if( mapViewController == nil )
		mapViewController = [[MapViewController alloc] initWithNibName:
							 @"MapViewController" bundle:nil];
	
	if( !textsearch)
	{
		
		selectedType  = [[NSString alloc] initWithString:[restaurantKV objectForKey:[sortedArray objectAtIndex:selection]]];
	}
	else 
	{
		NSString *tmp = [[NSString alloc] initWithString:[searchBox.text stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
		selectedType = [[NSString alloc] initWithFormat:@"+%@", tmp] ; //General category
		[tmp release];
	}
		
	if( !searchLoc )
		NSLog(@"IS NULL ");
	NSString *tmp = [[NSString alloc] initWithString:[searchLoc stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
	[mapViewController setQueryString:selectedType searchFor:searchBox.text  atlocation:tmp ];

	[self.navigationController pushViewController:
			mapViewController animated:YES];

	[selectedType release];
	[tmp release];
	
}

#pragma mark UIPickerViewDataSource methods
-(NSInteger) pickerView: (UIPickerView*) pickerView
	numberOfRowsInComponent: (NSInteger) component {
	//return [restaurantTypes count];
	if( component == 1 )
		return [[restaurantKV allKeys] count];
	else
		return [[alphabetOrder allKeys] count];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 2;
}

#pragma mark UIPickerViewDelegate methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row
			forComponent:(NSInteger)component {
	//return [[restaurantKV allKeys] objectAtIndex:row];

	if( component == 1 )
		return [[[restaurantKV allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] objectAtIndex:row];
	else
		return [[[alphabetOrder allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
		if( component == 0 )
			return 60.0f;
		else
			return 230.0f;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
	   inComponent:(NSInteger)component {
	if( component == 1 )
	{
		selection = row;
		searchBox.text = @"";
	}
	else if( component == 0 )
	{
		searchBox.text = @"";
		NSString *selectedStr = [[[alphabetOrder allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] objectAtIndex:row];
		NSArray *arr = [[restaurantKV allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
		NSString *cmp;
		int sel = 0;
		for (cmp in arr )
		{
			if( [selectedStr caseInsensitiveCompare:[cmp substringWithRange:NSMakeRange( 0, 1 )]] == 0 )
				 break;
			 sel++;	 
		}
		[pickerView selectRow:sel inComponent:1 animated:YES];
		selection = sel;
	}
}

-(void) syncAlphabets:(NSString *)str
{
	NSArray *arr = [[alphabetOrder allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	NSString *cmp;
	int sel = 0;
	for (cmp in arr )
	{
		if( [cmp caseInsensitiveCompare:[str substringWithRange:NSMakeRange( 0, 1 )]] == 0 )
			break;
		sel++;	 
	}
	[rtypePicker selectRow:sel inComponent:0 animated:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self populateKV];
	[rtypePicker selectRow:3 inComponent:1 animated:NO];
	if( !searchLoc )
		searchLoc = [[NSString alloc] initWithString:@""];
	selection = 3;
}

-(void) viewWillAppear: (BOOL)animated {
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	
	// make sure to call the same method on the super class!!!
	[super viewWillAppear:animated];
	
}


-(void) populateKV{

	//Sample query http://local.yahooapis.com/LocalSearchService/V3/localSearch?appid=YahooDemo&query=SANDWHICH+restaurant&zip=94306&results=20&start=1

	restaurantKV = [[NSDictionary alloc] initWithObjectsAndKeys:
					@"&category=96926150",  @"Afghani",
					@"&category=96929081",  @"African",
					@"&category=96926237",  @"American",
					@"",  @"Any",
					@"&category=96926174",  @"Australian",
					@"&category=96926173",  @"Bagel & Donut Shops",
					@"&category=96926147",  @"Bakeries",
					@"&category=96926158",  @"Barbecue",
					@"&category=96926223",  @"Bistro",
					@"&category=96929150",  @"Brazilian",
					@"&category=96926172",  @"Breakfast",
					@"&category=96926171",  @"Brewpubs",
					@"&category=96926212",  @"Buffets",
					@"&category=96926157",  @"Burgers",
					@"&category=96926166",  @"Burmese",
					@"&category=96926219",  @"Cafes",
					@"&category=96926156",  @"Cajun",
					@"&category=96926155",  @"Californian",
					@"&category=96926170",  @"Caribbean",
					@"&category=96926234",  @"Carry Out & Take Out",
					@"&category=96926164",  @"Chinese",
					@"&category=96926169",  @"Coffee Houses",
					@"&category=96926233",  @"Continental",
					@"&category=96926220",  @"Crepe",
					@"&category=96926230",  @"Cuban",
					@"&category=96926146",  @"Delicatessens",
					@"&category=96926202",  @"Desserts",
					@"&category=96926201",  @"Eclectic",
					@"&category=96926197",  @"English",
					@"&category=96929078",  @"Ethiopian",
					@"&category=96926217",  @"Family Style",
					@"&category=96926242",  @"Fast Food",
					@"&category=96926162",  @"Filipino",
					@"&category=96926195",  @"French",
					@"&category=96926194",  @"German",
					@"&category=96926193",  @"Greek",
					@"&category=96926213",  @"Grill",
					@"&category=96926232",  @"Hawaiian",
					@"&category=96926228",  @"Healthy",
					@"&category=96926192",  @"Hungarian",
					@"&category=96926149",  @"Ice Cream & Yogurt",
					@"&category=96926161",  @"Indian",
					@"&category=96926160",  @"Indonesian",
					@"&category=96926241",  @"Internet Cafes",
					@"&category=96926191",  @"Irish",
					@"&category=96926190",  @"Italian",
					@"&category=96926210",  @"Japanese",
					@"&category=96926209",  @"Korean",
					@"&category=96926182",  @"Kosher",
					@"&category=96926181",  @"Latin American",
					@"&category=96929177",  @"Lebanese",
					@"&category=96926208",  @"Malaysian",
					@"&category=96926227",  @"Mediterranean",
					@"&category=96929155",  @"Mexican",
					@"&category=96926240",  @"Middle Eastern",
					@"&category=96926180",  @"Noodle Shops",
					@"&category=96926207",  @"Pakistani",
					@"&category=96929154",  @"Peruvian",
					@"&category=96926243",  @"Pizza",
					@"&category=96926189",  @"Polish",
					@"&category=96926206",  @"Russian",
					@"&category=96926225",  @"Salad",
					@"&category=96926238",  @"Sandwiches",
					@"&category=96926179",  @"Seafood",
					@"&category=96926231",  @"Smoothies",
					@"&category=96926154",  @"Soul Food",
					@"&category=96926229",  @"Southeast Asian",
					@"&category=96926153",  @"Southern",
					@"&category=96926186",  @"Spanish",
					@"&category=96926151",  @"Steak Houses",
					@"&category=96926205",  @"Sushi",
					@"&category=96926185",  @"Swiss",
					@"&category=96926184",  @"Tapas",
					@"&category=96926168",  @"Tex-Mex",
					@"&category=96926203",  @"Thai",
					@"&category=96926177",  @"Tibetan",
					@"&category=96926176",  @"Turkish",
					@"&category=96926239",  @"Vegetarian",
					@"&category=96926175",  @"Vietnamese",															
				nil];
	NSArray *sorted = [[restaurantKV allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	alphabetOrder = [[NSMutableDictionary alloc] init];
	NSString *ele;
	for( ele in sorted )
	{
		[alphabetOrder setValue:ele forKey:[ele substringWithRange:NSMakeRange( 0, 1 )]];
	}
}

//***********************************************************************************
//FlipView methods
//***********************************************************************************

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	FlipsideView *backView = (FlipsideView *) controller.view;
	controller.delegate = self;
	backView.txtLocationBox.text = searchLoc;
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

-(void) setSearchLocation:(NSString *)str
{
	if( str )
	{
		if( searchLoc ){
			[searchLoc release];
			searchLoc = nil;
		}
			
		searchLoc = [[NSString alloc] initWithString:str];
		NSLog(@"location = %@", searchLoc);
		NSString *tmp;
		if( ![str isEqual:@""]){
			tmp = [[NSString alloc] initWithFormat:@"Find near %@", searchLoc];			
		}
		else
			tmp = [[NSString alloc] initWithFormat:@"Find near me!"];

		[btnSearch setTitle:tmp forState:UIControlStateNormal];
		[tmp release];
	}
}

//***********************************************************************************
// END FlipView methods
//***********************************************************************************

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
	[rtypePicker release];
	[searchBox release];
	[alphabetOrder release];
	[restaurantKV release];
	[searchLoc release];
	[btnSearch release];
    [super dealloc];
}

@end
