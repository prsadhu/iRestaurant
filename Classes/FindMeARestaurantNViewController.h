//
//  FindMeARestaurantNViewController.h
//  FindMeARestaurantN
//
//  Created by Praveen Sadhu on 12/20/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlipsideViewController.h"

@class MapViewController;

@interface FindMeARestaurantNViewController : UIViewController
				<UIPickerViewDelegate, UIPickerViewDataSource, FlipsideViewControllerDelegate>{

	IBOutlet UIPickerView *rtypePicker;
	IBOutlet UITextField *searchBox;
	IBOutlet UIButton *btnSearch;
					
	MapViewController *mapViewController;
	
	//Reference array
	NSArray *restaurantTypes;
	NSInteger selection;
	NSDictionary *restaurantKV;
	NSMutableDictionary *alphabetOrder;
	NSString *searchLoc;				
					
}

-(IBAction) hideKeyboard;
-(IBAction) buttonOnClick:(id)sender;
-(IBAction) txtBoxOnGo:(id)sender;
-(IBAction) showInfo;
-(void) showTheMap;
-(void) populateKV;
-(void) syncAlphabets:(NSString *)str;
-(void) setSearchLocation:(NSString *)str;



@property (retain, nonatomic) UIPickerView *rtypePicker;
@property (retain, nonatomic) UITextField *searchBox;
@property (retain, nonatomic) UIButton *btnSearch;
@property (retain, nonatomic) NSString *searchLoc;
@end

