//
//  LocationListCell.h
//  FindMeARestaurantN
//
//  Created by Praveen Sadhu on 12/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Restaurant;

@interface LocationListCell : UITableViewCell {

	IBOutlet UILabel *title;
	IBOutlet UILabel *address;
	IBOutlet UILabel *distance;
	IBOutlet UILabel *rating;
	IBOutlet UIImageView *rating_image;
	IBOutlet UIButton *leftButton;
}


@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UILabel *address;
@property (nonatomic, retain) UILabel *distance;
@property (nonatomic, retain) UILabel *rating;
@property (nonatomic, retain) UIImageView *rating_image;
@property (nonatomic, retain) UIButton *leftButton;

-(void)setData:(Restaurant *)restaurant;

@end
